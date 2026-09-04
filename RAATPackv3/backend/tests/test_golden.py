"""
Golden-value regression suite: every module's demo data through the port, asserted against the
numbers printed in the v2 demo reports. Tolerances reflect the reports' own rounding
(1 dp -> up to ~1 %) — computed values agree to well under 0.1 % where the report prints enough digits.
"""
import numpy as np
import pytest

from raatpack.io.templates import Template, ChannelTransform, KIND_XY, KIND_FOUR, KIND_BEAM, parse_template_workbook
from raatpack.io import readers, ipc, ampt
from raatpack.equations import ideal_ct, cold_scb, hamburg, scb, htidt, dct, apa, beam, dynamic_modulus as dm
from raatpack.numerics.matlab import excel_stats
from raatpack.config.settings import BUILTIN_TEMPLATES_DIR
from conftest import assert_close


def mts_xy(units_x="mm"):
    return Template("mts", "MTS", KIND_XY, {"x": 2, "y": 3}, 12, None, ",", 1,
                    {"x": ChannelTransform(1, 1, 0), "y": ChannelTransform(0, 1, 0)}, {"x": units_x, "y": "kN"})


def test_ideal_ct(gold, demo):
    g = gold["ideal_ct"]
    for row in g["rows"]:
        c = readers.read_xy(demo / row["file"], mts_xy())
        r = ideal_ct.analyse(c.x, c.y, g["thickness_mm"], g["diameter_mm"])
        assert_close(r.CT_index, row["CT_index"], 0.1, "CT index")
        assert_close(r.Gf_J_per_m2, row["Gf_J_per_m2"], 0.05, "Gf")
        assert_close(r.tensile_strength_kPa, row["tensile_strength_kPa"], 0.05, "strength")
        assert_close(r.Gf_over_S, row["Gf_over_S"], 0.05, "Gf/S")
        assert_close(r.slope_S, row["slope_S"], 0.2, "slope")
        assert_close(r.L_mm, row["L_mm"], 1.0, "L")
        assert_close(r.Gf_S_LD2, row["Gf_S_LD2"], 1.5, "Gf/S(L/D)^2")


def test_cold_scb(gold, demo):
    g = gold["cold_scb"]
    t = Template("m", "m", KIND_FOUR, {"time": 1, "stroke": 2, "load": 3, "cod": 4}, 12, None, ",", 1,
                 {"row12": ChannelTransform(1, 1, 0), "row15": ChannelTransform(0, 1, 0),
                  "row21": ChannelTransform(1, 1, 0)},
                 {"time": "sec", "stroke": "m", "load": "N", "cod": "mm"})
    for row in g["rows"]:
        c = readers.read_four_channel(demo / row["file"], t)
        r = cold_scb.analyse(c.time, c.stroke, c.load, c.cod, g["thickness_mm"], g["radius_mm"], g["notch_mm"])
        assert r.tail_success
        assert_close(r.Gf_J_per_m2, row["Gf_J_per_m2"], 0.05, "Gf (with tail)")
        assert_close(r.stiffness_kN_per_m, row["stiffness_kN_per_m"], 0.01, "stiffness")
        assert_close(r.K_IC, row["K_IC"], 0.2, "K_IC")
        assert_close(r.Uc_mm, row["Uc_mm"], 0.1, "Uc")
        assert_close(r.time_at_peak_s, row["time_at_peak_s"], 0.05, "t@peak")
        assert_close(r.cmod_slope_mm_per_s, row["cmod_slope_mm_per_s"], 0.5, "CMOD slope")


def test_cold_scb_tail_is_bounded_not_pinned(gold, demo):
    """Guard the deliberate v2 quirk: pinning B to -2 would change Gf by 3-10 %."""
    assert cold_scb.TAIL_EXPONENT == -2.0
    t = Template("m", "m", KIND_FOUR, {"time": 1, "stroke": 2, "load": 3, "cod": 4}, 12, None, ",", 1,
                 {"row12": ChannelTransform(1, 1, 0), "row15": ChannelTransform(0, 1, 0),
                  "row21": ChannelTransform(1, 1, 0)}, {"time": "sec", "stroke": "m", "load": "N", "cod": "mm"})
    c = readers.read_four_channel(demo / "Cold SCB/Cold SCB Demo File 4.xlsx", t)
    r = cold_scb.analyse(c.time, c.stroke, c.load, c.cod, 25, 75, 15)
    assert r.tail_B < -2.5           # free exponent, well below the bound (v2 behaviour)


def test_hamburg(gold, demo):
    g = gold["hamburg"]
    d = ipc.read_hamburg(demo / g["file"])
    r = hamburg.analyse(d.cycles_left, d.left, d.cycles_right, d.right)
    for side, w in (("left", r.left), ("right", r.right)):
        gg = g[side]
        assert_close(w.max_rut_mm, gg["max_rut_mm"], 0.2, f"{side} rut")
        assert_close(w.creep_slope, gg["creep_slope"], 0.6, f"{side} creep")
        assert_close(w.stripping_slope, gg["stripping_slope"], 0.6, f"{side} strip")
        if gg["sip_cycles"] is None:
            assert w.sip_cycles is None
        else:
            assert_close(w.sip_cycles, gg["sip_cycles"], 0.01, f"{side} SIP")
    assert_close(r.avg_sip_cycles, g["avg_sip_cycles"], 0.01, "avg SIP")


def test_scb(gold, demo):
    g = gold["scb"]
    t = mts_xy(units_x="m")
    for row in g["rows"]:
        c = readers.read_scb_xy(demo / row["file"], t)
        r = scb.analyse(c.x, c.y, g["thickness_mm"], g["ligament_mm"])
        assert not r.needs_pick
        assert_close(r.peak_load_kN, row["peak_load_kN"], 0.2, "peak")
        assert_close(r.Gf_J_per_m2, row["Gf_J_per_m2"], 0.05, "Gf")
        assert_close(r.slope_kN_per_mm, row["slope_kN_per_mm"], 0.5, "slope")
        assert_close(r.flexibility_index, row["flexibility_index"], 0.6, "FI")


def test_htidt(gold, demo):
    g = gold["htidt"]
    t = parse_template_workbook(BUILTIN_TEMPLATES_DIR / "SmartJIG to RAAT.xlsx")
    for row in g["rows"]:
        c = readers.read_xy(demo / row["file"], t)
        r = htidt.analyse(c.x, c.y, g["thickness_mm"], g["diameter_mm"])
        assert_close(r.peak_load_N, row["peak_load_N"], 0.01, "peak N")
        assert_close(r.idt_strength_kPa, row["idt_strength_kPa"], 0.05, "IDT")


def test_dct(gold, demo):
    g = gold["dct"]
    t = Template("m", "m", KIND_FOUR, {"time": 1, "stroke": 2, "load": 3, "cod": 4}, 12, None, ",", 1,
                 {"row12": ChannelTransform(1, 0, 0), "row15": ChannelTransform(0, 0, 0),
                  "row21": ChannelTransform(1, 1, 0)}, {"time": "sec", "stroke": "mm", "load": "kN", "cod": "mm"})
    for row in g["rows"]:
        c = readers.read_four_channel(demo / row["file"], t)
        r = dct.analyse(c.time, c.stroke, c.load, c.cod, g["thickness_mm"], g["ligament_mm"])
        assert_close(r.peak_load_kN, row["peak_load_kN"], 0.05, "peak")
        assert_close(r.displacement_at_peak_mm, row["displacement_at_peak_mm"], 0.3, "disp@peak")
        assert_close(r.time_at_peak_s, row["time_at_peak_s"], 0.05, "t@peak")
        assert_close(r.Gf_J_per_m2, row["Gf_J_per_m2"], 0.05, "Gf")
        assert_close(r.cmod_slope_mm_per_s, row["cmod_slope_mm_per_s"], 0.3, "CMOD")


def test_apa(gold, demo):
    g = gold["apa"]
    d = ipc.read_apa(demo / g["file"])
    r = apa.analyse(d)
    assert_close(r.left_rut_mm, g["left_rut_mm"], 0.3, "left")
    assert_close(r.center_rut_mm, g["center_rut_mm"], 0.3, "center")
    assert r.right_rut_mm is None
    mean, std, cov = excel_stats([r.left_rut_mm, r.center_rut_mm, r.right_rut_mm])
    assert_close(mean, g["avg"], 0.3, "avg")
    assert abs(round(std, 2) - g["std"]) < 1e-9
    assert abs(round(cov, 2) - g["cov"]) < 1e-9


def test_beam(gold, demo):
    g = gold["beam"]
    t = Template("b", "b", KIND_BEAM, {"cycles": 1, "stiffness": 4, "modulus": 5}, 48, None, ",", 1, {}, {})
    d = readers.read_beam(demo / g["file"], t)
    r = beam.analyse(d.cycles, d.stiffness, d.modulus, d.normalized_modulus)
    assert_close(r.A, g["A"], 0.5, "A")
    assert_close(r.b, g["b"], 0.5, "b")
    assert_close(r.nf50_AASHTO, g["nf50_AASHTO"], 0.05, "AASHTO nf50")
    assert_close(r.nf50_ASTM, g["nf50_ASTM"], 0.01, "ASTM nf50")
    assert r.stiffness_N50 == g["stiffness_N50"]
    assert r.x_at_max == g["x_at_max"]


def test_dynamic_modulus_ea(gold, demo):
    g = gold["dynamic_modulus"]
    W = demo / g["folder"]
    tags = ("4C", "20C", "45C")
    reps = [[ampt.read_ampt_summary(W / f"Winslow_#{i}_{t}_Sum.csv") for t in tags] for i in (1, 2, 3)]
    temps = [list(map(float, g["target_temps_c"]))] * 3
    avg = dm.build_average_table(reps, temps)
    assert len(avg.frequency) == 19
    fr = g["first_row"]
    assert avg.target_temp_f[0] == fr["target_temp_f"]
    assert avg.frequency[0] == fr["frequency"]
    assert_close(avg.E_psi[0], fr["E_psi"], 0.001, "E first row")
    assert_close(avg.phase[0], fr["phase"], 0.5, "phase first row")
    mc = dm.fit_ea(avg.frequency, avg.target_temp_f, avg.logE, avg.E_psi, avg.phase, g["emax_psi"], g["ref_temp_c"])
    for k, v in g["shift_log10"].items():
        assert_close(mc.shift_factors[k], v, 0.05, f"shift {k}")
    for got, want in zip(mc.grid_y, g["grid_predicted_psi"]):
        assert_close(got, want, 0.1, "predicted E")


def test_template_roundtrip(tmp_path):
    from raatpack.io.templates import write_template_workbook, parse_template_workbook as parse
    t = Template("t1", "T1", KIND_XY, {"x": 3, "y": 2}, 5, None, ";", 2,
                 {"x": ChannelTransform(1, 1, 0), "y": ChannelTransform(0, 1, 0)}, {"x": "m", "y": "N"})
    p = tmp_path / "t1.xlsx"
    write_template_workbook(t, p)
    u = parse(p)
    assert u.kind == KIND_XY and u.columns == t.columns and u.data_start == 5 and u.sheet == 2
    assert u.transforms["x"].as_tuple() == (1, 1, 0) and u.units == t.units
