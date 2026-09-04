"""Bond Strength (interlayer shear). Port of BondStrfinder.m."""
from __future__ import annotations

from dataclasses import dataclass
from typing import List

import numpy as np

from ._base import Field

KN_PER_MM2_TO_PSI = 145038.0     # 1 kN/mm² = 1 GPa = 145,038 psi
MM_TO_IN = 0.0393701

SPECIMEN_INPUTS = [
    Field("air_voids", "Air Voids (%)", 1),
    Field("length_mm", "Length (mm)", 1),
    Field("diameter_mm", "Diameter (mm)", 1),
]
REQUIRED_INPUTS = ["length_mm", "diameter_mm"]

RESULT_FIELDS: List[Field] = [
    Field("length_in", "Length (in)", 2),
    Field("diameter_in", "Diameter (in)", 2),
    Field("peak_load_kN", "Peak Load (kN)", 2),
    Field("displacement_at_peak_mm", "Displacement at Peak (mm)", 3),
    Field("bond_strength_psi", "Bond Strength (psi)", 1),
]


@dataclass
class BondResult:
    length_in: float
    diameter_in: float
    peak_load_kN: float
    displacement_at_peak_mm: float
    bond_strength_psi: float
    peak_index: int


def analyse(x_mm: np.ndarray, y_kN: np.ndarray, diameter_mm: float, length_mm: float) -> BondResult:
    x = np.asarray(x_mm, float)
    y = np.asarray(y_kN, float)
    peak = float(y.max())
    n1 = int(np.argmax(y))
    # ---- reported quantities -------------------------------------------------
    bond = peak / (np.pi * diameter_mm ** 2 / 4.0) * KN_PER_MM2_TO_PSI
    disp = float(x[n1])
    length_in = length_mm * MM_TO_IN
    diameter_in = diameter_mm * MM_TO_IN
    # ---------------------------------------------------------------------------
    return BondResult(float(length_in), float(diameter_in), peak, disp, float(bond), n1)
