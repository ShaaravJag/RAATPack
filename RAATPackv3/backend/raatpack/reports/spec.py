"""The report data contract shared by the Excel and PDF writers."""
from __future__ import annotations

from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional

from ..equations._base import Field

FOOTER = "This report was developed using the Rutgers Asphalt Analysis Tool-Pack (RAAT-Pack)"


@dataclass
class Curve:
    name: str
    x: List[float]
    y: List[float]
    style: str = "line"          # line | dashed | marker
    color: Optional[str] = None


@dataclass
class ReportSpec:
    module_id: str
    layout: str                              # table | hamburg | apa | beam | dm
    title: str                               # standard / title line
    chart_title: str
    x_label: str
    y_label: str
    project: Dict[str, str]                  # project, mix_type, test_temp, institution, date, technician
    columns: List[Field]                     # table columns in order (after Specimen ID)
    rows: List[Dict[str, Any]]               # each has 'specimen_id' + column keys
    curves: List[Curve]
    stats: bool = True
    logo_path: Optional[str] = None
    passfail: Optional[float] = None
    passfail_label: str = ""
    notes: List[str] = field(default_factory=list)
    extra: Dict[str, Any] = field(default_factory=dict)   # layout-specific payload
    footer: str = FOOTER
    generated_by: str = "RAAT-Pack v3"


def fmt_value(v, f: Field) -> str:
    if v is None:
        return ""
    if isinstance(v, str):
        return v
    try:
        if f.fmt:
            return format(v, f.fmt)
        return f"{v:.{f.dp}f}"
    except Exception:
        return str(v)


# Windows refuses these as file names regardless of extension.
_RESERVED = {"CON", "PRN", "AUX", "NUL", *(f"COM{i}" for i in range(1, 10)),
             *(f"LPT{i}" for i in range(1, 10))}


def safe_filename_part(text: str, fallback: str = "summary", limit: int = 60) -> str:
    """Turn a user-typed project name into something safe to put in a file name and an HTTP header.

    The exported report is named after the project, so whatever the technician typed ends up both
    on disk and in Content-Disposition. An en dash or an accent raised UnicodeEncodeError when
    Starlette encoded the header as latin-1, and a slash or colon would have produced an
    unwritable path on Windows, which is where this ships.
    """
    import re
    import unicodedata

    # "Route 1 – Pöhl" -> "Route 1 - Pohl": keep what maps to ASCII, drop the rest.
    t = unicodedata.normalize("NFKD", text or "")
    t = t.replace("\u2013", "-").replace("\u2014", "-").replace("\u2018", "'").replace("\u2019", "'")
    t = t.encode("ascii", "ignore").decode("ascii")
    t = re.sub(r'[<>:"/\\|?*\x00-\x1f]', "", t)       # illegal in a Windows file name
    t = re.sub(r"\s+", "_", t.strip())
    t = re.sub(r"[._]+$", "", t)                        # Windows drops a trailing dot or space
    t = t[:limit].strip("_")
    if not t or t.upper().split(".")[0] in _RESERVED:
        return fallback
    return t
