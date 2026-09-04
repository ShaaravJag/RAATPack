"""Shared bits for the equation modules."""
from __future__ import annotations

import math
from dataclasses import dataclass
from typing import Any, List, Optional

import numpy as np


@dataclass(frozen=True)
class Field:
    """One reported quantity. `key` must match the attribute name on the module's Result."""
    key: str
    label: str
    dp: int = 2              # decimals shown in tables/reports
    report: bool = True      # include in the exported summary sheet
    fmt: str = ""            # optional python format override, e.g. ".2E"


def matlab_round(v: float) -> float:
    """MATLAB round(): halves away from zero."""
    if v is None or (isinstance(v, float) and math.isnan(v)):
        return v
    return float(math.floor(abs(v) + 0.5) * (1 if v >= 0 else -1))


def clean(v: Any):
    """Convert numpy scalars / NaN / inf into JSON-safe python values."""
    if v is None:
        return None
    if isinstance(v, (np.floating, float)):
        f = float(v)
        return None if (math.isnan(f) or math.isinf(f)) else f
    if isinstance(v, (np.integer, int)):
        return int(v)
    if isinstance(v, np.ndarray):
        return [clean(x) for x in v.tolist()]
    if isinstance(v, (list, tuple)):
        return [clean(x) for x in v]
    if isinstance(v, dict):
        return {k: clean(x) for k, x in v.items()}
    return v
