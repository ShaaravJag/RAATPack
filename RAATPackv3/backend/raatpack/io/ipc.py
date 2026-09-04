"""
IPC Global wheel-tracker workbooks (APA and Hamburg) — ports of APAopen.m / HAMopen.m.

Both read the *second* sheet ("RawData") with MATLAB's xlsread semantics: text -> NaN,
leading all-NaN rows and columns trimmed.
"""
from __future__ import annotations

import math
from dataclasses import dataclass
from pathlib import Path
from typing import Optional

import numpy as np
import openpyxl


def xlsread_num(path: Path, sheet_index: int) -> np.ndarray:
    """MATLAB [num]=xlsread(file, sheet): numeric matrix, text->NaN, leading all-NaN rows/cols trimmed."""
    wb = openpyxl.load_workbook(str(path), data_only=True, read_only=True)
    ws = wb.worksheets[sheet_index]
    rows = []
    for r in ws.iter_rows(values_only=True):
        rows.append([v if isinstance(v, (int, float)) and not isinstance(v, bool) else math.nan for v in r])
    if not rows:
        return np.zeros((0, 0))
    w = max(len(r) for r in rows)
    M = np.full((len(rows), w), math.nan)
    for i, r in enumerate(rows):
        M[i, : len(r)] = r
    while M.shape[0] and np.all(np.isnan(M[0])):
        M = M[1:]
    while M.shape[1] and np.all(np.isnan(M[:, 0])):
        M = M[:, 1:]
    return M


# -- column layout of the IPC RawData sheet (1-based, as in v2) --------------
APA_COL_CYCLES = 22
APA_COL_LEFT = 23
APA_COL_CENTER = 24
APA_COL_RIGHT = 25
HAM_COL_CYCLES_L = 2
HAM_COL_CYCLES_R = 14
HAM_COL_DEPTH_L = 23
HAM_COL_DEPTH_R = 25
APA_EMPTY_CHECK_ROW = 100     # v2 decides a wheel is unused by looking at row 100


@dataclass
class APAData:
    left: np.ndarray
    center: np.ndarray
    right: np.ndarray
    cycles_left: np.ndarray
    cycles_center: np.ndarray
    cycles_right: np.ndarray
    cycles_avg: np.ndarray
    avg: np.ndarray
    wheels: int


def _wheel(cycles: np.ndarray, col: np.ndarray):
    # MATLAB: FL = find(col ~= 0)  — NaN ~= 0 is true, then NaNs are dropped separately.
    F = np.flatnonzero((col != 0) | np.isnan(col))
    c = cycles[F]
    c = c[~np.isnan(c)]
    d = col[F]
    d = np.concatenate([[0.0], d[~np.isnan(d)]])   # v2 prepends a zero to the depth only
    return c, d


def read_apa(path: Path) -> APAData:
    num = xlsread_num(path, 1)
    cycles = num[:, APA_COL_CYCLES - 1]
    left = num[:, APA_COL_LEFT - 1]
    center = num[:, APA_COL_CENTER - 1]
    right = num[:, APA_COL_RIGHT - 1]
    cL, dL = _wheel(cycles, left)
    cR, dR = _wheel(cycles, right)
    cC, dC = _wheel(cycles, center)

    data = np.column_stack([left, center, right])
    table = data.copy()
    r = APA_EMPTY_CHECK_ROW - 1
    keep = [True, True, True]
    if data.shape[0] > r:
        for j in (2, 1, 0):
            if data[r, j] == 0:
                keep[j] = False
    table = table[:, [j for j in range(3) if keep[j]]]

    maxes = []
    for c in (cC, cL, cR):
        m = float(np.max(c)) if c.size else 0.0
        if m != 0:
            maxes.append(m)
    amax = int(min(maxes)) if maxes else 0
    cycles_avg = np.arange(1, amax + 1, dtype=float)
    table = table[:amax, :]
    ncols = table.shape[1] if table.shape[1] else 1
    avg = np.sum(table, axis=1) / ncols
    wheels = 3 - (1 if not cL.size else 0) - (1 if not cC.size else 0) - (1 if not cR.size else 0)
    return APAData(dL, dC, dR, cL, cC, cR, cycles_avg, avg, wheels)


@dataclass
class HamburgData:
    cycles_left: np.ndarray
    cycles_right: np.ndarray
    left: np.ndarray
    right: np.ndarray


def read_hamburg(path: Path) -> HamburgData:
    num = xlsread_num(path, 1)
    cL_all = num[2:, HAM_COL_CYCLES_L - 1]
    cR_all = num[2:, HAM_COL_CYCLES_R - 1]
    lidx = int(np.nanargmax(cL_all)) + 1           # 1-based index within the sliced vector
    ridx = int(np.nanargmax(cR_all)) + 1
    # v2 quirk (reproduced): the relative index is used as an absolute row: num(3:lidx, ·)
    left = num[2:lidx, HAM_COL_DEPTH_L - 1]
    right = num[2:ridx, HAM_COL_DEPTH_R - 1]
    cyclesL = num[2:lidx, HAM_COL_CYCLES_L - 1]
    cyclesR = num[2:ridx, HAM_COL_CYCLES_R - 1]
    return HamburgData(cyclesL, cyclesR, left, right)
