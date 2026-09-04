"""
PDF summary reports rendered with matplotlib — one landscape page laid out like the v2
Excel summary: logo + standard title, project block, results table with Average / Std Dev /
COV, the chart, and the RAAT-Pack footer. Pure Python; bundles cleanly into the .exe.
"""
from __future__ import annotations

import math
from pathlib import Path
from typing import List, Optional

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.backends.backend_pdf import PdfPages
import numpy as np

from ..numerics.matlab import excel_stats
from .spec import ReportSpec, fmt_value

PALETTE = ["#1f4e79", "#c00000", "#2e7d32", "#ed7d31", "#7030a0", "#00838f", "#8d6e63", "#455a64",
           "#c2185b", "#5d4037", "#0288d1", "#689f38"]


def _wrap(label: str, width: int = 14) -> str:
    """Break long column labels onto two lines so headers don't collide."""
    if len(label) <= width:
        return label
    words = label.split()
    lines, cur = [], ""
    for w in words:
        if cur and len(cur) + 1 + len(w) > width:
            lines.append(cur)
            cur = w
        else:
            cur = (cur + " " + w).strip()
    if cur:
        lines.append(cur)
    return "\n".join(lines[:3])


def _table_rows(spec: ReportSpec):
    head = ["Specimen ID"] + [_wrap(f.label) for f in spec.columns]
    body = []
    for i, row in enumerate(spec.rows):
        body.append([str(row.get("specimen_id", i + 1))] + [fmt_value(row.get(f.key), f) for f in spec.columns])
    if spec.stats and spec.rows:
        stat_rows = [["Average"], ["Std Dev"], ["COV (%)"]]
        for f in spec.columns:
            vals = [row.get(f.key) for row in spec.rows]
            vals = [v for v in vals if not isinstance(v, str)]
            mean, std, cov = excel_stats(vals)
            stat_rows[0].append("" if mean is None else fmt_value(mean, f))
            stat_rows[1].append("" if std is None else fmt_value(std, f))
            stat_rows[2].append("" if cov is None else f"{cov:.1f}")
        body += stat_rows
    return head, body


def _draw_chart(ax, spec: ReportSpec):
    ax.set_title(spec.chart_title, fontsize=10, fontweight="bold")
    ax.set_xlabel(spec.x_label, fontsize=8)
    ax.set_ylabel(spec.y_label, fontsize=8)
    ax.tick_params(labelsize=7)
    ax.grid(True, alpha=.3)
    for k, c in enumerate(spec.curves):
        col = c.color or PALETTE[k % len(PALETTE)]
        if c.style == "marker":
            ax.plot(c.x, c.y, "o", ms=3, color=col, label=c.name)
        elif c.style == "dashed":
            ax.plot(c.x, c.y, "--", lw=1, color=col, label=c.name)
        else:
            ax.plot(c.x, c.y, "-", lw=1.4, color=col, label=c.name)
    if spec.extra.get("log_x"):
        ax.set_xscale("log")
    if spec.extra.get("log_y"):
        ax.set_yscale("log")
    if spec.extra.get("y_min") is not None:
        ax.set_ylim(bottom=spec.extra["y_min"])
    if spec.extra.get("x_min") is not None:
        ax.set_xlim(left=spec.extra["x_min"])
    if spec.extra.get("x_range"):
        ax.set_xlim(*spec.extra["x_range"])
    if spec.extra.get("y_range"):
        ax.set_ylim(*spec.extra["y_range"])
    if spec.curves:
        ax.legend(fontsize=7, loc="best", ncol=2 if len(spec.curves) > 6 else 1)


PAGINATE_ROWS = 12   # more table rows than this -> table on its own page (v2's E* report was two pages)


def _header(fig, spec: ReportSpec):
    if spec.logo_path and Path(spec.logo_path).exists():
        try:
            img = plt.imread(str(spec.logo_path))
            axl = fig.add_axes([0.04, 0.88, 0.14, 0.09])
            axl.imshow(img)
            axl.axis("off")
        except Exception:
            pass
    fig.text(0.5, 0.965, spec.title, ha="center", va="top", fontsize=10.5, fontweight="bold", wrap=True)
    p = spec.project
    left = [("Project Name:", p.get("project", "")), ("Mix Type:", p.get("mix_type", "")),
            ("Test Temperature:", p.get("test_temp", ""))]
    right = [("Institution:", p.get("institution", "")), ("Date Tested:", p.get("date", "")),
             ("Technician:", p.get("technician", ""))]
    for i, ((la, va), (lb, vb)) in enumerate(zip(left, right)):
        yy = 0.86 - i * 0.028
        fig.text(0.20, yy, la, fontsize=8, fontweight="bold")
        fig.text(0.31, yy, str(va), fontsize=8)
        fig.text(0.58, yy, lb, fontsize=8, fontweight="bold")
        fig.text(0.68, yy, str(vb), fontsize=8)
    fig.text(0.5, 0.02, spec.footer, ha="center", fontsize=7, style="italic", color="#555555")


def _table(fig, spec: ReportSpec, top: float, max_h: float) -> float:
    """Draw the results table starting at `top`; return the y where content may continue."""
    head, body = _table_rows(spec)
    if not body:
        return top
    n_rows = len(body) + 1
    row_h = 0.0245
    table_h = min(max_h, row_h * n_rows + 0.05)
    axt = fig.add_axes([0.04, top - table_h, 0.92, table_h])
    axt.axis("off")
    tbl = axt.table(cellText=body, colLabels=head, loc="upper center", cellLoc="center")
    tbl.auto_set_font_size(False)
    tbl.set_fontsize(6.6)
    tbl.scale(1, 1.22)
    for (r, c), cell in tbl.get_celld().items():
        cell.set_edgecolor("#999999")
        if r == 0:
            cell.set_facecolor("#D9E1F2")
            cell.set_text_props(fontweight="bold")
            cell.set_height(cell.get_height() * 2.2)
        elif spec.stats and r > len(spec.rows):
            cell.set_facecolor("#F2F2F2")
            if c == 0:
                cell.set_text_props(fontweight="bold")
    return top - table_h - 0.02


def _notes(fig, spec: ReportSpec, y: float) -> float:
    if spec.passfail is not None:
        fig.text(0.04, y, f"{spec.passfail_label or 'Criteria'}: {spec.passfail}", fontsize=8)
        y -= 0.022
    for n in spec.notes:
        fig.text(0.04, y, n, fontsize=7.5, style="italic", color="#444444")
        y -= 0.02
    return y


def _charts(fig, spec: ReportSpec, top: float):
    ch_h = max(0.22, top - 0.09)
    second = spec.extra.get("second_chart")
    if second:
        axc = fig.add_axes([0.07, 0.075, 0.40, ch_h])
        _draw_chart(axc, spec)
        ax2 = fig.add_axes([0.57, 0.075, 0.40, ch_h])
        s2 = ReportSpec(spec.module_id, spec.layout, "", second.get("title", ""), second.get("x_label", ""),
                        second.get("y_label", ""), {}, [], [], second.get("curves", []),
                        extra={"log_x": second.get("log_x", False), "log_y": second.get("log_y", False)})
        _draw_chart(ax2, s2)
    else:
        axc = fig.add_axes([0.10, 0.075, 0.80, ch_h])
        _draw_chart(axc, spec)


def render_pdf(spec: ReportSpec, out: Path, chart_png: Optional[Path] = None) -> Path:
    head, body = _table_rows(spec)
    paginate = len(body) > PAGINATE_ROWS
    with PdfPages(str(out)) as pdf:
        if not paginate:
            fig = plt.figure(figsize=(11, 8.5))
            _header(fig, spec)
            y = _table(fig, spec, top=0.76, max_h=0.36)
            y = _notes(fig, spec, y)
            _charts(fig, spec, top=y - 0.01)
            pdf.savefig(fig)
            plt.close(fig)
        else:
            fig = plt.figure(figsize=(11, 8.5))
            _header(fig, spec)
            y = _notes(fig, spec, 0.76)
            _charts(fig, spec, top=y - 0.01)
            pdf.savefig(fig)
            plt.close(fig)
            fig = plt.figure(figsize=(11, 8.5))
            _header(fig, spec)
            _table(fig, spec, top=0.76, max_h=0.70)
            pdf.savefig(fig)
            plt.close(fig)
    if chart_png:
        render_chart_png(spec, chart_png)
    return out


def render_chart_png(spec: ReportSpec, out: Path, dpi: int = 200) -> Path:
    fig, ax = plt.subplots(figsize=(8, 5), dpi=dpi)
    _draw_chart(ax, spec)
    fig.tight_layout()
    fig.savefig(str(out))
    plt.close(fig)
    return out
