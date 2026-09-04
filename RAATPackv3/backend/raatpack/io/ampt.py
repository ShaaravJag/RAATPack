"""
AMPT dynamic-modulus summary files (`*Sum.csv`) and the Hirsch G* input workbook.

v2 parsed the CSV through xlsread and indexed rows relative to the ' Dynamic modulus (MPa)'
label. The port locates the same label and reads the same three rows (modulus, phase angle,
average temperature) plus the frequency header row above it.
"""
from __future__ import annotations

import csv
import math
import re
from dataclasses import dataclass
from pathlib import Path
from typing import List, Optional

import numpy as np
import openpyxl

MPA_TO_PSI = 145.038


@dataclass
class AMPTSummary:
    path: str
    identification: str
    target_temp_c_file: Optional[float]    # 'Target test temperature' row (informational)
    frequencies_hz: np.ndarray
    modulus_mpa: np.ndarray
    phase_deg: np.ndarray
    avg_temp_c: np.ndarray


def _floats(cells: List[str]) -> List[float]:
    out = []
    for c in cells:
        s = (c or "").strip()
        if not s:
            continue
        try:
            out.append(float(s))
        except ValueError:
            pass
    return out


def read_ampt_summary(path: Path) -> AMPTSummary:
    text = Path(path).read_text(errors="replace")
    rows = list(csv.reader(text.splitlines()))
    label_row = None
    for i, r in enumerate(rows):
        if r and r[0].strip().lower() == "dynamic modulus (mpa)":
            label_row = i
            break
    if label_row is None:
        raise ValueError(f"{Path(path).name}: no ' Dynamic modulus (MPa)' row found — not an AMPT summary file")
    hdr = rows[label_row - 1][1:]
    freqs = []
    for h in hdr:
        s = h.strip()
        if not s:
            continue
        s = re.sub(r"\s*hz\s*$", "", s, flags=re.I)
        freqs.append(float(s))
    dm = _floats(rows[label_row][1:])
    phase = _floats(rows[label_row + 1][1:])
    temps = _floats(rows[label_row + 2][1:])
    n = min(len(freqs), len(dm), len(phase), len(temps))
    ident = ""
    target = None
    for r in rows:
        if r and r[0].strip().lower() == "identification" and len(r) > 1:
            ident = r[1].strip()
        if r and r[0].strip().lower() == "target test temperature" and len(r) > 1:
            try:
                target = float(r[1])
            except ValueError:
                pass
    return AMPTSummary(str(path), ident, target, np.array(freqs[:n]), np.array(dm[:n]),
                       np.array(phase[:n]), np.array(temps[:n]))


def guess_temperature_from_name(name: str) -> Optional[float]:
    """'Winslow_#1_45C_Sum.csv' -> 45.0"""
    m = re.search(r"[_\-\s](-?\d+(?:\.\d+)?)\s*C(?=[_\-\s.]|$)", name, flags=re.I)
    return float(m.group(1)) if m else None


@dataclass
class HirschInput:
    temps_f: np.ndarray
    frequency: np.ndarray
    g_star_psi: np.ndarray


def read_hirsch_input(path: Path) -> HirschInput:
    """xlsread(file,1): first sheet numeric matrix, columns temp(F), freq, G*(psi)."""
    wb = openpyxl.load_workbook(str(path), data_only=True, read_only=True)
    ws = wb.worksheets[0]
    rows = []
    for r in ws.iter_rows(values_only=True):
        vals = [v if isinstance(v, (int, float)) and not isinstance(v, bool) else math.nan for v in r]
        if len(vals) >= 3 and not any(math.isnan(v) for v in vals[:3]):
            rows.append(vals[:3])
    M = np.array(rows, float) if rows else np.zeros((0, 3))
    return HirschInput(M[:, 0], M[:, 1], M[:, 2])
