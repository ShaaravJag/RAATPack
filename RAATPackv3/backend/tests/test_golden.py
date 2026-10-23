"""
Golden-value regression suite: every sample file through the port, asserted against the numbers
printed in the v2 demo reports.

Tolerances live in ``golden/values.json`` next to the values they judge, so this file and
``scripts/verify_demo_data.py`` cannot drift apart. They reflect the reports' own rounding
(a value printed to 1 dp carries up to ~1% of print error); where the report prints enough
digits the computed values agree to well under 0.1%.

Which file belongs to which module, read with which template, at which dimensions comes from
``raatpack.config.samples`` -- the same manifest the app uses to load its bundled sample data.
Tests are parametrized per file so one bad specimen cannot mask the rest of a module, and the
failing file name appears in the test id.
"""
import numpy as np
import pytest

from raatpack.config import samples
from raatpack.equations import cold_scb, dynamic_modulus as dm
from raatpack.io import ampt, readers
from raatpack.io.templates import ChannelTransform, KIND_XY, Template
from raatpack.numerics.matlab import excel_stats
from conftest import GOLD, assert_close, assert_metric, run_sample

# ---------------------------------------------------------------------------
# parametrization: one case per sample file
# ---------------------------------------------------------------------------

def _golden_rows(module):
    g = GOLD.get(module)
    if not isinstance(g, dict):
        return {}
    if "rows" in g:
        return {r["file"]: r for r in g["rows"]}
    if "file" in g:
        return {g["file"]: g}
    return {}


# every specimen file in the manifest, and the reference row for it if one exists
ALL_CASES, GOLDEN_CASES = [], []
for _s in samples.SAMPLE_SETS:
    _rows = _golden_rows(_s.module)
    for _f in _s.specimens():
        if _s.module != "dynamic_modulus":      # own reader, own pipeline; see the E* tests below
            ALL_CASES.append((_s, _f))
        _row = _rows.get(_s.rel(_f))
        if _row and _s.module != "dynamic_modulus":
            GOLDEN_CASES.append((_s, _f, _row))

_id = lambda s, f: f"{s.module}-{f.name}"
ALL_IDS = [_id(s, f) for s, f in ALL_CASES]
GOLDEN_IDS = [_id(s, f) for s, f, _ in GOLDEN_CASES]

# Hamburg and Dynamic Modulus report per wheel and per master curve rather than per specimen
# row, so they keep their own dedicated tests below.
_PER_SPECIMEN = [(s, f, r) for s, f, r in GOLDEN_CASES
                 if s.module not in ("hamburg", "dynamic_modulus")]
_PER_SPECIMEN_IDS = [_id(s, f) for s, f, _ in _PER_SPECIMEN]


# ---------------------------------------------------------------------------
# the numbers
# ---------------------------------------------------------------------------

@pytest.mark.parametrize("sset,sfile,row", _PER_SPECIMEN, ids=_PER_SPECIMEN_IDS)
def test_reported_values_match_the_reference_report(sset, sfile, row, demo, templates):
    """Every number the v2 report prints for this file, compared against the port's output."""
    res, _ = run_sample(sset, sfile, templates)
    checked = 0
    for key, want in row.items():
        if key in ("file", "id") or key.startswith("_") or not isinstance(want, (int, float)):
            continue
        assert key in res, (f"{sset.module} · {sfile.name}: the report gives {key} but the port "
                            f"does not report it at all")
        assert_metric(sset.module, key, res[key], want, sfile.name)
        checked += 1
    assert checked, f"{sset.module} · {sfile.name}: no numeric golden values were compared"


@pytest.mark.parametrize("sset,sfile", ALL_CASES, ids=ALL_IDS)
def test_every_sample_file_loads_and_analyses(sset, sfile, demo, templates):
    """Liveness for the whole sample set, including the files with no reference numbers.

    This is what catches a file that silently stops parsing: it reads, it analyses without
    raising, and it yields at least one finite headline number.
    """
    res, lf = run_sample(sset, sfile, templates)
    fields = [f.key for f in __import__("raatpack.modules.registry", fromlist=["x"])
              .get(sset.module).result_fields]
    if sset.module == "hamburg":
        finite = [v for side in ("left", "right") for v in res[side].values()
                  if isinstance(v, float) and np.isfinite(v)]
    else:
        finite = [res[k] for k in fields
                  if isinstance(res.get(k), (int, float)) and np.isfinite(float(res[k]))]
    assert finite, (f"{sset.module} · {sfile.name}: analysis produced no finite values — "
                    f"got {res!r}")


@pytest.mark.parametrize("sset,sfile", [(s, f) for s, f in ALL_CASES if f.expect],
                         ids=[_id(s, f) for s, f in ALL_CASES if f.expect])
def test_known_edge_case_behaviour_is_unchanged(sset, sfile, demo, templates):
    """Pin the degraded paths the headline numbers hide.

    A failed tail extrapolation, a missing stripping inflection point, an absent wheel: the
    manifest records what each of these files is known to do, and a change in *either*
    direction fails here. That is what keeps v2's bug-for-bug behaviour from drifting.
    """
    res, _ = run_sample(sset, sfile, templates)
    for key, want in sfile.expect.items():
        if key == "wheels":
            got = "+".join(w for w in ("left", "center", "right")
                           if res.get(f"{w}_rut_mm") is not None) or "none"
        elif key in ("left_sip", "right_sip"):
            got = res[key[:-4]]["sip_cycles"] is not None
        else:
            got = res.get(key)
        assert got == want, (f"{sset.module} · {sfile.name}: expected {key}={want!r} but got "
                             f"{got!r} — either the sample data or the calculation changed")


# ---------------------------------------------------------------------------
# module-specific behaviour the per-row comparison cannot express
# ---------------------------------------------------------------------------

def test_cold_scb_tail_is_bounded_not_pinned(demo, templates):
    """Guard the deliberate v2 quirk: pinning B to -2 would change Gf by 3-10%."""
    assert cold_scb.TAIL_EXPONENT == -2.0, (
        "TAIL_EXPONENT is the lower bound v2's fitoptions imposed on the tail exponent; changing "
        "it changes every Cold SCB fracture energy")
    s = samples.get("cold_scb")
    f = next(x for x in s.specimens() if x.name.endswith("File 4.xlsx"))
    res, _ = run_sample(s, f, templates)
    assert res["tail_success"], f"{f.name}: the tail fit should succeed for this file"
    assert res["tail_B"] < -2.5, (
        f"{f.name}: tail_B is {res['tail_B']}, i.e. sitting at or near its -2 bound. v2 let this "
        f"exponent float; pinning it moves Gf by 3-10% and breaks agreement with the report")


def test_cold_scb_file_1_tail_failure_is_reported_not_hidden(demo, templates):
    """The one file whose tail fit fails must say so, and still produce a usable result."""
    s = samples.get("cold_scb")
    f = next(x for x in s.specimens() if x.name.endswith("File 1.xlsx"))
    res, _ = run_sample(s, f, templates)
    assert res["tail_success"] is False, (
        f"{f.name} is the sample set's only tail-extrapolation failure; if it now succeeds, the "
        f"fit changed and the None-Gf path has lost its only coverage")
    assert res["tail_B"] == pytest.approx(-2.0, abs=1e-6), (
        f"{f.name}: a failed fit is one that pinned tail_B at its bound; got {res['tail_B']}")
    assert np.isfinite(res["Gf_J_per_m2"]), (
        f"{f.name}: a failed tail fit must still report the no-tail fracture energy, not NaN")


def test_hamburg(gold, demo, templates):
    g = gold["hamburg"]
    s = samples.get("hamburg")
    f = next(x for x in s.specimens() if s.rel(x) == g["file"])
    res, _ = run_sample(s, f, templates)
    for side in ("left", "right"):
        w, gg = res[side], g[side]
        for key in ("max_rut_mm", "creep_slope", "stripping_slope"):
            assert_metric("hamburg", key, w[key], gg[key], f"{f.name} {side} wheel")
        if gg["sip_cycles"] is None:
            assert w["sip_cycles"] is None, (
                f"{f.name} {side} wheel: the report shows no stripping inflection point, but the "
                f"port found one at {w['sip_cycles']} cycles")
        else:
            assert_metric("hamburg", "sip_cycles", w["sip_cycles"], gg["sip_cycles"],
                          f"{f.name} {side} wheel")
    assert_metric("hamburg", "avg_sip_cycles", res["average"]["sip_cycles"], g["avg_sip_cycles"],
                  f"{f.name} average")


def test_hamburg_file_2_has_no_stripping_inflection_on_either_wheel(demo, templates):
    """The only file that exercises 'both wheels failed to find a SIP'."""
    s = samples.get("hamburg")
    f = next(x for x in s.specimens() if x.name.endswith("File 2.xlsx"))
    res, _ = run_sample(s, f, templates)
    for side in ("left", "right"):
        assert res[side]["sip_cycles"] is None, (
            f"{f.name} {side} wheel: expected no stripping inflection point, got "
            f"{res[side]['sip_cycles']}")
    assert res["average"]["sip_cycles"] is None, (
        f"{f.name}: with neither wheel reporting a SIP the average must be None, not "
        f"{res['average']['sip_cycles']}")
    for side in ("left", "right"):
        assert np.isfinite(res[side]["max_rut_mm"]), (
            f"{f.name} {side} wheel: rut depth and slopes must still be reported when the SIP "
            f"search fails")


def test_apa_report_statistics(gold, demo, templates):
    """The report's Average / Std Dev / COV columns, computed across the wheels as v2 does."""
    g = gold["apa"]
    s = samples.get("apa")
    f = next(x for x in s.specimens() if s.rel(x) == g["file"])
    res, _ = run_sample(s, f, templates)
    assert res["right_rut_mm"] is None, (
        f"{f.name}: this specimen has no right wheel in the data; got {res['right_rut_mm']}")
    mean, std, cov = excel_stats([res["left_rut_mm"], res["center_rut_mm"], res["right_rut_mm"]])
    assert_metric("apa", "average_rut_mm", mean, g["average_rut_mm"], f.name)
    assert_metric("apa", "_std", std, g["_std"], f.name)
    assert_metric("apa", "_cov", cov, g["_cov"], f.name)
    assert res["average_rut_mm"] == pytest.approx(mean), (
        f"{f.name}: the port reports average_rut_mm = {res['average_rut_mm']} but the report's "
        f"own AVERAGE across the wheels is {mean}")


def test_beam_exact_integers(gold, demo, templates):
    """nf,50 stiffness and the x of maximum normalized modulus are read off the data, not fitted,
    so they must match the report exactly rather than within a tolerance."""
    g = gold["beam"]
    s = samples.get("beam")
    f = next(x for x in s.specimens() if s.rel(x) == g["file"])
    res, _ = run_sample(s, f, templates)
    assert res["stiffness_N50"] == g["stiffness_N50"], (
        f"{f.name}: stiffness at nf,50 is {res['stiffness_N50']}, report says "
        f"{g['stiffness_N50']} — this value is taken straight from the data, so it should be exact")
    assert res["x_at_max"] == g["x_at_max"], (
        f"{f.name}: x at maximum normalized modulus is {res['x_at_max']}, report says "
        f"{g['x_at_max']} — taken straight from the data, so it should be exact")


def test_bond_regression_baseline(gold, demo, templates):
    """Bond Strength ships no v2 report, so these are OUR OWN numbers, pinned to catch drift.

    They were verified by reading the port against v2's BondStrfinder.m rather than against a
    report: Bond_strength = peak/(pi*d^2/4)*145038, and the specimen length only feeds the
    reported Length (in). If the port were wrong, this test would faithfully pin the wrong answer
    — it guards against regression, not against a mis-port.
    """
    g = gold["bond"]
    s = samples.get("bond")
    assert s.dimensions["diameter_mm"] == g["diameter_mm"], (
        "the manifest and the baseline disagree about the diameter the baseline was computed at")
    rows = {r["file"]: r for r in g["rows"]}
    for f in s.specimens():
        res, _ = run_sample(s, f, templates)
        row = rows[s.rel(f)]
        for key in ("peak_load_kN", "displacement_at_peak_mm", "bond_strength_psi",
                    "length_in", "diameter_in"):
            assert_metric("bond", key, res[key], row[key], f.name)


def test_bond_strength_formula_matches_v2(demo, templates):
    """Independently re-derive one specimen's strength from the peak load and the diameter."""
    s = samples.get("bond")
    f = s.specimens()[0]
    res, _ = run_sample(s, f, templates)
    d = s.dimensions["diameter_mm"]
    expected = res["peak_load_kN"] / (np.pi * d ** 2 / 4.0) * 145038.0
    assert res["bond_strength_psi"] == pytest.approx(expected, rel=1e-12), (
        f"{f.name}: bond strength {res['bond_strength_psi']} does not equal "
        f"peak/(pi*d^2/4)*145038 = {expected}, which is what BondStrfinder.m computes")


_DM = samples.get("dynamic_modulus")
_DM_SUMMARIES = _DM.specimens()


@pytest.mark.parametrize("sfile", _DM_SUMMARIES, ids=[f.name for f in _DM_SUMMARIES])
def test_every_ampt_summary_parses(sfile, demo):
    """Liveness for each AMPT summary file on its own, so one bad isotherm does not surface only
    as a failed master-curve fit."""
    a = ampt.read_ampt_summary(_DM.file_path(sfile))
    t = ampt.guess_temperature_from_name(sfile.name.rsplit("/", 1)[-1])
    assert t is not None, (f"{sfile.name}: no temperature in the file name — the port reads the "
                           f"isotherm temperature from the name, so it cannot be shifted")
    assert len(a.frequencies_hz) in (6, 7), (
        f"{sfile.name}: parsed {len(a.frequencies_hz)} frequencies, expected 6 or 7")
    for name, arr in (("modulus", a.modulus_mpa), ("phase", a.phase_deg),
                      ("average temperature", a.avg_temp_c)):
        assert len(arr) == len(a.frequencies_hz), (
            f"{sfile.name}: {name} has {len(arr)} values for {len(a.frequencies_hz)} frequencies")
        assert np.all(np.isfinite(arr)), f"{sfile.name}: {name} contains non-finite values"
    assert np.all(a.modulus_mpa > 0), f"{sfile.name}: non-positive dynamic modulus"
    assert np.all((a.phase_deg >= 0) & (a.phase_deg < 90)), (
        f"{sfile.name}: phase angles outside 0-90 degrees: {a.phase_deg}")


def test_dynamic_modulus_ea(gold, demo):
    g = gold["dynamic_modulus"]
    s = samples.get("dynamic_modulus")
    # group the summary files by replicate, with the temperature read from the file name rather
    # than hardcoded, so a renamed or added file is noticed here instead of silently mis-shifted
    by_rep = {}
    for f in s.specimens():
        t = ampt.guess_temperature_from_name(f.name.rsplit("/", 1)[-1])
        assert t is not None, (f"{f.name}: no temperature in the file name — "
                               f"guess_temperature_from_name() returned None")
        by_rep.setdefault(f.specimen_id, []).append((t, ampt.read_ampt_summary(s.file_path(f))))
    assert len(by_rep) == 3, f"expected 3 replicates, found {sorted(by_rep)}"

    reps, temps = [], []
    for rep in sorted(by_rep):
        pairs = sorted(by_rep[rep], key=lambda p: p[0])
        reps.append([a for _, a in pairs])
        temps.append([float(t) for t, _ in pairs])
    assert temps[0] == [float(x) for x in g["target_temps_c"]], (
        f"temperatures read from the file names are {temps[0]}, expected {g['target_temps_c']}")

    avg = dm.build_average_table(reps, temps)
    assert len(avg.frequency) == 19, (
        f"the averaged table has {len(avg.frequency)} frequency rows, expected 19 — the three "
        f"isotherms contribute 6 + 6 + 7")
    fr = g["first_row"]
    assert avg.target_temp_f[0] == fr["target_temp_f"], (
        f"first row is at {avg.target_temp_f[0]} F, report says {fr['target_temp_f']} F")
    assert avg.frequency[0] == fr["frequency"], (
        f"first row is at {avg.frequency[0]} Hz, report says {fr['frequency']} Hz")
    assert_metric("dynamic_modulus", "E_psi", avg.E_psi[0], fr["E_psi"], "first row")
    assert_metric("dynamic_modulus", "phase", avg.phase[0], fr["phase"], "first row")

    mc = dm.fit_ea(avg.frequency, avg.target_temp_f, avg.logE, avg.E_psi, avg.phase,
                   g["emax_psi"], g["ref_temp_c"])
    for k, v in g["shift_log10"].items():
        assert_metric("dynamic_modulus", "shift", mc.shift_factors[k], v, f"{k} F isotherm")
    for i, (got, want) in enumerate(zip(mc.grid_y, g["grid_predicted_psi"])):
        assert_metric("dynamic_modulus", "predicted_E", got, want, f"master curve point {i}")


def test_dynamic_modulus_volumetrics_reproduce_the_reported_emax(gold):
    """The manifest's volumetrics are self-generated; this is what justifies them."""
    g = gold["dynamic_modulus"]
    d = samples.get("dynamic_modulus").dimensions
    v = dm.emax_hirsch(d["Gmm"], d["Gsb"], d["air_voids"], d["ac_pct"])
    assert_close(v.EMAX, g["emax_psi"], 0.01, "E*max from the manifest's volumetrics")
    assert 10.0 < v.VMA < 20.0, f"VMA {v.VMA} is outside anything a real mix would show"
    assert 50.0 < v.VFA < 90.0, f"VFA {v.VFA} is outside anything a real mix would show"


def test_hirsch_binder_input_parses(demo):
    """The Hirsch workbook is a binder G* input, not an AMPT summary, and has its own reader."""
    s = samples.get("dynamic_modulus")
    f = next(x for x in s.files if x.role == samples.HIRSCH_INPUT)
    h = ampt.read_hirsch_input(s.file_path(f))
    assert len(h.g_star_psi) == 18, f"{f.name}: parsed {len(h.g_star_psi)} G* rows, expected 18"
    assert sorted(set(h.temps_f.tolist())) == [39.0, 68.0, 113.0], (
        f"{f.name}: temperatures are {sorted(set(h.temps_f.tolist()))}, expected 39/68/113 F")
    d = s.dimensions
    v = dm.emax_hirsch(d["Gmm"], d["Gsb"], d["air_voids"], d["ac_pct"])
    E = dm.hirsch_from_gstar(v.VMA, v.VFA, h.g_star_psi)
    assert np.all(np.isfinite(E)), f"{f.name}: Hirsch E from G* contains non-finite values"
    assert np.all(E > 0), f"{f.name}: Hirsch E from G* contains non-positive values"


# ---------------------------------------------------------------------------
# the manifest itself
# ---------------------------------------------------------------------------

def test_manifest_matches_what_is_on_disk(demo):
    """Every declared file exists, and nothing undeclared is sitting in the sample folders."""
    problems = []
    for s in samples.SAMPLE_SETS:
        root = s.path()
        assert root.exists(), f"{s.module}: sample folder missing: {root}"
        declared = {f.name for f in s.files}
        on_disk = {p.relative_to(root).as_posix() for p in root.rglob("*")
                   if p.is_file() and p.suffix.lower() != ".pdf" and not samples.is_ignored(p.name)}
        for extra in sorted(on_disk - declared):
            problems.append(f"{s.module}: on disk but not in the manifest: {extra}")
        for missing in sorted(declared - on_disk):
            problems.append(f"{s.module}: in the manifest but not on disk: {missing}")
        if s.reference_pdf:
            assert (samples.SAMPLES_DIR / s.reference_pdf).exists(), \
                f"{s.module}: reference report missing: {s.reference_pdf}"
    assert not problems, "the sample manifest is out of step with the data:\n  " + \
                         "\n  ".join(problems)


def test_manifest_templates_and_dimensions_are_usable(templates):
    """Each set names a template the app actually ships, of the kind its module needs, and
    supplies every dimension that module requires."""
    from raatpack.modules import registry
    for s in samples.SAMPLE_SETS:
        m = registry.get(s.module)
        if m.template_kind:
            assert s.template, f"{s.module} needs a {m.template_kind} template but declares none"
            t = templates.get(s.template)       # raises KeyError if it is not shipped
            assert t.kind == m.template_kind, (
                f"{s.module}: template {s.template!r} is a {t.kind} template, module needs "
                f"{m.template_kind}")
        for key in m.required_inputs:
            assert key in s.dimensions, (
                f"{s.module}: required dimension {key!r} is missing from the manifest, so "
                f"loading this sample set would fail with a missing-dimension error")
        assert len({f.specimen_id for f in s.specimens()}) == len(s.specimens()) or \
            s.module == "dynamic_modulus", \
            f"{s.module}: specimen ids are not unique: {[f.specimen_id for f in s.specimens()]}"


def test_excel_lock_files_are_refused_by_name(tmp_path, templates):
    """An Excel lock file used to reach openpyxl and come back as 'BadZipFile: File is not a zip
    file'. It must be refused by name, with an explanation."""
    from raatpack.api import analysis
    lock = tmp_path / "~$Book1.xlsx"
    lock.write_bytes(b"not a zip")
    with pytest.raises(readers.NotADataFile) as e:
        analysis.load_data("ideal_ct", lock, templates.get(samples.get("ideal_ct").template))
    assert "lock file" in str(e.value).lower(), f"unhelpful message: {e.value}"
    assert samples.is_ignored("~$Book1.xlsx")
    assert samples.is_ignored(".DS_Store")
    assert not samples.is_ignored("IDEALCT Demo File 1.xlsx")


@pytest.mark.parametrize("name,exc,expect", [
    ("b.xlsx", __import__("zipfile").BadZipFile("File is not a zip file"), "excel workbook"),
    ("b.xlsx", PermissionError(13, "in use"), "close it in excel"),
    ("b.csv", FileNotFoundError(2, "no such file"), "moved, renamed or deleted"),
    ("b.xlsx", IndexError("list index out of range"), "columns this template expects"),
])
def test_read_failures_are_explained_in_plain_language(name, exc, expect):
    msg = readers.describe_read_failure(name, exc)
    assert expect in msg.lower(), f"message for {type(exc).__name__} was unhelpful: {msg}"
    assert type(exc).__name__ not in msg, (
        f"the raw exception class name leaked into a user-facing message: {msg}")


def test_template_roundtrip(tmp_path):
    from raatpack.io.templates import write_template_workbook, parse_template_workbook as parse
    t = Template("t1", "T1", KIND_XY, {"x": 3, "y": 2}, 5, None, ";", 2,
                 {"x": ChannelTransform(1, 1, 0), "y": ChannelTransform(0, 1, 0)},
                 {"x": "m", "y": "N"})
    p = tmp_path / "t1.xlsx"
    write_template_workbook(t, p)
    u = parse(p)
    assert u.kind == KIND_XY and u.columns == t.columns and u.data_start == 5 and u.sheet == 2
    assert u.transforms["x"].as_tuple() == (1, 1, 0) and u.units == t.units
