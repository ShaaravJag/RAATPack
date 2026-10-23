"""Load, analyse and report on every bundled sample file.

    python -m scripts.verify_demo_data            # all modules
    python -m scripts.verify_demo_data scb dct    # just these
    python -m scripts.verify_demo_data --quiet     # one line per module

Every file goes through the same code path the application uses -- ``analysis.load_data`` and
``analysis.run_file`` -- so a pass here means the app can open the file, not merely that some
parser can. Where the v2 reference report gives a number, the deviation is printed and judged
against the tolerances in ``tests/golden/values.json``; where it does not, the file is checked
for liveness instead (it parses, it analyses, the headline numbers are finite).

Exits non-zero if any file fails, so this can run in CI.
"""
from __future__ import annotations

import argparse
import json
import sys
import traceback
from pathlib import Path
from typing import Any, Dict, List, Optional, Tuple

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parent))

import numpy as np

from raatpack.api import analysis
from raatpack.api.state import LoadedFile
from raatpack.config import samples
from raatpack.config.samples import HIRSCH_INPUT, SampleFile, SampleSet
from raatpack.equations import dynamic_modulus as dm
from raatpack.io import ampt
from raatpack.io.templates import TemplateLibrary
from raatpack.modules import registry
from raatpack.numerics.matlab import excel_stats

GOLDEN = json.loads((HERE.parent / "tests" / "golden" / "values.json").read_text())
TOL = GOLDEN.get("tolerances", {})
DEFAULT_TOL = float(TOL.get("_default", 0.5))

OK, BAD, WARN = "PASS", "FAIL", "WARN"


# ---------------------------------------------------------------------------
# helpers
# ---------------------------------------------------------------------------

def tol_for(module: str, metric: str) -> Any:
    """A percent, or {"decimals": n} to compare at the report's own printed precision."""
    return TOL.get(module, {}).get(metric, DEFAULT_TOL)


def deviation_pct(value: float, golden: float) -> float:
    """Relative deviation in %, falling back to an absolute-percent reading when golden is 0."""
    if golden == 0:
        return abs(value) * 100.0
    return abs(value - golden) / abs(golden) * 100.0


def compare(value: float, golden: float, tol: Any) -> Tuple[bool, str]:
    """(ok, how it was judged). Percent tolerances read as a deviation; a `decimals` tolerance
    rounds to the precision the report printed, which is the only fair test when the printed
    rounding swamps any percentage -- a std dev printed as 0.01 is really 0.01 +- 0.005."""
    if isinstance(tol, dict) and "decimals" in tol:
        n = int(tol["decimals"])
        ok = abs(round(float(value), n) - float(golden)) < 1e-9
        return ok, f"{fmt(value)} -> {round(float(value), n)} vs report {fmt(golden)} at {n} dp"
    d = deviation_pct(float(value), float(golden))
    return d <= float(tol), f"{fmt(value)} vs report {fmt(golden)} -> {d:.3f}% > {tol}%"


def annotate(value: float, golden: float, tol: Any) -> str:
    """The cell text: a deviation, or the rounded value when judged at print precision."""
    if isinstance(tol, dict) and "decimals" in tol:
        return f"{fmt(value)} (={round(float(value), int(tol['decimals']))})"
    return f"{fmt(value)} ({deviation_pct(float(value), float(golden)):.2f}%)"


def fmt(v: Any) -> str:
    if v is None:
        return "-"
    if isinstance(v, bool):
        return "yes" if v else "no"
    if isinstance(v, (int, np.integer)):
        return f"{int(v):,}"
    if isinstance(v, (float, np.floating)):
        f = float(v)
        if not np.isfinite(f):
            return str(f)
        if f != 0 and (abs(f) < 1e-3 or abs(f) >= 1e7):
            return f"{f:.3e}"
        if abs(f) >= 1000:
            return f"{f:,.1f}"
        return f"{f:.4g}"
    return str(v)


def golden_rows(module: str) -> Dict[str, Dict[str, Any]]:
    """{relative file path: golden row} for the modules whose report lists several specimens."""
    g = GOLDEN.get(module)
    if not isinstance(g, dict):
        return {}
    if "rows" in g:
        return {r["file"]: r for r in g["rows"]}
    if "file" in g:
        return {g["file"]: g}
    return {}


def flags_for(module: str, res: Dict[str, Any]) -> Dict[str, Any]:
    """Qualitative outcomes worth pinning, which the headline numbers hide."""
    if module == "cold_scb":
        return {"tail_success": res.get("tail_success")}
    if module == "scb":
        return {"needs_pick": res.get("needs_pick"), "picked": res.get("picked")}
    if module == "hamburg":
        return {"left_sip": res.get("sip_cycles_left") is not None,
                "right_sip": res.get("sip_cycles_right") is not None}
    if module == "apa":
        present = [w for w in ("left", "center", "right") if res.get(f"{w}_rut_mm") is not None]
        return {"wheels": "+".join(present) or "none"}
    return {}


def row_count(data: Any) -> Optional[int]:
    for attr in ("x", "time", "cycles", "cycles_avg", "cycles_left", "frequencies_hz", "temps_f"):
        v = getattr(data, attr, None)
        if v is not None and np.ndim(v) == 1 and len(v):
            return len(v)
    return None


# ---------------------------------------------------------------------------
# one file
# ---------------------------------------------------------------------------

class Row:
    def __init__(self, label: str, group: str = ""):
        self.label = label
        self.group = group
        self.rows: Optional[int] = None
        self.status = OK
        self.metrics: Dict[str, str] = {}
        self.flags: Dict[str, Any] = {}
        self.messages: List[str] = []

    def fail(self, msg: str) -> "Row":
        self.status = BAD
        self.messages.append(msg)
        return self

    def warn(self, msg: str) -> "Row":
        if self.status != BAD:
            self.status = WARN
        self.messages.append(msg)
        return self


def check_file(s: SampleSet, f: SampleFile, lib: TemplateLibrary,
               gold: Dict[str, Dict[str, Any]], metric_keys: List[str]) -> Row:
    out = Row(f.name)
    path = s.file_path(f)
    if not path.exists():
        return out.fail("file missing from the sample folder")

    template = lib.get(s.template) if s.template else None
    try:
        data = analysis.load_data(s.module, path, template)
    except Exception as e:
        return out.fail(f"could not read: {type(e).__name__}: {e}")
    out.rows = row_count(data)
    if not out.rows:
        return out.fail("read produced no data rows")

    lf = LoadedFile(id="verify", name=f.name, path=str(path), template_id=s.template,
                    data=data, specimen_id=f.specimen_id, inputs=dict(s.dimensions))
    analysis.run_file(s.module, lf, {})
    if lf.error:
        return out.fail(lf.error)
    if lf.result is None:
        return out.fail("analysis returned no result")

    res = analysis.result_dict(s.module, lf)
    if s.module == "hamburg":                    # reported per wheel, not per specimen
        res = {**res.get("average", {}),
               **{f"{k}_left": v for k, v in res.get("left", {}).items()},
               **{f"{k}_right": v for k, v in res.get("right", {}).items()}}

    if s.module == "apa":
        mean, std, cov = excel_stats([res.get("left_rut_mm"), res.get("center_rut_mm"),
                                      res.get("right_rut_mm")])
        res = {**res, "avg": mean, "std": std, "cov": cov}

    out.flags = flags_for(s.module, res)
    for k, want in f.expect.items():
        got = out.flags.get(k)
        if got != want:
            out.fail(f"expected {k} = {want!r} but got {got!r} -- the manifest records this file's "
                     f"known behaviour, so either the data or the calculation changed")

    grow = gold.get(s.rel(f), {})
    for k in metric_keys:
        got = res.get(k)
        if k in grow and grow[k] is not None and isinstance(got, (int, float)) and got is not None:
            t = tol_for(s.module, k)
            ok, how = compare(float(got), float(grow[k]), t)
            out.metrics[k] = annotate(float(got), float(grow[k]), t)
            if not ok:
                out.fail(f"{k} = {how}")
        elif k in grow and grow[k] is None:
            out.metrics[k] = fmt(got)
            if got is not None:
                out.warn(f"{k} is {fmt(got)} but the report leaves it blank")
        else:
            out.metrics[k] = fmt(got)
            if isinstance(got, float) and not np.isfinite(got):
                out.fail(f"{k} is {got}")

    # liveness: a file with no reference numbers must still produce usable headline values
    if not grow:
        live = [k for k in metric_keys if isinstance(res.get(k), (int, float))
                and res.get(k) is not None and np.isfinite(float(res[k]))]
        if not live:
            out.fail("no finite headline values -- analysis produced nothing usable")
    return out


# ---------------------------------------------------------------------------
# dynamic modulus (its own reader and its own pipeline)
# ---------------------------------------------------------------------------

HAM_WHEEL_KEYS = ("max_rut_mm", "creep_slope", "stripping_slope", "sip_cycles")


def check_hamburg_file(s: SampleSet, f: SampleFile,
                       gold: Dict[str, Dict[str, Any]]) -> List[Row]:
    """One row per wheel plus the average, mirroring the report's own layout."""
    head = Row(f.name)
    path = s.file_path(f)
    if not path.exists():
        return [head.fail("file missing from the sample folder")]
    try:
        data = analysis.load_data(s.module, path, None)
    except Exception as e:
        return [head.fail(f"could not read: {type(e).__name__}: {e}")]

    lf = LoadedFile(id="verify", name=f.name, path=str(path), template_id=None, data=data,
                    specimen_id=f.specimen_id, inputs=dict(s.dimensions))
    analysis.run_file(s.module, lf, {})
    if lf.error:
        return [head.fail(lf.error)]
    res = analysis.result_dict(s.module, lf)
    grow = gold.get(s.rel(f), {})

    head.rows = row_count(data)
    head.flags = {"left_sip": res["left"].get("sip_cycles") is not None,
                  "right_sip": res["right"].get("sip_cycles") is not None}
    for k, want in f.expect.items():
        if head.flags.get(k) != want:
            head.fail(f"expected {k} = {want!r} but got {head.flags.get(k)!r} -- the manifest "
                      f"records this file's known behaviour, so either the data or the "
                      f"calculation changed")

    rows = [head]
    for side in ("left", "right", "average"):
        r = Row(f"    {side}")
        block = res[side]
        gblock = grow.get(side) if side != "average" else (
            {"sip_cycles": grow.get("avg_sip_cycles")} if grow else {})
        for k in HAM_WHEEL_KEYS:
            got = block.get(k)
            if gblock and k in gblock and gblock[k] is not None and got is not None:
                t = tol_for("hamburg", k)
                ok, how = compare(float(got), float(gblock[k]), t)
                r.metrics[k] = annotate(float(got), float(gblock[k]), t)
                if not ok:
                    head.fail(f"{side} {k} = {how}")
            elif gblock and k in gblock and gblock[k] is None:
                r.metrics[k] = fmt(got)
                if got is not None:
                    head.fail(f"{side} {k} is {fmt(got)} but the report leaves it blank")
            else:
                r.metrics[k] = fmt(got)
                if isinstance(got, float) and not np.isfinite(got):
                    head.fail(f"{side} {k} is {got}")
        if side != "average":
            r.flags = {"extrapolated": block.get("extrapolated"), "manual": block.get("manual")}
        rows.append(r)
    return rows


def check_dynamic_modulus(s: SampleSet) -> Tuple[List[Row], List[str]]:
    G_AMPT, G_MC, G_HIRSCH = "AMPT summary files", "Master curve", "Binder G* input"
    rows: List[Row] = []
    notes: List[str] = []
    g = GOLDEN.get("dynamic_modulus", {})

    summaries: Dict[str, List[Any]] = {}
    for f in s.specimens():
        out = Row(f.name, G_AMPT)
        path = s.file_path(f)
        if not path.exists():
            rows.append(out.fail("file missing from the sample folder"))
            continue
        try:
            a = ampt.read_ampt_summary(path)
        except Exception as e:
            rows.append(out.fail(f"could not read: {type(e).__name__}: {e}"))
            continue
        temp = ampt.guess_temperature_from_name(Path(f.name).name)
        out.rows = len(a.frequencies_hz)
        out.metrics = {
            "target_C": fmt(temp),
            "freqs": str(len(a.frequencies_hz)),
            "E_MPa_max": fmt(float(np.max(a.modulus_mpa))),
            "phase_max": fmt(float(np.max(a.phase_deg))),
        }
        if temp is None:
            out.fail("no temperature in the file name -- guess_temperature_from_name() returned None")
        if not len(a.frequencies_hz):
            out.fail("no frequencies parsed")
        rows.append(out)
        summaries.setdefault(f.specimen_id, []).append((temp, a))

    # the master curve, from all three replicates at all three temperatures
    mc_row = Row("EA master curve, 3 replicates x 3 temperatures", G_MC)
    try:
        reps, temps = [], []
        for rep in sorted(summaries):
            pairs = sorted(summaries[rep], key=lambda p: p[0])
            reps.append([a for _, a in pairs])
            temps.append([float(t) for t, _ in pairs])
        avg = dm.build_average_table(reps, temps)
        mc_row.rows = len(avg.frequency)
        emax = float(g["emax_psi"])
        mc = dm.fit_ea(avg.frequency, avg.target_temp_f, avg.logE, avg.E_psi, avg.phase,
                       emax, float(g["ref_temp_c"]))
        fr = g["first_row"]
        checks = [("E_psi", float(avg.E_psi[0]), float(fr["E_psi"])),
                  ("phase", float(avg.phase[0]), float(fr["phase"]))]
        for k, v in g["shift_log10"].items():
            checks.append(("shift", float(mc.shift_factors[k]), float(v)))
        for got, want in zip(mc.grid_y, g["grid_predicted_psi"]):
            checks.append(("predicted_E", float(got), float(want)))
        worst = {}
        for name, got, want in checks:
            t = tol_for("dynamic_modulus", name)
            ok, how = compare(got, want, t)
            if not ok:
                mc_row.fail(f"{name} = {how}")
            worst[name] = max(worst.get(name, 0.0), deviation_pct(got, want))
        mc_row.metrics = {"E*max_psi": fmt(emax),
                          **{f"worst Δ {k}": f"{v:.4f}%" for k, v in worst.items()}}
    except Exception:
        mc_row.fail("master curve failed:\n" + traceback.format_exc(limit=3))
    rows.append(mc_row)

    # the Hirsch binder G* workbook -- a different reader and a different role
    for f in s.files:
        if f.role != HIRSCH_INPUT:
            continue
        out = Row(f.name, G_HIRSCH)
        path = s.file_path(f)
        try:
            h = ampt.read_hirsch_input(path)
            v = dm.emax_hirsch(s.dimensions["Gmm"], s.dimensions["Gsb"],
                               s.dimensions["air_voids"], s.dimensions["ac_pct"])
            E = dm.hirsch_from_gstar(v.VMA, v.VFA, h.g_star_psi)
            out.rows = len(h.g_star_psi)
            out.metrics = {"temps_F": ",".join(fmt(t) for t in sorted(set(h.temps_f.tolist()))),
                           "G*_rows": str(len(h.g_star_psi)),
                           "VMA": fmt(v.VMA), "VFA": fmt(v.VFA),
                           "E*max_psi": fmt(v.EMAX),
                           "E_from_G*": f"{fmt(float(np.min(E)))} … {fmt(float(np.max(E)))}"}
            if not len(h.g_star_psi):
                out.fail("no G* rows parsed")
            if not np.all(np.isfinite(E)):
                out.fail("Hirsch E from G* contains non-finite values")
            d = deviation_pct(v.EMAX, float(g["emax_psi"]))
            notes.append(f"volumetrics reproduce the report's E*max to {d:.4f}%")
        except Exception as e:
            out.fail(f"{type(e).__name__}: {e}")
        rows.append(out)
    return rows, notes


# ---------------------------------------------------------------------------
# reporting
# ---------------------------------------------------------------------------

def metric_keys_for(module: str, gold: Dict[str, Dict[str, Any]]) -> List[str]:
    """Columns to print: the report's own numbers where we have them, else the headline results."""
    if gold:
        first = next(iter(gold.values()))
        keys = [k for k, v in first.items() if k not in ("file", "id")
                and (v is None or isinstance(v, (int, float)))]
        if module == "hamburg":
            keys = ["max_rut_mm", "creep_slope", "stripping_slope", "sip_cycles"]
        if keys:
            return keys[:7]
    spec = registry.get(module)
    return [f.key for f in spec.result_fields][:5]


def print_table(rows: List[Row], keys: List[str], indent: str = "  ") -> None:
    has_flags = any(r.flags for r in rows)
    cols = ["file", "rows"] + keys + (["notes"] if has_flags else []) + ["status"]
    data = []
    for r in rows:
        flag = ", ".join(f"{k}={fmt(v)}" for k, v in r.flags.items()) if has_flags else None
        data.append([r.label, fmt(r.rows)] + [r.metrics.get(k, "-") for k in keys]
                    + ([flag or "-"] if has_flags else []) + [r.status])
    width = [max(len(str(c)), *(len(str(d[i])) for d in data)) if data else len(str(c))
             for i, c in enumerate(cols)]
    width[0] = min(width[0], 52)
    head = indent + "  ".join(str(c).ljust(w) for c, w in zip(cols, width))
    print(head)
    print(indent + "-" * (len(head) - len(indent)))
    for r, d in zip(rows, data):
        d[0] = d[0][:52]
        print(indent + "  ".join(str(x).ljust(w) for x, w in zip(d, width)))
        for m in r.messages:
            for line in m.splitlines():
                print(indent + "    ! " + line)


def audit_folder(s: SampleSet) -> List[str]:
    """Anything on disk the manifest does not account for, and the reverse."""
    problems = []
    root = s.path()
    if not root.exists():
        return [f"sample folder missing: {root}"]
    declared = {f.name for f in s.files}
    on_disk = set()
    for p in sorted(root.rglob("*")):
        if not p.is_file() or p.suffix.lower() == ".pdf":
            continue
        rel = p.relative_to(root).as_posix()
        if samples.is_ignored(p.name):
            problems.append(f"ignored (not a data file): {rel}")
            continue
        on_disk.add(rel)
    for extra in sorted(on_disk - declared):
        problems.append(f"on disk but not in the manifest: {extra}")
    for missing in sorted(declared - on_disk):
        problems.append(f"in the manifest but not on disk: {missing}")
    return problems


def main(argv: Optional[List[str]] = None) -> int:
    ap = argparse.ArgumentParser(description="Verify every bundled sample file loads and analyses.")
    ap.add_argument("modules", nargs="*", help="module ids to check (default: all)")
    ap.add_argument("--quiet", action="store_true", help="one line per module")
    args = ap.parse_args(argv)

    wanted = args.modules or samples.modules()
    unknown = [m for m in wanted if samples.find(m) is None]
    if unknown:
        print(f"unknown module(s): {', '.join(unknown)}", file=sys.stderr)
        print(f"available: {', '.join(samples.modules())}", file=sys.stderr)
        return 2

    from raatpack.config.settings import BUILTIN_TEMPLATES_DIR, DATA_DIR, SAMPLES_DIR
    lib = TemplateLibrary(BUILTIN_TEMPLATES_DIR, DATA_DIR / "templates")

    print(f"sample data : {SAMPLES_DIR}")
    print(f"templates   : {BUILTIN_TEMPLATES_DIR}")
    print()

    totals = {OK: 0, BAD: 0, WARN: 0}
    failed_modules: List[str] = []

    for mid in wanted:
        s = samples.get(mid)
        spec = registry.get(mid)
        gold = golden_rows(mid)
        keys = metric_keys_for(mid, gold)

        if mid == "dynamic_modulus":
            rows, notes = check_dynamic_modulus(s)
            keys = []
        elif mid == "hamburg":
            rows, notes = [r for f in s.specimens() for r in check_hamburg_file(s, f, gold)], []
            keys = list(HAM_WHEEL_KEYS)
        else:
            rows = [check_file(s, f, lib, gold, keys) for f in s.specimens()]
            notes = []

        for r in rows:
            if r.label.startswith("    "):
                continue                     # detail line, counted under its file
            totals[r.status] += 1
        bad = [r for r in rows if r.status == BAD]
        if bad:
            failed_modules.append(mid)

        if args.quiet:
            mark = "FAIL" if bad else "ok  "
            print(f"{mark}  {spec.short:<16} {len(rows) - len(bad)}/{len(rows)} files")
            for r in bad:
                print(f"        {r.label}: {r.messages[0] if r.messages else 'failed'}")
            continue

        head = f"{spec.short}  ·  {len(rows)} file(s)"
        print(head)
        print("=" * len(head))
        print(f"  template   : {s.template or '(fixed format — no template)'}")
        if s.dimensions:
            print("  dimensions : " + "  ".join(f"{k}={fmt(v)}" for k, v in s.dimensions.items()))
        print(f"  reference  : {s.reference_pdf or 'none — no v2 report ships for this module'}")
        if s.dimensions_source:
            print(f"  dims from  : {s.dimensions_source}")
        if s.note:
            print(f"  note       : {s.note}")
        for n in notes:
            print(f"  note       : {n}")
        for p in audit_folder(s):
            print(f"  folder     : {p}")
        print()
        if any(r.group for r in rows):
            seen: List[str] = []
            for r in rows:
                if r.group not in seen:
                    seen.append(r.group)
            for grp in seen:
                part = [r for r in rows if r.group == grp]
                gkeys = [k for k in dict.fromkeys(k for r in part for k in r.metrics)]
                print(f"  {grp}")
                print_table(part, gkeys, indent="    ")
                print()
        elif keys:
            print_table(rows, keys)
            print()
        else:
            print_table(rows, sorted({k for r in rows for k in r.metrics}))
            print()

    n = sum(totals.values())
    print("-" * 72)
    print(f"{n} checks: {totals[OK]} pass, {totals[WARN]} warn, {totals[BAD]} fail")
    if failed_modules:
        print(f"failing modules: {', '.join(failed_modules)}")
    return 1 if totals[BAD] else 0


if __name__ == "__main__":
    raise SystemExit(main())
