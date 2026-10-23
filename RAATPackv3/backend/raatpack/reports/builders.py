"""Turn a workspace's results into a ReportSpec for the Excel/PDF writers."""
from __future__ import annotations

from typing import Any, Dict, List, Optional

import numpy as np

from ..equations._base import Field
from ..modules import registry
from .spec import ReportSpec, Curve


def _cols(m: registry.ModuleSpec, extra_skip=()) -> List[Field]:
    cols = [f for f in m.specimen_inputs] + [f for f in m.result_fields if f.report and f.key not in extra_skip]
    return cols


def _row(lf, m: registry.ModuleSpec, cols: List[Field]) -> Dict[str, Any]:
    r = {"specimen_id": lf.specimen_id or lf.name}
    for f in cols:
        if f.key in lf.inputs:
            r[f.key] = lf.inputs.get(f.key)
        elif lf.result is not None:
            r[f.key] = getattr(lf.result, f.key, None)
    return r


def build(module_id: str, files, project: Dict[str, str], options: Dict[str, Any], logo_path: Optional[str]) -> ReportSpec:
    m = registry.get(module_id)
    fn = _BUILDERS.get(module_id, _build_table)
    spec = fn(m, files, project, options)
    spec.logo_path = logo_path
    # A specimen whose slopes or inflection point were guessed rather than confirmed is still
    # averaged in with the rest, so the report has to say so — on screen it carries a "pick
    # needed" badge, but the exported file used to look identical to a fully confirmed run.
    prov = [lf.specimen_id or lf.name for lf in files
            if lf.result is not None and getattr(lf.result, "needs_pick", False)]
    if prov:
        spec.notes.append(
            "PROVISIONAL: the automatic construction could not be determined for "
            + ", ".join(prov)
            + ". The values shown for these specimens come from an automatic estimate that has "
              "not been confirmed by the operator, and they are included in the statistics.")
    # And one that failed is absent from the table entirely, which the statistics do not reveal.
    bad = [lf.specimen_id or lf.name for lf in files if lf.error]
    if bad:
        spec.notes.append("Not included — these specimens could not be analysed: " + ", ".join(bad) + ".")
    if options.get("passfail") not in (None, ""):
        try:
            spec.passfail = float(options["passfail"])
            spec.passfail_label = m.extra.get("passfail_label", "Criteria")
        except ValueError:
            pass
    return spec


def _curve_xy(lf, m):
    d = lf.data
    if module_curve := getattr(d, "x", None) is not None and hasattr(d, "y"):
        x, y = d.x, d.y
        if lf.trim_x is not None and m.supports_trim:
            from ..io.readers import scb_begin_trim
            x, y = scb_begin_trim(np.asarray(x), np.asarray(y), lf.trim_x)
        return list(map(float, x)), list(map(float, y))
    return [], []


def _build_table(m, files, project, options) -> ReportSpec:
    cols = _cols(m)
    rows = [_row(lf, m, cols) for lf in files]
    curves = []
    for lf in files:
        if m.reader in ("xy", "scb"):
            x, y = _curve_xy(lf, m)
        elif module_id_is(m, "cold_scb"):
            x, y = list(map(float, lf.data.cod)), list(map(float, lf.data.load))     # v2 exports COD vs load
        elif module_id_is(m, "dct"):
            x = list(map(float, lf.result.fitted_cod)) if lf.result is not None else list(map(float, lf.data.cod))
            y = list(map(float, lf.data.load))
        else:
            x, y = [], []
        curves.append(Curve(lf.specimen_id or lf.name, x, y))
    xl, yl = m.x_label, m.y_label
    if module_id_is(m, "cold_scb"):
        xl, yl = "COD (mm)", "Load (kN)"
    spec = ReportSpec(m.id, "table", m.report_title, m.chart_title, xl, yl, project, cols, rows, curves)
    if module_id_is(m, "cold_scb"):
        mode = options.get("tails", "all")
        include = set(options.get("tail_ids", []))
        for lf, r in zip(files, rows):
            res = lf.result
            if res is None:
                continue
            use_tail = (mode == "all" and res.tail_success) or (mode == "select" and lf.id in include and res.tail_success)
            r["Gf_J_per_m2"] = res.Gf_with_tail if use_tail else res.Gf_without_tail
        spec.notes.append("Fracture energy includes the extrapolated tail where the tail fit succeeded."
                          if mode != "none" else "Fracture energy reported without the extrapolated tail.")
    return spec


def module_id_is(m, mid):
    return m.id == mid


def _build_apa(m, files, project, options) -> ReportSpec:
    from ..numerics.matlab import excel_stats
    cols = [Field("air_voids", "Air Voids (%)", 2), Field("left_rut_mm", "Left Rut Depth (mm)", 2),
            Field("center_rut_mm", "Middle Rut Depth (mm)", 2), Field("right_rut_mm", "Right Rut Depth (mm)", 2),
            Field("avg", "Average Rut Depth (mm)", 2), Field("std", "Standard Deviation", 2), Field("cov", "COV (%)", 2)]
    rows, curves = [], []
    for lf in files:
        r = lf.result
        if r is None:
            continue
        mean, std, cov = excel_stats([r.left_rut_mm, r.center_rut_mm, r.right_rut_mm])
        rows.append({"specimen_id": lf.specimen_id or lf.name, "air_voids": lf.inputs.get("air_voids"),
                     "left_rut_mm": r.left_rut_mm, "center_rut_mm": r.center_rut_mm, "right_rut_mm": r.right_rut_mm,
                     "avg": mean, "std": std, "cov": cov})
        d = lf.data
        curves.append(Curve(lf.specimen_id or lf.name, list(map(float, d.cycles_avg)), list(map(float, d.avg))))
    spec = ReportSpec(m.id, "apa", m.report_title, m.chart_title, m.x_label, m.y_label, project, cols, rows, curves,
                      stats=False)
    spec.notes.append("APA Intermediate Course (PG64-22) Criteria ≤ 7 mm Rutting")
    spec.notes.append("APA Surface Course (PG76-22) Criteria ≤ 4 mm Rutting")
    tt = project.get("test_temp", "")
    hose = options.get("hose_pressure", "")
    load = options.get("wheel_load", "")
    spec.notes.append(f"{tt}C Test Temp.; {hose} psi Hose Pressure; {load} lb Load")
    spec.extra["y_min"] = 0
    return spec


def _build_hamburg(m, files, project, options) -> ReportSpec:
    lf = files[0]
    r = lf.result
    cols = [Field("max_rut_mm", "Average Rutting at 20,000 cycles (mm)", 2),
            Field("creep_slope", "Average Creep Slope (mm/cycle)", 6, fmt=".2E"),
            Field("stripping_slope", "Average Stripping Slope (mm/cycle)", 6, fmt=".2E"),
            Field("sip_cycles", "Stripping Inflection Point (cycles)", 0)]
    rows = []
    for name, w in (("Left", r.left), ("Right", r.right)):
        rows.append({"specimen_id": name, "max_rut_mm": w.max_rut_mm, "creep_slope": w.creep_slope,
                     "stripping_slope": w.stripping_slope, "sip_cycles": w.sip_cycles})
    d = lf.data
    curves = [Curve("Left Wheel", list(map(float, d.cycles_left)), list(map(float, d.left))),
              Curve("Right Wheel", list(map(float, d.cycles_right)), list(map(float, d.right)))]
    if options.get("fit_lines", True):
        curves += [Curve("Left creep slope", list(map(float, r.left.creep_line_x)), list(map(float, r.left.creep_line_y)), "dashed", "#2e7d32"),
                   Curve("Left stripping slope", list(map(float, r.left.strip_line_x)), list(map(float, r.left.strip_line_y)), "dashed", "#c00000"),
                   Curve("Right creep slope", list(map(float, r.right.creep_line_x)), list(map(float, r.right.creep_line_y)), "dashed", "#2e7d32"),
                   Curve("Right stripping slope", list(map(float, r.right.strip_line_x)), list(map(float, r.right.strip_line_y)), "dashed", "#c00000")]
    spec = ReportSpec(m.id, "hamburg", m.report_title, f"{lf.specimen_id or lf.name}", m.x_label, m.y_label, project,
                      cols, rows, curves, stats=True)
    spec.extra["x_range"] = (0, 20000)          # v2: axis([0 20000 ...])
    spec.extra["y_min"] = 0
    return spec


def _build_beam(m, files, project, options) -> ReportSpec:
    lf = files[0]
    r = lf.result
    cols = [Field("air_voids", "Air Voids (%)", 1), Field("width_mm", "Width (mm)", 1), Field("height_mm", "Height (mm)", 1),
            Field("length_mm", "Length (mm)", 1), Field("nf50_AASHTO", "AASHTO nf,50", 0), Field("nf50_ASTM", "ASTM nf,50", 0)]
    row = {"specimen_id": lf.specimen_id or lf.name, "nf50_AASHTO": r.nf50_AASHTO, "nf50_ASTM": r.nf50_ASTM}
    for k in ("air_voids", "width_mm", "height_mm", "length_mm"):
        row[k] = lf.inputs.get(k)
    d = lf.data
    curves = [Curve("Flexural stiffness", list(map(float, d.cycles)), list(map(float, d.stiffness)), "marker"),
              Curve("AASHTO trendline", list(map(float, d.cycles)), list(map(float, r.fit_AASHTO)), "dashed")]
    spec = ReportSpec(m.id, "beam", m.report_title, "AASHTO Method", "Loading cycles (n)", "Flexural Stiffness (MPa)",
                      project, cols, [row], curves, stats=False)
    spec.extra["log_x"] = True
    spec.extra["log_y"] = True
    spec.extra["second_chart"] = dict(title="ASTM Method", x_label="Cycles (N)", y_label="Normalized Modulus x Cycles",
                                      curves=[Curve("Normalized modulus × cycles", list(map(float, d.cycles)), list(map(float, d.normalized_modulus)), "marker"),
                                              Curve("ASTM trendline", list(map(float, d.cycles)), list(map(float, r.fit_ASTM)), "dashed")])
    c = r.astm_coeffs
    spec.notes += [f"AASHTO trendline: A = {r.A:.2E}, b = {r.b:.2E}; stiffness at nf,50 = {r.stiffness_N50:.0f} MPa; "
                   f"E at nf,50 = {r.E_N50:.0f} MPa",
                   "ASTM trendline: " + "  ".join(f"x{6 - i}: {v:.2E}" for i, v in enumerate(c)) + f";  n at max = {r.x_at_max:.0f}"]
    return spec


def build_dm(curve, project: Dict[str, str], stdev_E, logo_path: Optional[str]) -> ReportSpec:
    """Dynamic modulus master-curve report (one curve)."""
    from ..equations.dynamic_modulus import MasterCurve
    mc: MasterCurve = curve
    cols = [Field("frequency", "Loading Frequency (Hz)", 3, fmt=".2E"), Field("E", "Dynamic Modulus E (psi)", 0),
            Field("std", "Standard Deviation (psi)", 0), Field("phase", "Phase Angle (degrees)", 1),
            Field("red", "Reduced Frequency (Hz)", 3, fmt=".2E"), Field("pred", "Predicted E (psi)", 0)]
    order = np.argsort(mc.reduced_frequency)
    rows = []
    n = max(len(order), len(mc.grid_x))
    for i in range(n):
        row = {"specimen_id": str(i + 1)}
        if i < len(order):
            k = order[i]
            row.update(frequency=float(mc.reduced_frequency[k]), E=float(mc.E_measured[k]),
                       std=(float(stdev_E[k]) if stdev_E is not None and k < len(stdev_E) else None),
                       phase=float(mc.phase[k]))
        if i < len(mc.grid_x):
            gi = np.argsort(mc.grid_x)[i]
            row.update(red=float(mc.grid_x[gi]), pred=float(mc.grid_y[gi]))
        rows.append(row)
    curves = [Curve("Dynamic Modulus E (psi)", [float(mc.reduced_frequency[k]) for k in order], [float(mc.E_measured[k]) for k in order], "marker"),
              Curve("Predicted E (psi)", list(map(float, np.sort(mc.grid_x))), [float(mc.grid_y[i]) for i in np.argsort(mc.grid_x)])]
    spec = ReportSpec("dynamic_modulus", "dm",
                      "AASHTO T342: Standard Method of Test for Determining Dynamic Modulus of Hot Mix Asphalt (HMA)",
                      mc.title, "Loading Frequency (Hz)", "Dynamic Modulus (psi)", project, cols, rows, curves, stats=False,
                      logo_path=logo_path)
    spec.extra["log_x"] = True
    spec.extra["log_y"] = True
    spec.extra["second_chart"] = dict(title="Phase angle", x_label="Reduced frequency (Hz)", y_label="Phase Angle (Degrees)",
                                      log_x=True,
                                      curves=[Curve("Phase Angle (degrees)", [float(mc.reduced_frequency[k]) for k in order], [float(mc.phase[k]) for k in order], "marker")])
    spec.notes.append("Fit: " + ", ".join(f"{k} = {v:.4g}" for k, v in mc.params.items()) + f";  SSE = {mc.sse:.4g}")
    return spec


_BUILDERS = {"apa": _build_apa, "hamburg": _build_hamburg, "beam": _build_beam}
