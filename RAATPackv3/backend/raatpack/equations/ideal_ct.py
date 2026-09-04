"""
IDEAL-CT — ASTM D8225.  Faithful port of CTIndexfinder.m (verified exact vs. v2 demo report).

Every constant is defined here. Reported quantities are computed in the marked block.
"""
from __future__ import annotations

from dataclasses import dataclass
from typing import List

import numpy as np

from ..numerics import matlab as ml
from ._base import Field

# ---- constants --------------------------------------------------------------
SLOPE_WINDOW_UPPER_FRAC = 0.85   # post-peak slope window: from 85 % of peak ...
SLOPE_WINDOW_LOWER_FRAC = 0.65   # ... down to 65 % of peak
DISPLACEMENT_FRAC = 0.75         # L is the displacement at 75 % of peak (post-peak)
REFERENCE_THICKNESS_MM = 62.0    # D8225 normalising thickness
MM2_TO_M2 = 1e6                  # (kN·mm)/(mm²) -> J/m²

SPECIMEN_INPUTS = [
    Field("air_voids", "Air Voids (%)", 1),
    Field("thickness_mm", "Thickness (mm)", 1),
    Field("diameter_mm", "Diameter (mm)", 1),
]
REQUIRED_INPUTS = ["thickness_mm", "diameter_mm"]

RESULT_FIELDS: List[Field] = [
    Field("peak_load_kN", "Peak Load (kN)", 1),
    Field("L_mm", "(L) (mm)", 1),
    Field("tensile_strength_kPa", "Tensile Strength (kPa)", 1),
    Field("Gf_J_per_m2", "Fracture Energy (Gf) (LLD)", 1),
    Field("slope_S", "Slope (S)", 2),
    Field("Gf_over_S", "Gf/S", 1),
    Field("Gf_S_LD2", "Gf/S * (L/D)2", 1),
    Field("CT_index", "CT Index", 1),
]


@dataclass
class IdealCTResult:
    peak_load_kN: float
    L_mm: float
    tensile_strength_kPa: float
    Gf_J_per_m2: float
    slope_S: float
    Gf_over_S: float
    Gf_S_LD2: float
    CT_index: float
    # construction (for plotting only)
    peak_index: int
    window_start_index: int
    window_end_index: int
    slope_line_x: np.ndarray
    slope_line_y: np.ndarray
    L_point: tuple


def analyse(x_mm: np.ndarray, y_kN: np.ndarray, thickness_mm: float, diameter_mm: float) -> IdealCTResult:
    x = np.asarray(x_mm, float)
    y = np.asarray(y_kN, float)
    peak = float(y.max())
    n1 = ml.first_max_index(y)
    Nx, Ny = x[n1:], y[n1:]
    ix = int(np.argmin(np.abs(Ny - SLOPE_WINDOW_UPPER_FRAC * Ny[0])))
    ix2 = int(np.argmin(np.abs(Ny - SLOPE_WINDOW_LOWER_FRAC * Ny[0])))
    seg = slice(ix, ix2 + 1)                       # MATLAB N1(ix:ix2,:) — inclusive
    slope_raw, intercept = ml.fitlm_slope_intercept(Nx[seg], Ny[seg])
    S = abs(slope_raw)
    U = ml.trapz(y, x)                             # kN·mm == J
    lx = int(np.argmin(np.abs(Ny - DISPLACEMENT_FRAC * Ny[0])))
    L = float(Nx[lx])

    # ---- reported quantities -------------------------------------------------
    Gf = U / (thickness_mm * diameter_mm) * MM2_TO_M2
    L_D = L / diameter_mm
    Gf_S = Gf / S
    CT_index = Gf_S * L_D * thickness_mm / REFERENCE_THICKNESS_MM
    Gf_S_LD2 = Gf_S * L_D ** 2 * thickness_mm / REFERENCE_THICKNESS_MM
    Str = (2 * peak * 1e3) / (np.pi * 1e-6 * diameter_mm * thickness_mm) / 1000.0
    # ---------------------------------------------------------------------------

    lx_line = np.array([Nx[ix], Nx[ix2]])
    ly_line = slope_raw * lx_line + intercept
    return IdealCTResult(peak, L, float(Str), float(Gf), float(S), float(Gf_S), float(Gf_S_LD2),
                         float(CT_index), n1, n1 + ix, n1 + ix2, lx_line, ly_line, (L, float(Ny[lx])))
