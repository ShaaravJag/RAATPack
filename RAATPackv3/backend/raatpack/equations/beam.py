"""Beam fatigue — AASHTO T321 (exponential) and ASTM D7460 (normalized-modulus peak). Port of Beamfinder.m."""
from __future__ import annotations

from dataclasses import dataclass
from typing import List

import numpy as np

from ..numerics import matlab as ml
from ._base import Field, matlab_round

# ---- constants --------------------------------------------------------------
NF50_FRACTION = 0.5              # AASHTO: cycles to 50 % of initial stiffness  ->  ln(0.5)/b
ASTM_POLY_ORDER = 6
ASTM_FZERO_START = 100000.0      # v2 hard-coded fzero start for the peak of the NM·N curve

SPECIMEN_INPUTS = [
    Field("air_voids", "Air Voids (%)", 1),
    Field("width_mm", "Width (mm)", 1),
    Field("height_mm", "Height (mm)", 1),
    Field("length_mm", "Length (mm)", 1),
]
REQUIRED_INPUTS: List[str] = []

RESULT_FIELDS: List[Field] = [
    Field("stiffness_N50", "Stiffness Measured at N50", 0),
    Field("A", "A", 4, fmt=".2E"),
    Field("b", "b", 8, fmt=".2E"),
    Field("rsq_AASHTO", "R^2", 4, report=False),
    Field("nf50_AASHTO", "AASHTO nf,50", 0),
    Field("nf50_ASTM", "ASTM nf,50", 0),
    Field("E_N50", "Elastic Modulus at N50", 0, report=False),
    Field("max_normalized_modulus", "Max Normalized Modulus", 1, report=False),
    Field("x_at_max", "n at max", 0, report=False),
    Field("rsq_ASTM", "ASTM R^2", 4, report=False),
]


@dataclass
class BeamResult:
    stiffness_N50: float
    A: float
    b: float
    rsq_AASHTO: float
    nf50_AASHTO: float
    nf50_ASTM: float
    E_N50: float
    max_normalized_modulus: float
    x_at_max: float
    rsq_ASTM: float
    astm_coeffs: np.ndarray           # x6..x1 (constant term dropped, as v2 exports)
    fit_AASHTO: np.ndarray
    fit_ASTM: np.ndarray


def analyse(cycles, stiffness, modulus, normalized_modulus) -> BeamResult:
    cycles = np.asarray(cycles, float)
    S = np.asarray(stiffness, float)
    E = np.asarray(modulus, float)
    NM = np.asarray(normalized_modulus, float)

    # AASHTO
    A, b = ml.fit_exp1_robust_lar(cycles, S)
    fit_A = A * np.exp(b * cycles)
    ss_res = float(np.sum((S - fit_A) ** 2))
    ss_tot = float(np.sum((S - S.mean()) ** 2))
    rsq_A = 1 - ss_res / ss_tot if ss_tot else float("nan")
    # ---- reported quantities -------------------------------------------------
    nf50_A = matlab_round(np.log(NF50_FRACTION) / b)
    stiffness_N50 = matlab_round(float(S[0]))
    E_N50 = matlab_round(float(E[0]))
    # ASTM
    p = ml.polyfit(cycles, NM, ASTM_POLY_ORDER)
    fit_S = ml.polyval(p, cycles)
    d1 = ml.polyder(p)
    nf50_S = ml.fzero(lambda x: float(ml.polyval(d1, x)), ASTM_FZERO_START)
    rsq_S = ml.rsquared_ordinary(NM, fit_S)
    imax = int(np.argmax(NM))
    # ---------------------------------------------------------------------------
    return BeamResult(stiffness_N50, float(A), float(b), float(rsq_A), nf50_A, float(nf50_S), E_N50,
                      float(NM[imax]), float(cycles[imax]), float(rsq_S), p[:6], fit_A, fit_S)
