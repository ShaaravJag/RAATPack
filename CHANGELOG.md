# Changelog

## 3.0.0 — 2026-09-04

Complete rewrite of the Version 2 MATLAB tool-pack. **The calculations are unchanged** — every equation
was ported from the original and verified against the Version 2 summary reports (see README).

### Removed dependencies
- MATLAB Compiler Runtime 9.4 is no longer needed.
- Microsoft Excel is no longer needed. Version 2 drove an installed copy of Excel over COM to build
  every report; Version 3 writes the workbook directly.

### Added
- Single-window interface; all ten modules share the same five-step layout.
- Construction overlays — the 85 %–65 % IDEAL-CT slope window, the SCB tangent at the inflection point,
  the Cold SCB extrapolated tail, the Hamburg creep and stripping lines — drawn on the curve.
- Extrapolation is flagged: the Hamburg 20 000-pass region is shaded and the results row is marked.
- Statistics panel: dot plots of the existing mean/std/COV, with the replicate driving a high COV
  highlighted. A configurable COV warning threshold (display only).
- Data inspector showing the points the analysis used, after template transforms.
- Sessions — save a run, including manual picks, and reload it to reproduce the numbers.
- Template editor with live preview against a sample file; import/export of Version 2 template workbooks.
- Export to PDF, CSV and PNG in addition to Excel.
- Golden-value regression suite (`pytest`) covering all ten modules.

### Changed
- No limit on specimens per report (Version 2 capped at 12 and shipped 24 prebuilt workbooks per module).
- One report layout with a configurable institution name and logo, replacing the separate `_RU` variant
  and its hardcoded login.
- Manual steps (SCB inflection point, SCB begin-trim, Hamburg slopes) are now made on the chart, where
  the effect is visible, and can be changed or reverted afterwards — Version 2 asked in modal dialogs
  mid-analysis.
- Legacy binary `.xls` input is no longer read; save as `.xlsx` or `.csv`.

### Fixed
- Reports no longer leak `#DIV/0!` and `######` into blank or narrow cells.
- A file that fails to parse no longer aborts the whole run; it is flagged on its own row.

### Deliberately not fixed
Seven Version 2 behaviours that affect reported values are reproduced exactly so historical results stay
comparable. They are listed in the README and in Appendix B of the manual.
