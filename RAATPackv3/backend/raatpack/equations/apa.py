"""APA (Asphalt Pavement Analyzer) rutting — AASHTO T340. Port of APAfinder.m."""
from __future__ import annotations

from dataclasses import dataclass
from typing import List, Optional

import numpy as np

from ..io.ipc import APAData
from ._base import Field

SPECIMEN_INPUTS = [Field("air_voids", "Air Voids (%)", 2)]
REQUIRED_INPUTS: List[str] = []

RESULT_FIELDS: List[Field] = [
    Field("left_rut_mm", "Left Rut Depth (mm)", 2),
    Field("center_rut_mm", "Middle Rut Depth (mm)", 2),
    Field("right_rut_mm", "Right Rut Depth (mm)", 2),
    Field("average_rut_mm", "Average Rut Depth (mm)", 2, report=False),
]


@dataclass
class APAResult:
    left_rut_mm: Optional[float]
    center_rut_mm: Optional[float]
    right_rut_mm: Optional[float]
    average_rut_mm: Optional[float]
    wheels: int


def _last_nonzero(v: np.ndarray) -> Optional[float]:
    if v.size == 0:
        return None
    last = float(v[-1])
    return last if last != 0 else None


def analyse(d: APAData) -> APAResult:
    l = _last_nonzero(d.left)
    c = _last_nonzero(d.center)
    r = _last_nonzero(d.right)
    wheels = 3 - (l is None) - (c is None) - (r is None)
    # ---- reported quantities -------------------------------------------------
    avg = ((l or 0.0) + (c or 0.0) + (r or 0.0)) / wheels if wheels else None
    # ---------------------------------------------------------------------------
    return APAResult(l, c, r, avg, wheels)
