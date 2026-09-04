"""
Hamburg wheel-track — AASHTO T324. Faithful port of HAMfinder.m (verified exact vs. v2 demo
report: max rut to 0.1 %, SIP 16197 to the digit, SIP-suppression rule reproduced).

Manual override (v2's "Are the slopes okay? -> No -> click stripping point, click creep point")
is `analyse_wheel(..., strip_pick=, creep_pick=)`. In that path v2 reports max rut as the
measured maximum, not the polynomial at 20,000 passes — reproduced.
"""
from __future__ import annotations

from dataclasses import dataclass
from typing import List, Optional

import numpy as np

from ..numerics import matlab as ml
from ._base import Field

# ---- constants --------------------------------------------------------------
POLY_ORDER = 6
SECANT_HALF_WIDTH = 10.0         # slopes are secants over ±10 passes
CREEP_MIN_GAP = 1.0              # creep root must be > 1 pass before the stripping location
SIP_RATIO_MIN = 2.0              # inflection point reported only if stripping/creep >= 2
MAX_RUT_AT_PASSES = 20000.0      # rut reported at exactly 20,000 passes (polynomial, extrapolated if needed)
LINE_EXTENT = 0.25e4             # plotting: line extents around the SIP

SPECIMEN_INPUTS = [Field("air_voids", "Air Voids (%)", 1)]
REQUIRED_INPUTS: List[str] = []

RESULT_FIELDS: List[Field] = [
    Field("max_rut_mm", "Average Rutting at 20,000 cycles (mm)", 2),
    Field("creep_slope", "Average Creep Slope (mm/cycle)", 6, fmt=".2E"),
    Field("stripping_slope", "Average Stripping Slope (mm/cycle)", 6, fmt=".2E"),
    Field("sip_cycles", "Stripping Inflection Point (cycles)", 0),
]


@dataclass
class WheelResult:
    max_rut_mm: float
    creep_slope: float               # positive (display sign — v2 negates depth then negates back)
    stripping_slope: float
    sip_ratio: float
    sip_cycles: Optional[float]      # None if ratio < 2
    inflection_x: float
    inflection_y: float              # in the negated-depth frame v2 plots in
    strip_location: float
    creep_location: float
    poly: np.ndarray
    creep_line_x: np.ndarray
    creep_line_y: np.ndarray
    strip_line_x: np.ndarray
    strip_line_y: np.ndarray
    extrapolated: bool               # True if 20,000 passes lies beyond the data
    manual: bool


def _secant(poly, x0):
    x1, x2 = x0 - SECANT_HALF_WIDTH, x0 + SECANT_HALF_WIDTH
    y1, y2 = ml.polyval(poly, x1), ml.polyval(poly, x2)
    slope = (y2 - y1) / (x2 - x1)
    intercept = -(x1 * slope) + y1
    return float(slope), float(intercept)


def analyse_wheel(cycles: np.ndarray, depth: np.ndarray,
                  strip_pick: Optional[float] = None, creep_pick: Optional[float] = None) -> WheelResult:
    cycles = np.asarray(cycles, float)
    d = -np.asarray(depth, float)                    # v2: left = -left
    poly = ml.polyfit(cycles, d, POLY_ORDER)
    dp = ml.polyder(poly)
    d2p = ml.polyder(dp)
    N = float(cycles[-1])
    manual = strip_pick is not None or creep_pick is not None

    # stripping location: minimum of the 1st derivative on [N/2, N]
    if strip_pick is None:
        Ns = ml.fminbnd(lambda x: ml.polyval(dp, x), N / 2.0, N)
    else:
        Ns = float(strip_pick)
    Ss, Sint = _secant(poly, Ns)

    # creep location: real root of the 2nd derivative more than 1 pass before Ns with the largest 1st derivative
    if creep_pick is None:
        r = ml.real_roots_matlab(ml.roots(d2p))
        r = r[r != 0]
        r = r[(r - Ns) < -CREEP_MIN_GAP]
        if r.size == 0:
            raise ValueError("No creep-slope location found before the stripping location — pick the slopes manually.")
        Nc = float(r[np.argmax(ml.polyval(dp, r))])
    else:
        Nc = float(creep_pick)
    Cs, Cint = _secant(poly, Nc)

    # ---- reported quantities -------------------------------------------------
    sip_x = (Sint - Cint) / (Cs - Ss)
    sip_y = Ss * sip_x + Sint
    if manual:
        max_rut = float(np.max(-d))                  # v2 manual path: max of measured depth
    else:
        max_rut = float(-ml.polyval(poly, MAX_RUT_AT_PASSES))
    stripping_slope = Ss
    creep_slope = Cs
    ratio = stripping_slope / creep_slope
    sip = sip_x if ratio >= SIP_RATIO_MIN else None
    # ---------------------------------------------------------------------------

    Sx = np.linspace(sip_x - LINE_EXTENT, N, 100)
    Sy = Ss * (Sx - sip_x) + sip_y
    Cx = np.linspace(0, sip_x + LINE_EXTENT, 100)
    Cy = Cs * (Cx - sip_x) + sip_y
    return WheelResult(max_rut, -creep_slope, -stripping_slope, float(ratio), sip, float(sip_x), float(sip_y),
                       Ns, Nc, poly, Cx, -Cy, Sx, -Sy, bool(N < MAX_RUT_AT_PASSES), manual)


@dataclass
class HamburgResult:
    left: WheelResult
    right: WheelResult
    # averages with Excel AVERAGE semantics (blanks ignored) — matches the v2 report sheet
    avg_max_rut_mm: float
    avg_creep_slope: float
    avg_stripping_slope: float
    avg_sip_cycles: Optional[float]


def combine(left: WheelResult, right: WheelResult) -> HamburgResult:
    sips = [s for s in (left.sip_cycles, right.sip_cycles) if s is not None]
    return HamburgResult(left, right,
                         (left.max_rut_mm + right.max_rut_mm) / 2.0,
                         (left.creep_slope + right.creep_slope) / 2.0,
                         (left.stripping_slope + right.stripping_slope) / 2.0,
                         (sum(sips) / len(sips)) if sips else None)


def analyse(cycles_left, left, cycles_right, right,
            picks_left=None, picks_right=None) -> HamburgResult:
    pl = picks_left or {}
    pr = picks_right or {}
    L = analyse_wheel(cycles_left, left, pl.get("strip"), pl.get("creep"))
    R = analyse_wheel(cycles_right, right, pr.get("strip"), pr.get("creep"))
    return combine(L, R)
