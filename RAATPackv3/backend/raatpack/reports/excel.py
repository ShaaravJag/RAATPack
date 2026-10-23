"""
Excel summary reports — openpyxl, native charts, no Excel installation required.

Reproduces the v2 summary-sheet layout: standard title, project block, results table with
Average / Std Dev / COV rows (as live formulas, guarded against #DIV/0!), the load–displacement
chart, and a 'Sample Data' sheet holding every curve in three-column groups exactly as v2 wrote
it (so downstream spreadsheets that referenced 'Sample Data'!A3:B… keep working).
"""
from __future__ import annotations

import logging
from pathlib import Path
from typing import List, Optional

from openpyxl import Workbook
from openpyxl.chart import ScatterChart, Reference, Series
from openpyxl.chart.axis import ChartLines
from openpyxl.drawing.image import Image as XLImage
from openpyxl.styles import Alignment, Border, Font, PatternFill, Side
from openpyxl.utils import get_column_letter

from .spec import ReportSpec, Curve, fmt_value

LOG = logging.getLogger(__name__)

THIN = Side(style="thin", color="999999")
BORDER = Border(left=THIN, right=THIN, top=THIN, bottom=THIN)
HEAD_FILL = PatternFill("solid", fgColor="D9E1F2")
STAT_FILL = PatternFill("solid", fgColor="F2F2F2")
TITLE_FONT = Font(bold=True, size=12)
BOLD = Font(bold=True)


def _scatter(title, x_label, y_label, width=18, height=10):
    ch = ScatterChart()
    ch.title = title
    ch.style = 13
    ch.x_axis.title = x_label
    ch.y_axis.title = y_label
    ch.x_axis.majorGridlines = None
    ch.y_axis.majorGridlines = ChartLines()
    ch.width = width
    ch.height = height
    ch.legend.position = "b"
    return ch


def _add_series(ch, ws, name_cell, xref, yref, dashed=False, marker=False, smooth=True):
    s = Series(yref, xref, title_from_data=False, title=None)
    s.tx = None
    from openpyxl.chart.series import SeriesLabel
    from openpyxl.chart.data_source import StrRef
    s.title = SeriesLabel(strRef=StrRef(name_cell)) if name_cell else None
    s.smooth = smooth
    if marker:
        s.marker.symbol = "circle"
        s.marker.size = 5
        s.graphicalProperties.line.noFill = True
    else:
        s.marker.symbol = "none"
        s.graphicalProperties.line.width = 20000
        if dashed:
            s.graphicalProperties.line.dashStyle = "dash"
    ch.series.append(s)
    return s


def _write_sample_data(wb: Workbook, curves: List[Curve], x_label: str, y_label: str, sheet_name="Sample Data"):
    ws = wb.create_sheet(sheet_name)
    for k, c in enumerate(curves):
        col = 1 + 3 * k
        ws.cell(row=1, column=col, value=f"#{k + 1}")
        ws.cell(row=2, column=col, value=x_label)
        ws.cell(row=2, column=col + 1, value=y_label)
        for i, (xv, yv) in enumerate(zip(c.x, c.y)):
            ws.cell(row=3 + i, column=col, value=float(xv))
            ws.cell(row=3 + i, column=col + 1, value=float(yv))
    return ws


def _header(ws, spec: ReportSpec, title_col: int, ncols: int):
    ws.cell(row=1, column=title_col, value=spec.title).font = TITLE_FONT
    ws.merge_cells(start_row=1, start_column=title_col, end_row=1, end_column=max(title_col + 3, ncols))
    ws.cell(row=1, column=title_col).alignment = Alignment(wrap_text=True, vertical="center")
    ws.row_dimensions[1].height = 42
    p = spec.project
    left = [("Project Name:", p.get("project", "")), ("Mix Type:", p.get("mix_type", "")),
            ("Test Temperature:", p.get("test_temp", ""))]
    right = [("Institution:", p.get("institution", "")), ("Date Tested:", p.get("date", "")),
             ("Technician:", p.get("technician", ""))]
    rc = max(5, ncols // 2 + 1)
    for i, ((la, va), (lb, vb)) in enumerate(zip(left, right)):
        r = 2 + i
        ws.cell(row=r, column=2, value=la).font = BOLD
        ws.cell(row=r, column=3, value=va)
        ws.cell(row=r, column=rc, value=lb).font = BOLD
        ws.cell(row=r, column=rc + 1, value=vb)
    if spec.logo_path and Path(spec.logo_path).exists():
        try:
            img = XLImage(spec.logo_path)
            scale = min(1.0, 96.0 / max(img.height, 1))
            img.width, img.height = img.width * scale, img.height * scale
            ws.add_image(img, "A1")
        except Exception as e:
            # Most often a missing Pillow, which openpyxl needs to embed an image. The report is
            # still correct without the logo, so carry on — but say so rather than vanishing.
            LOG.warning("logo %r could not be placed in the report: %s", spec.logo_path, e)


def _table(ws, spec: ReportSpec, top: int):
    cols = spec.columns
    ws.cell(row=top, column=1, value="Specimen ID").font = BOLD
    ws.cell(row=top, column=1).fill = HEAD_FILL
    ws.cell(row=top, column=1).border = BORDER
    for j, f in enumerate(cols, start=2):
        c = ws.cell(row=top, column=j, value=f.label)
        c.font = BOLD
        c.fill = HEAD_FILL
        c.border = BORDER
        c.alignment = Alignment(wrap_text=True, horizontal="center", vertical="center")
    ws.row_dimensions[top].height = 44
    r0 = top + 1
    for i, row in enumerate(spec.rows):
        r = r0 + i
        ws.cell(row=r, column=1, value=row.get("specimen_id", f"{i + 1}")).border = BORDER
        for j, f in enumerate(cols, start=2):
            v = row.get(f.key)
            c = ws.cell(row=r, column=j, value=(None if v is None else float(v) if not isinstance(v, str) else v))
            c.border = BORDER
            c.number_format = ("0.00E+00" if f.fmt.upper().endswith("E") else ("0" if f.dp == 0 else "0." + "0" * f.dp))
            c.alignment = Alignment(horizontal="center")
    r_last = r0 + len(spec.rows) - 1
    if spec.stats and spec.rows:
        labels = ["Average", "Std Dev", "COV (%)"]
        for k, lab in enumerate(labels):
            r = r_last + 1 + k
            c = ws.cell(row=r, column=1, value=lab)
            c.font = BOLD
            c.fill = STAT_FILL
            c.border = BORDER
            for j, f in enumerate(cols, start=2):
                L = get_column_letter(j)
                rng = f"{L}{r0}:{L}{r_last}"
                if k == 0:
                    formula = f'=IFERROR(AVERAGE({rng}),"")'
                elif k == 1:
                    formula = f'=IFERROR(STDEV({rng}),"")'
                else:
                    formula = f'=IFERROR({L}{r_last + 2}/{L}{r_last + 1}*100,"")'
                c = ws.cell(row=r, column=j, value=formula)
                c.fill = STAT_FILL
                c.border = BORDER
                c.alignment = Alignment(horizontal="center")
                c.number_format = ("0.00E+00" if f.fmt.upper().endswith("E") else ("0.0" if k == 2 else ("0" if f.dp == 0 else "0." + "0" * f.dp)))
        r_last += 3
    ws.column_dimensions["A"].width = 16
    for j in range(2, len(cols) + 2):
        ws.column_dimensions[get_column_letter(j)].width = 14
    return r_last


def write_table_report(spec: ReportSpec, out: Path) -> Path:
    wb = Workbook()
    ws = wb.active
    ws.title = "Summary"
    ncols = len(spec.columns) + 1
    _header(ws, spec, title_col=max(5, ncols - 3), ncols=ncols)
    last = _table(ws, spec, top=6)
    r = last + 2
    if spec.passfail is not None:
        ws.cell(row=r, column=1, value=(spec.passfail_label or "Criteria")).font = BOLD
        ws.cell(row=r, column=2, value=spec.passfail)
        r += 1
    for n in spec.notes:
        ws.cell(row=r, column=1, value=n).font = Font(italic=True, color="666666")
        r += 1
    sd = _write_sample_data(wb, spec.curves, spec.x_label, spec.y_label)
    if spec.curves:
        ch = _scatter(spec.chart_title, spec.x_label, spec.y_label)
        for k, c in enumerate(spec.curves):
            col = 1 + 3 * k
            n = len(c.x)
            xref = Reference(sd, min_col=col, min_row=3, max_row=2 + n)
            yref = Reference(sd, min_col=col + 1, min_row=3, max_row=2 + n)
            name_cell = f"'Summary'!$A${7 + k}" if k < len(spec.rows) else None
            _add_series(ch, sd, name_cell, xref, yref, dashed=(c.style == "dashed"), marker=(c.style == "marker"))
        if spec.extra.get("log_x"):
            ch.x_axis.scaling.logBase = 10
        if spec.extra.get("log_y"):
            ch.y_axis.scaling.logBase = 10
        if spec.extra.get("x_range"):
            ch.x_axis.scaling.min, ch.x_axis.scaling.max = spec.extra["x_range"]
        if spec.extra.get("y_range"):
            ch.y_axis.scaling.min, ch.y_axis.scaling.max = spec.extra["y_range"]
        ws.add_chart(ch, f"A{r + 1}")
        second = spec.extra.get("second_chart")
        if second and second.get("curves"):
            sd2 = _write_sample_data(wb, second["curves"], second.get("x_label", ""), second.get("y_label", ""), "Chart 2 Data")
            ch2 = _scatter(second.get("title", ""), second.get("x_label", ""), second.get("y_label", ""))
            for k, c in enumerate(second["curves"]):
                col = 1 + 3 * k
                n = len(c.x)
                _add_series(ch2, sd2, None, Reference(sd2, min_col=col, min_row=3, max_row=2 + n),
                            Reference(sd2, min_col=col + 1, min_row=3, max_row=2 + n),
                            dashed=(c.style == "dashed"), marker=(c.style == "marker"))
            if second.get("log_x"):
                ch2.x_axis.scaling.logBase = 10
            ws.add_chart(ch2, f"L{r + 1}")
        r += 22
    ws.cell(row=r + 1, column=1, value=spec.footer).font = Font(italic=True, size=8, color="666666")
    for key, payload in spec.extra.get("sheets", {}).items():
        wsx = wb.create_sheet(key[:31])
        for i, row in enumerate(payload, 1):
            for j, v in enumerate(row, 1):
                wsx.cell(row=i, column=j, value=v)
    wb.save(str(out))
    return out


def write_hamburg_report(spec: ReportSpec, out: Path) -> Path:
    """Wheel rows (Left / Right) + averages, both wheels charted with fitted slope lines."""
    return write_table_report(spec, out)


def write_report(spec: ReportSpec, out: Path) -> Path:
    return write_table_report(spec, out)
