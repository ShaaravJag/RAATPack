"""HT-IDT (high-temperature indirect tensile strength). Port of IDTStrfinder.m."""
from __future__ import annotations

from dataclasses import dataclass
from typing import List

import numpy as np

from ._base import Field

KN_TO_N = 1000.0
IDT_FACTOR = 2000.0      # S_t = 2000·P_N / (π·t·D)  -> kPa

SPECIMEN_INPUTS = [
    Field("air_voids", "Air Voids (%)", 1),
    Field("thickness_mm", "Thickness (mm)", 1),
    Field("diameter_mm", "Diameter (mm)", 1),
]
REQUIRED_INPUTS = ["thickness_mm", "diameter_mm"]

RESULT_FIELDS: List[Field] = [
    Field("peak_load_N", "Peak Load (N)", 1),
    Field("idt_strength_kPa", "IDT Strength (kPa)", 1),
]


@dataclass
class HTIDTResult:
    peak_load_N: float
    idt_strength_kPa: float
    peak_index: int


def analyse(x_mm: np.ndarray, y_kN: np.ndarray, thickness_mm: float, diameter_mm: float) -> HTIDTResult:
    y = np.asarray(y_kN, float)
    peak_kN = float(y.max())
    peak_N = peak_kN * KN_TO_N
    # ---- reported quantities -------------------------------------------------
    idt = peak_N * IDT_FACTOR / (np.pi * thickness_mm * diameter_mm)
    # ---------------------------------------------------------------------------
    return HTIDTResult(peak_N, float(idt), int(np.argmax(y)))
