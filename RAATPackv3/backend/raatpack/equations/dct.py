"""DCT — ASTM D7313. Port of DCTfinder.m."""
from __future__ import annotations

from dataclasses import dataclass
from typing import List

import numpy as np

from ..numerics import matlab as ml
from ._base import Field

MM2_TO_M2 = 1e6

SPECIMEN_INPUTS = [
    Field("air_voids", "Air Voids (%)", 1),
    Field("diameter_mm", "Diameter (mm)", 2),
    Field("thickness_mm", "Thickness (mm)", 2),
    Field("ligament_mm", "Ligament (mm)", 2),
]
REQUIRED_INPUTS = ["thickness_mm", "ligament_mm"]

RESULT_FIELDS: List[Field] = [
    Field("peak_load_kN", "Peak Load (kN)", 3),
    Field("displacement_at_peak_mm", "Displacement at Peak (mm)", 3),
    Field("time_at_peak_s", "Time at Peak Load (sec)", 2),
    Field("test_duration_s", "Test Duration (sec)", 2, report=False),
    Field("Gf_J_per_m2", "Fracture Energy (J/m2)", 1),
    Field("cmod_slope_mm_per_s", "CMOD Slope (mm/s)", 4),
]


@dataclass
class DCTResult:
    peak_load_kN: float
    displacement_at_peak_mm: float
    time_at_peak_s: float
    test_duration_s: float
    Gf_J_per_m2: float
    cmod_slope_mm_per_s: float
    cmod_intercept: float
    fitted_cod: np.ndarray
    peak_index: int


def analyse(time: np.ndarray, stroke: np.ndarray, load: np.ndarray, cod: np.ndarray,
            thickness_mm: float, ligament_mm: float) -> DCTResult:
    time = np.asarray(time, float)
    load = np.asarray(load, float)
    cod = np.asarray(cod, float)
    slope, b = ml.fitlm_slope_intercept(time, cod)
    fitted = slope * time                           # v2 drops the intercept
    area = ml.trapz(load, fitted)
    peak = float(load.max())
    n1 = int(np.argmax(load))
    # ---- reported quantities -------------------------------------------------
    Gf = MM2_TO_M2 * area / (thickness_mm * ligament_mm)
    disp_at_peak = float(fitted[n1])
    time_at_peak = float(time[n1])
    duration = float(time[-1])
    # ---------------------------------------------------------------------------
    return DCTResult(peak, disp_at_peak, time_at_peak, duration, float(Gf), float(slope), float(b), fitted, n1)
