"""
Raw machine-file readers — faithful ports of v2's file_opener.m, SCBopen.m,
ColdSCBopen.m / DCTopen.m and beam_opener.m.

All readers return numpy arrays already transformed and converted to the units the
kernels expect (mm, kN, sec).
"""
from __future__ import annotations

import csv
import io
import math
from dataclasses import dataclass
from pathlib import Path
from typing import List, Optional, Sequence, Tuple

import numpy as np
import openpyxl

from .templates import Template, ChannelTransform, KIND_XY, KIND_FOUR, KIND_BEAM


# ---------------------------------------------------------------------------
# Generic tabular loader (readtable with SelectedVariableNames / DataRange)
# ---------------------------------------------------------------------------

def _to_float(v) -> float:
    if v is None or isinstance(v, bool):
        return math.nan
    if isinstance(v, (int, float)):
        return float(v)
    s = str(v).strip()
    if not s:
        return math.nan
    try:
        return float(s)
    except ValueError:
        return math.nan



class NotADataFile(ValueError):
    """The file is not test data at all (an Excel lock file, OS metadata)."""


def describe_read_failure(name: str, exc: BaseException) -> str:
    """A cause an engineer can act on, instead of the raw exception text.

    The default here used to be e.g. "Could not read file: BadZipFile: File is not a zip file",
    which tells a lab technician nothing about what to do next.
    """
    import zipfile

    if isinstance(exc, NotADataFile):
        return str(exc)
    if isinstance(exc, zipfile.BadZipFile):
        return (f"{name} is not a readable Excel workbook. If it is a CSV that was renamed .xlsx, "
                f"rename it back to .csv; if Excel still has it open, close the file and try again; "
                f"otherwise re-save it from Excel as .xlsx.")
    if isinstance(exc, PermissionError):
        return f"{name} is locked by another program. Close it in Excel and try again."
    if isinstance(exc, FileNotFoundError):
        return f"{name} is no longer where it was — it may have been moved, renamed or deleted."
    if isinstance(exc, UnicodeDecodeError):
        return (f"{name} is not readable as text. A .csv or .txt file is expected here; if this is "
                f"a spreadsheet, save it as .xlsx or .csv first.")
    if isinstance(exc, (IndexError, KeyError)):
        return (f"{name} does not have the columns this template expects. Check the template's "
                f"column numbers and data-start row against the file.")
    if isinstance(exc, ValueError):
        return f"{name} could not be read: {exc}"
    return f"{name} could not be read ({type(exc).__name__}: {exc})."

def load_columns(path: Path, columns: Sequence[int], data_start: int, data_end: Optional[int],
                 sheet: int = 1, delimiter: str = ",") -> np.ndarray:
    """Return an (n, len(columns)) float matrix of the requested 1-based columns, from row
    `data_start` (1-based) to `data_end` (inclusive, None=Inf). Non-numeric cells -> NaN.
    Rows containing any NaN are dropped — `xy_data(~any(ismissing(xy_data),2),:)`."""
    path = Path(path)
    ext = path.suffix.lower()
    rows: List[List] = []
    if ext in (".xlsx", ".xlsm", ".xls"):
        if ext == ".xls":
            raise ValueError("Legacy binary .xls is not supported; save the file as .xlsx or .csv.")
        wb = openpyxl.load_workbook(str(path), data_only=True, read_only=True)
        idx = max(0, min(sheet - 1, len(wb.worksheets) - 1))
        ws = wb.worksheets[idx]
        for i, r in enumerate(ws.iter_rows(values_only=True), 1):
            if i < data_start:
                continue
            if data_end is not None and i > data_end:
                break
            rows.append(list(r))
    else:
        text = path.read_text(errors="replace")
        rdr = csv.reader(io.StringIO(text), delimiter=(delimiter or ","))
        for i, r in enumerate(rdr, 1):
            if i < data_start:
                continue
            if data_end is not None and i > data_end:
                break
            rows.append(r)
    out = np.full((len(rows), len(columns)), math.nan)
    for i, r in enumerate(rows):
        for j, c in enumerate(columns):
            k = int(c) - 1
            if 0 <= k < len(r):
                out[i, j] = _to_float(r[k])
    keep = ~np.any(np.isnan(out), axis=1)
    return out[keep]


# ---------------------------------------------------------------------------
# Transformations & units (file_opener.m semantics — shared by every opener)
# ---------------------------------------------------------------------------

def apply_transform(v: np.ndarray, t: ChannelTransform) -> np.ndarray:
    """The v2 six-branch transform. Unlisted flag combinations are no-ops (as in v2)."""
    if v.size == 0:
        return v
    s, n, e = t.as_tuple()
    if (s, n, e) == (1, 0, 0):
        return v - v[0]
    if (s, n, e) == (1, 1, 0):
        return -(v - v[0])
    if (s, n, e) == (0, 1, 0):
        return -v
    if (s, n, e) == (0, 1, 1):
        return -(v - v[-1])
    if (s, n, e) == (0, 0, 1):
        return -(v - v[-1])
    return v


def convert_length(v: np.ndarray, units: str) -> np.ndarray:
    u = (units or "mm").strip().lower()
    if u == "m":
        return v * 1000.0
    if u in ("inches", "in", "inch"):
        return v * 25.4
    return v


def convert_load(v: np.ndarray, units: str) -> np.ndarray:
    u = (units or "kN").strip().lower()
    if u == "lb":
        return v * 0.0044482216152605
    if u == "kip":
        return v * 4.4482216
    if u == "n":
        return v * 0.001
    return v


def convert_time(v: np.ndarray, time_units: str, cod_units: str) -> np.ndarray:
    # v2 quirk: the 'min' test looks at the COD units cell, not the time units cell.
    if (time_units or "sec").strip().lower() == "sec":
        return v
    if (cod_units or "").strip().lower() == "min":
        return v * 60.0
    return v


# ---------------------------------------------------------------------------
# Two-channel (file_opener.m): IDEAL-CT, HT-IDT, Bond Strength
# ---------------------------------------------------------------------------

@dataclass
class XYCurve:
    x: np.ndarray
    y: np.ndarray


def read_xy(path: Path, t: Template) -> XYCurve:
    if t.kind != KIND_XY:
        raise ValueError("template is not a two-channel template")
    m = load_columns(path, [t.columns["x"], t.columns["y"]], t.data_start, t.data_end, t.sheet, t.delimiter)
    x = apply_transform(m[:, 0].copy(), t.transforms.get("x", ChannelTransform()))
    y = apply_transform(m[:, 1].copy(), t.transforms.get("y", ChannelTransform()))
    x = convert_length(x, t.units.get("x", "mm"))
    y = convert_load(y, t.units.get("y", "kN"))
    return XYCurve(x, y)


# ---------------------------------------------------------------------------
# SCB (SCBopen.m): two-channel + automatic end trim at 0.1 kN
# ---------------------------------------------------------------------------

SCB_TRIM_LOAD_KN = 0.1


def scb_end_trim(x: np.ndarray, y: np.ndarray) -> Tuple[np.ndarray, np.ndarray]:
    """Faithful port of SCBopen.m's end-trim.

    If the load never drops back below 0.1 kN after the peak, cut at the last minimum after
    the peak; otherwise cut at the last point above 0.1 kN, then keep shaving one point
    while the final segment has exactly zero slope."""
    F = np.flatnonzero(y > SCB_TRIM_LOAD_KN)
    below = np.flatnonzero(y < SCB_TRIM_LOAD_KN)
    max_index = int(np.argmax(y))
    search = y[max_index:]
    index_lastmin = int(np.argmin(search)) + max_index
    if below.size == 0 or below[-1] < max_index:
        return x[: index_lastmin + 1], y[: index_lastmin + 1]
    index1 = int(F[-1])              # 0-based index of last point > 0.1 kN
    x = x[: index1 + 1]
    y = y[: index1 + 1]
    while True:
        if index1 < 1:
            break
        dx = x[index1] - x[index1 - 1]
        slope = (y[index1] - y[index1 - 1]) / dx if dx != 0 else math.inf
        if slope == 0:
            F = np.flatnonzero(y > SCB_TRIM_LOAD_KN)
            index1 = int(F[-1]) - 1 if F.size else index1 - 1
        x = x[: index1 + 1]
        y = y[: index1 + 1]
        if slope != 0:
            break
    return x, y


def scb_begin_trim(x: np.ndarray, y: np.ndarray, cutoff_x: float) -> Tuple[np.ndarray, np.ndarray]:
    """'Trim Beginning?' — drop everything before the point nearest the chosen displacement."""
    i = int(np.argmin(np.abs(x - cutoff_x)))
    return x[i:], y[i:]


def read_scb_xy(path: Path, t: Template) -> XYCurve:
    c = read_xy(path, t)
    x, y = scb_end_trim(c.x, c.y)
    return XYCurve(x, y)


# ---------------------------------------------------------------------------
# Four-channel (ColdSCBopen.m / DCTopen.m): time, stroke, load, COD
# ---------------------------------------------------------------------------

@dataclass
class FourChannel:
    time: np.ndarray
    stroke: np.ndarray
    load: np.ndarray
    cod: np.ndarray


def read_four_channel(path: Path, t: Template) -> FourChannel:
    if t.kind != KIND_FOUR:
        raise ValueError("template is not a four-channel template")
    m = load_columns(path, [t.columns["time"], t.columns["stroke"], t.columns["load"], t.columns["cod"]],
                     t.data_start, t.data_end, t.sheet, t.delimiter)
    time = m[:, 0].copy()
    stroke = m[:, 1].copy()
    load = m[:, 2].copy()
    cod = m[:, 3].copy()
    # v2 always zeroes time first
    if time.size:
        time = time - time[0]
    # v2 mapping quirk (reproduced): config rows 12-14 -> COD, 15-17 -> Load, 18-20 -> Time, 21-23 -> Stroke
    tr = t.transforms
    cod = apply_transform(cod, tr.get("row12", ChannelTransform()))
    load = apply_transform(load, tr.get("row15", ChannelTransform()))
    stroke = apply_transform(stroke, tr.get("row21", ChannelTransform()))
    time = apply_transform(time, tr.get("row18", ChannelTransform()))
    # units: rows 24 time, 25 stroke, 26 load, 27 COD (v2 reads them in this order)
    time = convert_time(time, t.units.get("time", "sec"), t.units.get("cod", "mm"))
    cod = convert_length(cod, t.units.get("cod", "mm"))
    stroke = convert_length(stroke, t.units.get("stroke", "mm"))
    load = convert_load(load, t.units.get("load", "kN"))
    return FourChannel(time, stroke, load, cod)


# ---------------------------------------------------------------------------
# Beam (beam_opener.m)
# ---------------------------------------------------------------------------

@dataclass
class BeamData:
    cycles: np.ndarray
    stiffness: np.ndarray
    modulus: np.ndarray
    normalized_modulus: np.ndarray


BEAM_FIRST_CYCLE_TO_DROP = 10   # if the file starts at cycle 10, v2 drops the first 4 rows (starts at 50)


def read_beam(path: Path, t: Template) -> BeamData:
    if t.kind != KIND_BEAM:
        raise ValueError("template is not a beam template")
    m = load_columns(path, [t.columns["cycles"], t.columns["stiffness"], t.columns["modulus"]],
                     t.data_start, t.data_end, t.sheet, t.delimiter)
    cycles, stiff, E = m[:, 0].copy(), m[:, 1].copy(), m[:, 2].copy()
    nm = (E / E[0]) * (cycles / cycles[0])
    if cycles.size and cycles[0] == BEAM_FIRST_CYCLE_TO_DROP:
        cycles, stiff, E, nm = cycles[4:], stiff[4:], E[4:], nm[4:]
    return BeamData(cycles, stiff, E, nm)
