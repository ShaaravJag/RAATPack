"""
Cold-temperature SCB — AASHTO TP 105. Faithful port of ColdSCBfinder.m
(verified exact vs. v2 demo report, tail extrapolation included).

NOTE (deliberate): the tail power-law exponent B is bounded ABOVE by TAIL_EXPONENT (-2) but
not pinned to it — v2's second fitoptions() call overwrote the lower bound. Every published
v2 fracture energy used this behaviour; pinning B changes Gf by 3-10 %. Leave it.
"""
from __future__ import annotations

from dataclasses import dataclass
from typing import List, Optional

import numpy as np

from ..numerics import matlab as ml
from ._base import Field

# ---- constants --------------------------------------------------------------
Y_A, Y_B, Y_C, Y_D = 4.782, 1.219, 0.063, 7.045      # Y = A + B(a/r) + C·exp(D·a/r)
STIFFNESS_FACTOR = 1000.0                             # kN/mm -> kN/m
TAIL_START_FRAC = 0.6                                 # tail fit starts where post-peak load = 60 % of peak
TAIL_EXPONENT = -2.0                                  # upper bound on B (see note above)
TAIL_STEP_MM = 0.001
TAIL_STOP_LOAD_KN = 0.001
TAIL_MAX_STEPS = 10000
MM2_TO_M2 = 1e6

SPECIMEN_INPUTS = [
    Field("air_voids", "Air Voids (%)", 1),
    Field("thickness_mm", "Thickness (mm)", 1),
    Field("radius_mm", "Radius (mm)", 1),
    Field("notch_mm", "Notch Length (mm)", 1),
]
REQUIRED_INPUTS = ["thickness_mm", "radius_mm", "notch_mm"]

RESULT_FIELDS: List[Field] = [
    Field("peak_load_kN", "Peak Load (kN)", 1),
    Field("time_at_peak_s", "Time At Peak (s)", 1),
    Field("Uc_mm", "Uc (mm)", 3),
    Field("stiffness_kN_per_m", "Stiffness (kN/m)", 1),
    Field("K_IC", "KIC (MPa*m.5)", 3),
    Field("W", "W", 3, report=False),
    Field("W_tail", "W_Tail", 3, report=False),
    Field("W_total", "W_Total", 3, report=False),
    Field("Gf_without_tail", "Fracture Energy Without Tail, Gf (J/m2)", 0, report=False),
    Field("Gf_with_tail", "Fracture Energy With Tail, Gf (J/m2)", 0, report=False),
    Field("Gf_J_per_m2", "Fracture Energy (J/m2)", 0),
    Field("cmod_slope_mm_per_s", "CMOD Slope (mm/s)", 6, fmt=".2E"),
]


@dataclass
class ColdSCBResult:
    peak_load_kN: float
    time_at_peak_s: float
    Uc_mm: float
    stiffness_kN_per_m: float
    K_IC: float
    W: float
    W_tail: Optional[float]
    W_total: float
    Gf_without_tail: float
    Gf_with_tail: Optional[float]
    Gf_J_per_m2: float          # what gets exported: with tail if the tail succeeded, else without
    cmod_slope_mm_per_s: float
    cmod_intercept: float
    tail_success: bool
    tail_A: float
    tail_B: float
    tail_x: np.ndarray
    tail_y: np.ndarray
    stiffness_line_x: np.ndarray
    stiffness_line_y: np.ndarray
    peak_index: int
    tail_start_index: int


def analyse(time, stroke, load, cod, thickness_mm: float, radius_mm: float, notch_mm: float) -> ColdSCBResult:
    time = np.asarray(time, float)
    stroke = np.asarray(stroke, float)
    load = np.asarray(load, float)
    cod = np.asarray(cod, float)
    peak = float(load.max())
    n1 = ml.first_max_index(load)
    pre_x, pre_y = stroke[: n1 + 1], load[: n1 + 1]
    post_x, post_y = stroke[n1:], load[n1:]
    time_at_peak = float(time[n1])
    W = ml.trapz(load, stroke)
    m_pre, b_pre = ml.fitlm_slope_intercept(pre_x, pre_y)
    slope_pre = abs(m_pre)
    b_pre = abs(b_pre)

    # ---- reported quantities (pre-tail) --------------------------------------
    stiffness = slope_pre * STIFFNESS_FACTOR
    Y = Y_A + Y_B * (notch_mm / radius_mm) + Y_C * np.exp(Y_D * (notch_mm / radius_mm))
    K = Y * peak / 1000.0 / (2 * radius_mm / 1000.0 * thickness_mm / 1000.0) * np.sqrt(np.pi * notch_mm / 1000.0)
    # ---------------------------------------------------------------------------

    ix = int(np.argmin(np.abs(post_y - TAIL_START_FRAC * post_y[0])))
    tx, ty = post_x[ix:], post_y[ix:]
    A, Bexp = ml.fit_power1(tx, ty, lower=(-np.inf, -np.inf), upper=(np.inf, TAIL_EXPONENT))
    end_x = float(tx[-1])
    Ty = float(ty[-1])
    n = 0
    tail_success = True
    while Ty >= TAIL_STOP_LOAD_KN:
        Tx = end_x + TAIL_STEP_MM * n
        Ty = A * Tx ** Bexp
        if n > TAIL_MAX_STEPS:
            tail_success = False
            break
        n += 1
    Alig = (radius_mm - notch_mm) * thickness_mm
    Gf_without = W / Alig * MM2_TO_M2
    if tail_success:
        ii = np.arange(0, n + 1) * TAIL_STEP_MM
        tail_x = end_x + ii
        tail_y = A * tail_x ** Bexp
        W_tail = ml.trapz(tail_y, tail_x)
        W_total = W + W_tail
        Gf_with = W_total / Alig * MM2_TO_M2
        export_Gf = Gf_with
    else:
        tail_x = np.array([])
        tail_y = np.array([])
        W_tail = None
        W_total = W
        Gf_with = None
        export_Gf = Gf_without
    Uc = float(stroke[-1])
    cmod_slope, cmod_b = ml.fitlm_slope_intercept(time, cod)

    sx = np.linspace(0, pre_x[-1] + 1, 100)
    sy = slope_pre * sx + b_pre
    return ColdSCBResult(peak, time_at_peak, Uc, float(stiffness), float(K), float(W), W_tail, float(W_total),
                         float(Gf_without), Gf_with, float(export_Gf), float(cmod_slope), float(cmod_b),
                         tail_success, float(A), float(Bexp), tail_x, tail_y, sx, sy, n1, n1 + ix)
