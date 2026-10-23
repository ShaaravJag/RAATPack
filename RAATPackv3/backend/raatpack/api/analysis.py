"""
Module dispatch: reading a raw file for a module, running its kernel, and serialising results
and chart payloads. Keeps the route handlers thin.
"""
from __future__ import annotations

import math
from pathlib import Path
from typing import Any, Dict, List, Optional

import numpy as np

from ..equations import ideal_ct, scb, cold_scb, dct, htidt, bond, apa, hamburg, beam
from ..equations._base import clean
from ..io import readers, ipc
from ..io.templates import Template
from ..config import samples
from ..modules import registry
from ..numerics.matlab import excel_stats
from .state import LoadedFile, Workspace

MAX_PREVIEW_POINTS = 800


# ---------------------------------------------------------------------------
# Reading
# ---------------------------------------------------------------------------

def load_data(module_id: str, path: Path, template: Optional[Template]):
    m = registry.get(module_id)
    if samples.is_ignored(Path(path).name):
        # Excel leaves "~$Book.xlsx" lock files beside open workbooks; they are a few hundred
        # bytes of metadata, not a zip, so reading one raises BadZipFile. Refuse by name instead.
        raise readers.NotADataFile(
            f"{Path(path).name} is not test data — it is the temporary lock file Excel creates "
            f"while a workbook is open. Add the workbook itself instead.")
    if m.reader == registry.READER_XY:
        return readers.read_xy(path, template)
    if m.reader == registry.READER_SCB:
        return readers.read_scb_xy(path, template)
    if m.reader == registry.READER_FOUR:
        return readers.read_four_channel(path, template)
    if m.reader == registry.READER_BEAM:
        return readers.read_beam(path, template)
    if m.reader == registry.READER_APA:
        return ipc.read_apa(path)
    if m.reader == registry.READER_HAM:
        return ipc.read_hamburg(path)
    raise ValueError(f"module {module_id} has no file reader")


def _downsample(x, y, n=MAX_PREVIEW_POINTS):
    x = np.asarray(x, float)
    y = np.asarray(y, float)
    if len(x) <= n:
        return x.tolist(), y.tolist()
    idx = np.unique(np.concatenate([np.linspace(0, len(x) - 1, n).astype(int), [int(np.argmax(y))]]))
    return x[idx].tolist(), y[idx].tolist()


def primary_xy(module_id: str, lf: LoadedFile):
    """The (x, y) curve the module plots by default."""
    m = registry.get(module_id)
    d = lf.data
    if m.reader in (registry.READER_XY, registry.READER_SCB):
        x, y = np.asarray(d.x), np.asarray(d.y)
        if lf.trim_x is not None and m.supports_trim:
            x, y = readers.scb_begin_trim(x, y, lf.trim_x)
        return x, y
    if module_id == "cold_scb":
        return d.stroke, d.load
    if module_id == "dct":
        if lf.result is not None:
            return lf.result.fitted_cod, d.load
        return d.cod, d.load
    if module_id == "apa":
        return d.cycles_avg, d.avg
    if module_id == "hamburg":
        return d.cycles_left, d.left
    if module_id == "beam":
        return d.cycles, d.stiffness
    return np.array([]), np.array([])


def file_summary(module_id: str, lf: LoadedFile) -> Dict[str, Any]:
    x, y = primary_xy(module_id, lf) if lf.data is not None else ([], [])
    px, py = _downsample(x, y) if len(x) else ([], [])
    out = dict(id=lf.id, name=lf.name, template_id=lf.template_id, specimen_id=lf.specimen_id,
               inputs=lf.inputs, picks=lf.picks, trim_x=lf.trim_x, error=lf.error, n_points=int(len(x)),
               preview={"x": px, "y": py})
    if lf.result is not None:
        out["result"] = result_dict(module_id, lf)
    return out


# ---------------------------------------------------------------------------
# Running
# ---------------------------------------------------------------------------

def _req(lf: LoadedFile, keys: List[str], labels: Optional[Dict[str, str]] = None):
    missing = [k for k in keys if lf.inputs.get(k) in (None, "")]
    if missing:
        # Label, not database key: "thickness_mm" meant nothing to the technician reading it.
        named = [(labels or {}).get(k, k) for k in missing]
        plural = "s" if len(named) > 1 else ""
        raise ValueError(f"Enter {' and '.join(named)} for this specimen "
                         f"({len(named)} required value{plural} missing).")


def run_file(module_id: str, lf: LoadedFile, options: Dict[str, Any]) -> None:
    m = registry.get(module_id)
    lf.error = None
    lf.result = None
    try:
        _req(lf, m.required_inputs, {f.key: f.label for f in m.specimen_inputs})
        I = {k: float(v) for k, v in lf.inputs.items() if v not in (None, "")}
        d = lf.data
        if module_id == "ideal_ct":
            x, y = primary_xy(module_id, lf)
            lf.result = ideal_ct.analyse(x, y, I["thickness_mm"], I["diameter_mm"])
        elif module_id == "htidt":
            x, y = primary_xy(module_id, lf)
            lf.result = htidt.analyse(x, y, I["thickness_mm"], I["diameter_mm"])
        elif module_id == "bond":
            x, y = primary_xy(module_id, lf)
            lf.result = bond.analyse(x, y, I["diameter_mm"], I["length_mm"])
        elif module_id == "scb":
            x, y = primary_xy(module_id, lf)
            pick = lf.picks.get("inflection")
            if pick is not None:
                lf.result = scb.evaluate_at(x, y, I["thickness_mm"], I["ligament_mm"], float(pick))
            else:
                lf.result = scb.analyse(x, y, I["thickness_mm"], I["ligament_mm"])
        elif module_id == "cold_scb":
            lf.result = cold_scb.analyse(d.time, d.stroke, d.load, d.cod, I["thickness_mm"], I["radius_mm"], I["notch_mm"])
        elif module_id == "dct":
            lf.result = dct.analyse(d.time, d.stroke, d.load, d.cod, I["thickness_mm"], I["ligament_mm"])
        elif module_id == "apa":
            lf.result = apa.analyse(d)
        elif module_id == "hamburg":
            pl = {k[:-5]: v for k, v in lf.picks.items() if k.endswith("_left") and v is not None}
            pr = {k[:-6]: v for k, v in lf.picks.items() if k.endswith("_right") and v is not None}
            lf.result = hamburg.analyse(d.cycles_left, d.left, d.cycles_right, d.right, pl or None, pr or None)
        elif module_id == "beam":
            lf.result = beam.analyse(d.cycles, d.stiffness, d.modulus, d.normalized_modulus)
        else:
            raise ValueError(f"unknown module {module_id}")
    except ValueError as e:     # the kernels raise ValueError to say something to the operator
        lf.error = str(e)
    except Exception as e:      # keep going for the other files; surface the message per file
        # An unexpected class is a bug rather than a message, so keep its name for the log.
        lf.error = f"{type(e).__name__}: {e}"


def result_dict(module_id: str, lf: LoadedFile) -> Dict[str, Any]:
    m = registry.get(module_id)
    r = lf.result
    if r is None:
        return {}
    out: Dict[str, Any] = {}
    if module_id == "hamburg":
        for side in ("left", "right"):
            w = getattr(r, side)
            out[side] = {f.key: clean(getattr(w, f.key)) for f in m.result_fields}
            out[side].update(sip_ratio=clean(w.sip_ratio), extrapolated=w.extrapolated, manual=w.manual,
                             needs_pick=bool(w.needs_pick),
                             strip_location=clean(w.strip_location), creep_location=clean(w.creep_location))
        out["average"] = dict(max_rut_mm=clean(r.avg_max_rut_mm), creep_slope=clean(r.avg_creep_slope),
                              stripping_slope=clean(r.avg_stripping_slope), sip_cycles=clean(r.avg_sip_cycles))
        out["needs_pick"] = bool(r.needs_pick)
        return out
    for f in m.result_fields:
        out[f.key] = clean(getattr(r, f.key, None))
    if module_id == "scb":
        out.update(needs_pick=bool(r.needs_pick), picked=bool(r.picked), inflection_x=clean(r.inflection_x),
                   inflection_y=clean(r.inflection_y), candidates=clean(r.auto_candidates))
    if module_id == "cold_scb":
        out.update(tail_success=bool(r.tail_success), tail_A=clean(r.tail_A), tail_B=clean(r.tail_B))
    if module_id == "beam":
        out.update(astm_coeffs=clean(r.astm_coeffs))
    if module_id == "apa":
        out.update(wheels=r.wheels)
    return out


# ---------------------------------------------------------------------------
# Chart payloads (full resolution + construction overlays)
# ---------------------------------------------------------------------------

def _ov(name, x, y, style="line", color=None, **kw):
    d = dict(name=name, x=clean(np.asarray(x, float)), y=clean(np.asarray(y, float)), style=style, color=color)
    d.update(kw)
    return d


def curve_payload(module_id: str, lf: LoadedFile) -> Dict[str, Any]:
    m = registry.get(module_id)
    d = lf.data
    r = lf.result
    x, y = primary_xy(module_id, lf)
    payload: Dict[str, Any] = dict(id=lf.id, name=lf.specimen_id or lf.name, x_label=m.x_label, y_label=m.y_label,
                                   series=[_ov(lf.specimen_id or lf.name, x, y)], overlays=[], secondary=None,
                                   log_x=False, log_y=False)
    if r is None:
        if module_id == "hamburg":
            payload["series"] = [_ov("Left wheel", d.cycles_left, d.left), _ov("Right wheel", d.cycles_right, d.right)]
        if module_id == "apa":
            payload["series"] += [s for s, c in ((_ov("Left", d.cycles_left, d.left[1:], color="#888"), d.cycles_left),
                                                 (_ov("Center", d.cycles_center, d.center[1:], color="#aaa"), d.cycles_center),
                                                 (_ov("Right", d.cycles_right, d.right[1:], color="#bbb"), d.cycles_right)) if len(c)]
        return payload
    ov = payload["overlays"]
    if module_id == "ideal_ct":
        xs, ys = x[r.window_start_index: r.window_end_index + 1], y[r.window_start_index: r.window_end_index + 1]
        ov.append(_ov("85–65 % slope window", xs, ys, "band", "#ed7d31"))
        ov.append(_ov("Slope S", r.slope_line_x, r.slope_line_y, "dashed", "#c00000"))
        ov.append(_ov("L (75 % of peak)", [r.L_point[0]], [r.L_point[1]], "marker", "#2e7d32"))
        ov.append(_ov("Peak", [x[r.peak_index]], [y[r.peak_index]], "marker", "#1f4e79"))
        payload["shade"] = dict(name="Work (Gf)", x=clean(x), y=clean(y))
    elif module_id in ("htidt", "bond"):
        ov.append(_ov("Peak", [x[r.peak_index]], [y[r.peak_index]], "marker", "#c00000"))
    elif module_id == "scb":
        f = r.fit
        ov.append(_ov("Post-peak 6th-order fit", f.window_x, f.fitted, "dashed", "#7030a0"))
        ov.append(_ov("Tangent at inflection", r.line_x, r.line_y, "dashed", "#c00000"))
        ov.append(_ov("Inflection point", [r.inflection_x], [r.inflection_y], "marker", "#c00000"))
        cand = [c for c in r.auto_candidates if c != r.inflection_x]
        if cand:
            ov.append(_ov("Other candidate roots", cand, np.interp(cand, x, y), "marker", "#999"))
        payload["shade"] = dict(name="Work (Gf)", x=clean(x), y=clean(y))
        payload["needs_pick"] = bool(r.needs_pick)
    elif module_id == "cold_scb":
        ov.append(_ov("Pre-peak stiffness", r.stiffness_line_x, r.stiffness_line_y, "dashed", "#2e7d32"))
        if r.tail_success:
            ov.append(_ov("Extrapolated tail", r.tail_x, r.tail_y, "dashed", "#c00000"))
            payload["shade_tail"] = dict(name="W_tail", x=clean(r.tail_x), y=clean(r.tail_y))
        ov.append(_ov("Tail fit start (60 %)", [x[r.tail_start_index]], [y[r.tail_start_index]], "marker", "#ed7d31"))
        ov.append(_ov("Peak", [x[r.peak_index]], [y[r.peak_index]], "marker", "#1f4e79"))
        payload["shade"] = dict(name="W", x=clean(x), y=clean(y))
        payload["secondary"] = dict(title="COD gauge vs time", x_label="Time (s)", y_label="COD (mm)",
                                    series=[_ov("COD", d.time, d.cod), _ov("OLS fit", d.time, r.cmod_slope_mm_per_s * d.time + r.cmod_intercept, "dashed", "#c00000")])
    elif module_id == "dct":
        ov.append(_ov("Peak", [x[r.peak_index]], [y[r.peak_index]], "marker", "#1f4e79"))
        payload["shade"] = dict(name="Work (Gf)", x=clean(x), y=clean(y))
        payload["secondary"] = dict(title="CMOD vs time (rate check)", x_label="Time (s)", y_label="CMOD (mm)",
                                    series=[_ov("Measured COD", d.time, d.cod), _ov("Fitted CMOD (through origin)", d.time, r.fitted_cod, "dashed", "#c00000")])
    elif module_id == "apa":
        for nm, c, v, col in (("Left", d.cycles_left, d.left[1:], "#1f4e79"), ("Center", d.cycles_center, d.center[1:], "#7030a0"), ("Right", d.cycles_right, d.right[1:], "#2e7d32")):
            if len(c):
                payload["series"].append(_ov(f"{nm} wheel", c, v, color=col))
    elif module_id == "hamburg":
        payload["series"] = [_ov("Left wheel", d.cycles_left, d.left, color="#1f4e79"), _ov("Right wheel", d.cycles_right, d.right, color="#c000c0")]
        for side, w, col in (("Left", r.left, "#1f4e79"), ("Right", r.right, "#c000c0")):
            ov.append(_ov(f"{side} creep slope", w.creep_line_x, w.creep_line_y, "dashed", "#2e7d32"))
            ov.append(_ov(f"{side} stripping slope", w.strip_line_x, w.strip_line_y, "dashed", "#c00000"))
            ov.append(_ov(f"{side} SIP", [w.inflection_x], [-w.inflection_y], "marker", col))
        nmax = max(float(d.cycles_left[-1]), float(d.cycles_right[-1]))
        payload["extrapolated_from"] = nmax if nmax < hamburg.MAX_RUT_AT_PASSES else None
        payload["x_max"] = hamburg.MAX_RUT_AT_PASSES
    elif module_id == "beam":
        payload["log_x"] = True
        payload["log_y"] = True
        ov.append(_ov("AASHTO exponential fit", d.cycles, r.fit_AASHTO, "dashed", "#c00000"))
        payload["secondary"] = dict(title="ASTM method", x_label="Cycles (N)", y_label="Normalized modulus × cycles",
                                    series=[_ov("NM × N", d.cycles, d.normalized_modulus), _ov("6th-order fit", d.cycles, r.fit_ASTM, "dashed", "#c00000"),
                                            _ov("nf,50 (ASTM)", [r.nf50_ASTM], [float(np.interp(r.nf50_ASTM, d.cycles, r.fit_ASTM))], "marker", "#2e7d32")])
    return payload


# ---------------------------------------------------------------------------
# Results table + statistics
# ---------------------------------------------------------------------------

def results_table(module_id: str, ws: Workspace) -> Dict[str, Any]:
    m = registry.get(module_id)
    if module_id == "hamburg":
        rows = []
        for lf in ws.files:
            row = dict(file_id=lf.id, specimen_id=lf.specimen_id or lf.name, error=lf.error)
            if lf.result is not None:
                rd = result_dict(module_id, lf)
                # A specimen that failed used to be dropped from this table silently, so the
                # results read as complete while a wheel was missing from the average.
                row.update(left=rd["left"], right=rd["right"], average=rd["average"],
                           needs_pick=rd["needs_pick"])
            rows.append(row)
        return dict(columns=[dict(key=f.key, label=f.label, dp=f.dp, fmt=f.fmt) for f in m.result_fields], rows=rows)
    cols = [dict(key=f.key, label=f.label, dp=f.dp, fmt=f.fmt, kind="input") for f in m.specimen_inputs] + \
           [dict(key=f.key, label=f.label, dp=f.dp, fmt=f.fmt, kind="result") for f in m.result_fields]
    rows = []
    for lf in ws.files:
        row = dict(file_id=lf.id, specimen_id=lf.specimen_id or lf.name, error=lf.error)
        for f in m.specimen_inputs:
            row[f.key] = clean(lf.inputs.get(f.key))
        if lf.result is not None:
            row.update(result_dict(module_id, lf))
        rows.append(row)
    stats = {}
    for c in cols:
        pts = [(r.get("specimen_id") or f"#{i + 1}", r.get(c["key"]), bool(r.get("needs_pick")))
               for i, r in enumerate(rows) if isinstance(r.get(c["key"]), (int, float))]
        vals = [v for _, v, _ in pts]
        mean, std, cov = excel_stats(vals)
        stats[c["key"]] = dict(mean=mean, std=std, cov=cov, n=len(vals), values=vals,
                               labels=[lb for lb, _, _ in pts],
                               provisional=sum(1 for _, _, q in pts if q))
    return dict(columns=cols, rows=rows, stats=stats,
                provisional=[r.get("specimen_id") for r in rows if r.get("needs_pick")],
                errors=[dict(specimen_id=r.get("specimen_id"), error=r.get("error"))
                        for r in rows if r.get("error")])
