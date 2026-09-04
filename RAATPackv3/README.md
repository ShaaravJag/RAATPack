# RAAT-Pack v3

Rutgers Asphalt Analysis Tool-Pack, rebuilt. A faithful port of the v2 MATLAB kernels
(bug-for-bug — see *Faithfulness notes*) with a modern UI, native Excel/PDF reports, and no
MATLAB Runtime or Excel dependency.

```
backend/   Python 3.8+ — analysis engine (NumPy/SciPy), FastAPI server, report writers, golden tests
frontend/  React + TypeScript + Vite — the UI
build/     PyInstaller spec + scripts for the Windows .exe
```

## Run it (development)

```bash
cd backend
python -m pip install -e ".[dev]"
python -m pytest                                      # 11 golden-value tests against the v2 demo reports
python -m uvicorn raatpack.api.app:app --port 8765    # API (+ the built UI, if frontend/dist exists)
```
```bash
cd frontend
npm install
npm run dev                                           # http://localhost:5173  (proxies /api to :8765)
```
Or build the UI once (`npm run build`) and open http://127.0.0.1:8765 straight from the backend.

## Build the Windows .exe

On a Windows 10/11 machine with Python 3.11+ and Node 18+:
```powershell
.\build\build_windows.ps1        # -> build\dist\RAATPack\RAATPack.exe
```
The app opens in a native window (Edge WebView2, already part of Windows). No MATLAB Runtime, no Excel.
Ship the whole `dist\RAATPack` folder, or wrap it with Inno Setup.

## Using it

1. **Settings** — institution name and logo (they go on every report), COV warning threshold.
2. **File templates** — a template says where the data lives in a machine's output file
   (columns, first data row, sign/offset corrections, units). The lab's v2 template library is built in,
   plus templates for the MTS TWSX exports the demo data came from. Create your own with the
   sample-file preview, or import a v2 template workbook unchanged.
3. Open a module: enter project info → pick a template → drop files → fill the specimen table
   (required dimensions are starred) → **Run** → results, charts, statistics → **Export** (Excel, PDF, CSV, PNG).
4. **Sessions** — *Save session* writes a JSON you can reload later to reproduce a run exactly
   (including any manual picks and trims).

### Demo data (RAATdev/Demo Data) → which template

| Module | Files | Template | Dimensions used in the v2 demo report |
|---|---|---|---|
| IDEAL-CT | `IDEALCT Demo File 1-3.xlsx` | MTS TWSX (stroke mm, load kN) | t 62, D 150 |
| SCB | `SCB Demo File 1-4.xlsx` | MTS TWSX (stroke **m**, load kN) | t 50, ligament 58 |
| Cold SCB | `Cold SCB Demo File 4-6.xlsx` (report rows 1-3) | MTS TWSX 4-channel (stroke m, load N) | t 25, r 75, notch 15 |
| DCT | `DCT Demo File 1, 3, 4.xlsx` | MTS TWSX 4-channel (stroke mm, load kN) | D 150, t 50, ligament 83 |
| HT-IDT | `HTIDT Demo File 1-3.csv` | SmartJIG to RAAT | t 150, D 150 (as typed in the demo) |
| Bond Strength | `Bond Strength Demo File 1-3.xlsx` | MTS TWSX (stroke mm, load kN) | — |
| APA | `APA, 2% AV BRIC.xlsx` | none (IPC Global workbook) | — |
| Hamburg | `HAM Demo File 1.xlsx` | none (IPC Global workbook) | — |
| Beam | `Beam_RR_Berger_#7.csv` | Default - Beam | — |
| Dynamic Modulus | `Winslow/*.csv` | none (AMPT Sum.csv) | target 4/20/45 °C, ref 20 °C |

### Manual steps that v2 also had

* **SCB** — if no inflection point is found automatically (v2's "Please select inflection point"), the
  specimen is flagged; select it, click *Pick inflection point*, click the chart. *Trim beginning* is v2's
  "Trim Beginning?" prompt. The end is always trimmed at 0.1 kN.
* **Hamburg** — v2's "Are the slopes okay?" → *No* → click stripping point, click creep point. Same here,
  per wheel. In the manual path v2 reports max rut as the measured maximum (reproduced).
* **Cold SCB** — export asks whether to include the interpolated tails (all / none / selected), as v2 did.

## Where the equations live

`backend/raatpack/equations/` — one file per test. Every constant is a named constant at the top of the
file; every reported quantity is computed in a marked block; `RESULT_FIELDS` lists what the tables and
reports show (add a field there and to the result dataclass and it appears everywhere). The golden tests in
`backend/tests/` assert every value against the v2 demo reports, so an accidental change fails loudly.

`backend/raatpack/numerics/matlab.py` holds the MATLAB-behaviour equivalents (polyfit, roots/isreal,
fminbnd, fzero, fmincon-with-bounds, `fit('power1')`, robust LAR `fit('exp1')`, Excel AVERAGE/STDEV).

## Faithfulness notes

v2 behaviours reproduced on purpose. Do not "fix" without an engineering decision — every published
v2 number depends on them:

* **Cold SCB tail** — the power-law exponent is bounded *above* by −2, not pinned to −2 (v2's second
  `fitoptions` call overwrote the first). Pinning it changes fracture energy by 3–10 %.
* **Hamburg max rut** — the 6th-order polynomial evaluated at exactly 20,000 passes even when the test
  stopped earlier. The chart shades the extrapolated region.
* **Hamburg wheel truncation** — `num(3:lidx,·)` uses a relative index as an absolute row, dropping the
  last two data points of each wheel.
* **Cold SCB / DCT transform flags** — the template rows labelled Time/Stroke/COD/Load are applied to
  COD/Load/Time/Stroke respectively; units rows 26/27 are read as Load/COD.
* **SCB inflection search** — the acceptance window's right edge is the point nearest j·10 % of peak
  searched over the *whole* curve (pre-peak included); the polynomial is never refit after a manual pick.
* **Beam** — AASHTO fit is least-absolute-residuals (MATLAB `Robust: 'LAR'`); the ASTM trendline drops the
  constant term in the export, as v2 did. Nf50 (AASHTO) agrees with v2 to 0.03 %.
* **Dynamic modulus** — EA is held at 2×10⁵ by the bounds; VTS viscosity uses v2's cap/un-scale quirk;
  target temperatures are rounded to whole °F.

Verified against the v2 demo reports: IDEAL-CT, Cold SCB, Hamburg (SIP to the digit), SCB, HT-IDT, DCT,
APA — exact to the report's printed precision; Beam AASHTO Nf50 0.03 %; DM EA grid 0.01 % given the same E*max.
