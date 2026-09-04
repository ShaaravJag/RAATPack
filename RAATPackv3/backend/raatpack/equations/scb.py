"""
Intermediate-temperature SCB — AASHTO TP 124 / IL-SCB. Faithful port of FIfinder.m.

The interactive parts of v2 (msgbox / getpts / questdlg) are split out: `analyse()` does the
automatic search and reports `needs_pick=True` if v2 would have asked the operator to click;
`evaluate_at()` re-evaluates the SAME post-peak polynomial at an operator-chosen displacement
(v2 never refits after a manual pick).
"""
from __future__ import annotations

from dataclasses import dataclass, field
from typing import List, Optional

import numpy as np

from ..numerics import matlab as ml
from ._base import Field, matlab_round

# ---- constants --------------------------------------------------------------
POLY_ORDER = 6
CUTOFF_FRAC = 0.1                # post-peak fit window ends at the point nearest 10 % of peak
MAX_WIDEN_STEPS = 8              # v2's j loop: acceptance window right edge at j·10 % of peak, j = 1..8
FI_FACTOR = 0.01                 # FI = Gf / |m| × 0.01
LIGAMENT_OFFSET_MM = 15.0        # Str = P / (2·(l + 15)·t) × STRENGTH_CONST
STRENGTH_CONST = 21036021.444    # v2 magic constant, preserved verbatim
AREA_MM2_TO_M2 = 1e-6

SPECIMEN_INPUTS = [
    Field("air_voids", "Air Voids (%)", 1),
    Field("thickness_mm", "Thickness (mm)", 2),
    Field("ligament_mm", "Ligament Length (mm)", 2),
]
REQUIRED_INPUTS = ["thickness_mm", "ligament_mm"]

RESULT_FIELDS: List[Field] = [
    Field("peak_load_kN", "Max Load (kN)", 2),
    Field("strength_MPa", "Strength (MPa)", 2, report=False),
    Field("Gf_J_per_m2", "Fracture Energy, Gf (J/m2)", 1),
    Field("slope_kN_per_mm", "Slope (kN/mm)", 2),
    Field("flexibility_index", "Flexibility Index (FI)", 2),
]


@dataclass
class SCBFit:
    """Everything derived from the post-peak polynomial; reused for manual picks."""
    peak: float
    peak_index: int
    Int1: float
    poly: np.ndarray                 # 6th-order coefficients
    deriv1: np.ndarray
    window_x: np.ndarray             # O1 displacement
    fitted: np.ndarray               # polyval over window_x
    candidate_roots: np.ndarray      # real, positive roots of the 2nd derivative


@dataclass
class SCBResult:
    peak_load_kN: float
    strength_MPa: float
    Gf_J_per_m2: float
    slope_kN_per_mm: float
    flexibility_index: float
    inflection_x: float
    inflection_y: float
    line_x: np.ndarray
    line_y: np.ndarray
    fit: SCBFit
    needs_pick: bool = False         # True: v2 would have asked the operator to click
    picked: bool = False
    auto_candidates: np.ndarray = field(default_factory=lambda: np.array([]))


def fit_post_peak(x: np.ndarray, y: np.ndarray) -> SCBFit:
    peak = float(y.max())
    n1 = ml.first_max_index(y)
    Int1 = ml.trapz(y, x)
    Nx, Ny = x[n1:], y[n1:]
    tenp = CUTOFF_FRAC * peak
    index = int(np.argmin(np.abs(Ny - tenp)))
    O1x, O1y = Nx[: index + 1], Ny[: index + 1]
    poly = ml.polyfit(O1x, O1y, POLY_ORDER)
    fitted = ml.polyval(poly, O1x)
    d1 = ml.polyder(poly)
    d2 = ml.polyder(d1)
    r = ml.real_roots_matlab(ml.roots(d2))
    R1 = r[r > 0]
    return SCBFit(peak, n1, Int1, poly, d1, O1x, fitted, R1)


def auto_inflection(x: np.ndarray, y: np.ndarray, f: SCBFit) -> np.ndarray:
    """v2's widening search. Returns the accepted candidates (may be empty)."""
    tenp = CUTOFF_FRAC * f.peak
    end11 = f.peak_index
    for j in range(1, MAX_WIDEN_STEPS + 1):
        end21 = ml.knnsearch(y, j * tenp)              # searched over the WHOLE curve (v2)
        cand = f.candidate_roots[(f.candidate_roots < x[end21]) & (f.candidate_roots > x[end11])]
        if cand.size:
            return cand
    return np.array([])


def _evaluate(x, y, f: SCBFit, cands: np.ndarray, thickness_mm: float, ligament_mm: float,
              needs_pick: bool, picked: bool) -> SCBResult:
    slopes = ml.polyval(f.deriv1, cands)
    k = int(np.argmax(np.abs(slopes)))
    slope = float(slopes[k])
    ipx = float(cands[k])
    # ---- reported quantities -------------------------------------------------
    area_lig = AREA_MM2_TO_M2 * thickness_mm * ligament_mm
    Gf = f.Int1 / area_lig
    FI = Gf / abs(slope) * FI_FACTOR
    Str = (f.peak / (2 * (ligament_mm + LIGAMENT_OFFSET_MM) * thickness_mm)) * STRENGTH_CONST
    # ---------------------------------------------------------------------------
    f1 = ml.knnsearch(x, ipx)
    InfPtx, InfPty = float(x[f1]), float(y[f1])
    line_x = np.linspace(0, matlab_round(float(x[-1])), 100)
    line_y = slope * line_x + (-InfPtx * slope + InfPty)
    return SCBResult(f.peak, float(Str), float(Gf), slope, float(FI), InfPtx, InfPty, line_x, line_y,
                     f, needs_pick, picked, cands)


def analyse(x_mm: np.ndarray, y_kN: np.ndarray, thickness_mm: float, ligament_mm: float) -> SCBResult:
    x = np.asarray(x_mm, float)
    y = np.asarray(y_kN, float)
    f = fit_post_peak(x, y)
    cands = auto_inflection(x, y, f)
    if cands.size == 0:
        # v2: "Could Not Find Inflection Point. Please Select Inflection Point." -> operator clicks.
        # Provide a provisional answer at the steepest candidate root (if any) so the UI has something
        # to draw, but flag it.
        fallback = f.candidate_roots if f.candidate_roots.size else np.array([float(x[f.peak_index])])
        r = _evaluate(x, y, f, fallback, thickness_mm, ligament_mm, needs_pick=True, picked=False)
        return r
    return _evaluate(x, y, f, cands, thickness_mm, ligament_mm, needs_pick=False, picked=False)


def evaluate_at(x_mm: np.ndarray, y_kN: np.ndarray, thickness_mm: float, ligament_mm: float,
                picked_x_mm: float) -> SCBResult:
    """Operator picked a displacement: evaluate the same polynomial there (no refit)."""
    x = np.asarray(x_mm, float)
    y = np.asarray(y_kN, float)
    f = fit_post_peak(x, y)
    return _evaluate(x, y, f, np.array([float(picked_x_mm)]), thickness_mm, ligament_mm,
                     needs_pick=False, picked=True)
