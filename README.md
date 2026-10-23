# RAAT-Pack — Rutgers Asphalt Analysis Tool-Pack

Analysis software for ten asphalt performance tests, developed at the
**Rutgers Asphalt Pavement Laboratory** (CAIT, Rutgers University).

A technician runs a specimen on a load frame or wheel tracker; the machine writes a raw file;
RAAT-Pack turns that curve into the numbers a specification actually asks for — CT Index, Flexibility
Index, fracture energy, stripping inflection point, dynamic modulus master curves — and produces a
formatted summary report.

This repository holds **Version 3**, a rewrite of the original MATLAB tool-pack, together with the
Version 2 source it was ported from and the demo data used to verify the port.

| | |
|---|---|
| **Modules** | APA · Beam Fatigue · Bond Strength · Cold SCB · DCT · Dynamic Modulus · Hamburg · HT-IDT · IDEAL-CT · Intermediate SCB |
| **Stack** | Python 3.8+ (NumPy/SciPy/FastAPI) · React + TypeScript · packaged with PyInstaller + pywebview (Windows `.exe`, macOS `.app`) |
| **Requires** | No MATLAB Runtime. No Excel. |
| **Status** | All ten modules ported and verified against the Version 2 reports. Desktop `.exe` build script written, not yet built. |

---

## Quick start

```bash
# 1. Analysis engine
cd RAATPackv3/backend
python -m venv .venv
source .venv/bin/activate            # Windows: .venv\Scripts\activate
pip install -e ".[dev]"
python -m pytest                     # 11 golden-value tests — should pass

# 2. User interface (once; the backend then serves it)
cd ../frontend
npm install
npm run build

# 3. Run
cd ../backend
python -m uvicorn raatpack.api.app:app --port 8765
```

Open **http://127.0.0.1:8765**.

If you are changing the interface, run `npm run dev` in `frontend/` instead (port 5173, proxies to the
backend) so edits reload live.

---

## Distributing to the lab

**You do not need a Windows machine.** GitHub Actions builds, tests and publishes the Windows
application for you.

```bash
git tag v3.0.0
git push origin v3.0.0
```

That triggers `.github/workflows/release.yml`, which on a Windows runner:

1. builds the interface,
2. runs the golden-value suite **on Windows**,
3. packages `RAATPack.exe` with PyInstaller,
4. **launches the packaged app headless and checks it answers** — 10 modules, 23 templates, UI on
   HTTP 200 — failing the build if it does not,
5. zips the app together with the manual and `READ ME FIRST.txt`,
6. publishes a GitHub Release with that zip attached.

Send the team the Releases link. The repository is public, so nobody needs a GitHub account to
download it. They unzip, double-click `RAATPack.exe`, and that is the whole install — no MATLAB
Runtime, no Excel, no Python.

To test the pipeline without publishing anything, run the workflow manually from the **Actions** tab
with *Publish* left unchecked; the zip is attached to the run instead of a Release.

### Building it yourself instead

On Windows with Python 3.11+ and Node 18+:

```powershell
.\RAATPackv3\build\build_windows.ps1     # -> build\dist\RAATPack\RAATPack.exe
```

Ship the whole `dist\RAATPack` folder. It uses the Edge WebView2 runtime already present on
Windows 10/11 — nothing else to install.

### A Mac build, for demonstrating

On a Mac with Python 3.11+ and Node 18+:

```bash
cd RAATPackv3/backend && pip install -e ".[desktop]"
cd ../build && ./build_mac.sh            # -> build/dist/RAATPack.app
```

`build_mac.sh` checks its prerequisites first, builds the interface, generates the icon, freezes
the app, and then smoke-tests the frozen bundle — it loads the sample data, runs an analysis and
exports all four formats from inside the `.app`, which is where missing hidden imports actually
surface.

The app is **not signed or notarised**, so the first launch on another Mac needs right-click →
**Open** once to get past Gatekeeper. It is meant for demonstrating the toolpack; the lab's own
copies are the Windows build above.

---

## Repository layout

```
RAATPackv3/                  Version 3 — the current software
  backend/
    raatpack/
      equations/             ← THE MATHS. One file per test.
      numerics/matlab.py     MATLAB-equivalent numerics (polyfit, fmincon, fzero, robust fits…)
      io/                    file readers, template system, AMPT/IPC parsers
      reports/               Excel (openpyxl) and PDF (matplotlib) writers
      api/                   FastAPI routes and session state
      modules/registry.py    per-module presentation metadata
      config/settings.py     on-disk paths and user settings
      desktop.py             packaged-app launcher (native window, browser fallback, file logging)
    data/templates/          23 built-in file templates (the lab's v2 library)
    tests/                   golden-value regression suite + fixtures
  frontend/src/              React + TypeScript interface
  build/                     PyInstaller specs (Windows, macOS), build scripts, icon generator

Demo Data/                   Machine files + the Version 2 report each produced (12 MB)
RAAT Configs/                The lab's original machine templates
Instructions/                User manual (PDF + editable HTML source)
RAATPack_v2/                 Version 2 MATLAB source, kept as the reference implementation
```

---

## Where the equations live

Everything that produces a number is in **`RAATPackv3/backend/raatpack/equations/`** — one file per
test. Each file names its constants at the top and computes the reported quantities in a single marked
block, so a formula can be found and changed without reading the rest of the program:

```python
SLOPE_WINDOW_UPPER_FRAC = 0.85   # post-peak slope window, upper bound
SLOPE_WINDOW_LOWER_FRAC = 0.65   # post-peak slope window, lower bound
DISPLACEMENT_FRAC       = 0.75   # L is read at this fraction of peak load
REFERENCE_THICKNESS_MM  = 62.0   # ASTM D8225 normalising thickness

# ---- reported quantities -------------------------------------------------
Gf       = U / (thickness_mm * diameter_mm) * MM2_TO_M2
CT_index = Gf_S * L_D * thickness_mm / REFERENCE_THICKNESS_MM
```

To add a value to a report: add it to that block, to the module's `RESULT_FIELDS`, and to its result
record. The tables, charts and every export format pick it up from there.

---

## Verification — read this before changing a formula

Version 3 is a **re-implementation, not a re-derivation**. Every equation was ported from the Version 2
MATLAB and checked against the summary reports Version 2 produced from the demo specimens in
`Demo Data/`.

```bash
cd RAATPackv3/backend && python -m pytest
```

Eleven tests run all ten modules and assert against the published numbers. Change a formula and break a
value, and the test names the module and the quantity that moved. **Run it after any edit to
`equations/`.**

| Module | Agreement with the Version 2 report |
|---|---|
| IDEAL-CT, Cold SCB, Hamburg, HT-IDT, DCT, APA | Exact to the precision the reports print (Hamburg SIP 16197 to the digit) |
| Intermediate SCB | Exact on 3 of 4 demo specimens; within 0.4 % on the fourth |
| Beam Fatigue | ASTM results exact; AASHTO n<sub>f,50</sub> within 0.03 % |
| Dynamic Modulus | Master curve within 0.01 % given the same E\*max |
| Bond Strength | **No Version 2 demo report exists** — checked by hand against the MATLAB, not machine-verified |

### Version 2 behaviours reproduced on purpose

These affect reported values. They were kept deliberately so results stay comparable with the
laboratory's historical data. **Changing any of them is an engineering decision, not a bug fix.**

- **Cold SCB tail** — the power-law exponent is bounded *above* by −2 rather than fixed at −2 (the
  original's second `fitoptions` call discarded the lower bound). Pinning it changes fracture energy by
  3–10 %.
- **Hamburg rut** — reported as the fitted polynomial at exactly 20 000 passes even when the test ended
  earlier. Version 3 shades the extrapolated region rather than hiding it.
- **Hamburg wheels** — the last two points of each wheel are dropped, a consequence of the original's
  indexing.
- **Cold SCB / DCT templates** — the correction rows labelled Time/Stroke/COD/Load are applied to
  COD/Load/Time/Stroke respectively; the unit rows are read in that same order.
- **Intermediate SCB** — the inflection search window is measured over the whole curve, and the
  polynomial is not refitted after a manual pick.
- **Beam Fatigue** — the AASHTO fit minimises absolute residuals (MATLAB's `Robust: 'LAR'`); the
  exported ASTM trendline omits its constant term.
- **Dynamic Modulus** — activation energy is held at 2×10⁵ by the fitting bounds; target temperatures
  are rounded to whole °F before shifting.

---

## Documentation

- **`Instructions/RAATPack v3 Instructions.pdf`** — 40-page user manual: the shared workflow, file
  templates, charts, statistics, exports, a section per module, troubleshooting.
- **`Instructions/RAATPack v3 Instructions (editable source).html`** — the same document, self-contained.
  Edit the text and use the browser's *Print → Save as PDF* to regenerate.
- **`Instructions/FIle Input Examples.xlsx`** — what each `Default – …` template expects, one sheet per test.

The Version 2 instruction **videos** are not in this repository (284 MB). They still describe the same
tests and the same underlying calculations, but show the old interface.

---

## Demo data

`Demo Data/` holds the machine files together with the summary report Version 2 produced from them —
input and expected output side by side. It is committed so `pytest` works on a fresh clone and in CI.

Which template to use for each set is in Appendix A of the manual. Two are easy to get wrong:

- **Cold SCB** — the report was made from demo files **4, 5, 6**, not 1–3.
- **DCT** — from demo files **1, 3, 4** (1 and 4 are the same test).

---

## Contributing

1. Branch from `main`.
2. Run `python -m pytest` in `RAATPackv3/backend` before pushing — CI runs it on 3.9 and 3.12.
3. If you touched the interface, run `npx tsc --noEmit && npm run build` in `RAATPackv3/frontend`.
4. If a golden value legitimately changes, say so in the pull request and explain why — do not adjust
   the fixture to make a test pass.

---

## Credits

Original Rutgers Asphalt Analysis Tool-Pack (Version 2, MATLAB): **Thomas Bennert, Ed Haas,
Benjamin Berger, Marissa Berger** — Rutgers Asphalt Pavement Laboratory, Center for Advanced
Infrastructure and Transportation, Rutgers University, New Jersey.

## Licence

Not yet set. **Confirm with Rutgers/CAIT before adding one** — a university research tool may be
subject to institutional IP policy. Until a `LICENSE` file exists, GitHub treats this repository as
all rights reserved, which is the safe default.
