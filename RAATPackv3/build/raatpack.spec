# -*- mode: python ; coding: utf-8 -*-
"""
PyInstaller spec for RAAT-Pack v3.  Written for PyInstaller 6.x.

Build (on Windows, from the repository):
    cd RAATPackv3/frontend && npm ci && npm run build
    cd ../backend && pip install -e ".[desktop]"
    cd ../build && pyinstaller --noconfirm --clean raatpack.spec
Produces build/dist/RAATPack/RAATPack.exe (one-folder; ship the whole folder).
"""
from pathlib import Path

from PyInstaller.utils.hooks import collect_all, collect_data_files, collect_submodules

ROOT = Path(SPECPATH).resolve().parent          # .../RAATPackv3
BACKEND = ROOT / "backend"
DIST_FE = ROOT / "frontend" / "dist"
SAMPLES = ROOT.parent / "Demo Data"             # the v2 demo set, shipped as sample data
ICON = ROOT / "build" / "icon.ico"

if not (DIST_FE / "index.html").exists():
    raise SystemExit(
        f"frontend/dist not found at {DIST_FE}.\n"
        "Build the interface first:  cd frontend && npm ci && npm run build"
    )

# --- data shipped inside the bundle -------------------------------------------------
# raatpack.config.settings.bundle_dir() resolves to sys._MEIPASS when frozen, and expects
# these paths relative to it.
datas = [
    (str(BACKEND / "data" / "templates"), "data/templates"),
    (str(DIST_FE), "frontend_dist"),
]

# The sample data behind the "Load sample data" button, laid out exactly as the repository
# holds it so raatpack.config.samples resolves the same folder names either way. The reference
# PDFs travel with it: they are what v2 produced from these inputs.
if SAMPLES.is_dir():
    datas.append((str(SAMPLES), "data/samples"))
else:
    print(f"WARNING: sample data not found at {SAMPLES}; "
          f"the Load sample data button will be disabled in this build.")
binaries = []
hiddenimports = collect_submodules("raatpack")

# uvicorn/starlette resolve these dynamically at runtime.
hiddenimports += [
    "uvicorn.logging", "uvicorn.loops", "uvicorn.loops.auto",
    "uvicorn.protocols", "uvicorn.protocols.http", "uvicorn.protocols.http.auto",
    "uvicorn.protocols.http.h11_impl", "uvicorn.protocols.websockets",
    "uvicorn.protocols.websockets.auto", "uvicorn.lifespan", "uvicorn.lifespan.on",
    "multipart", "multipart.multipart",
    "scipy.special._ufuncs_cxx", "scipy._lib.messagestream",
    "scipy.optimize", "scipy.stats",
    "matplotlib.backends.backend_pdf", "matplotlib.backends.backend_agg",
    "openpyxl.chart",
]

# pywebview ships JS assets and platform backends that are imported by name.
for pkg in ("webview",):
    d, b, h = collect_all(pkg)
    datas += d
    binaries += b
    hiddenimports += h
hiddenimports += [
    "webview.platforms.winforms",
    "webview.platforms.edgechromium",
    "clr", "clr_loader", "pythonnet",
]

datas += collect_data_files("matplotlib")

a = Analysis(
    [str(BACKEND / "raatpack" / "desktop.py")],
    pathex=[str(BACKEND)],
    binaries=binaries,
    datas=datas,
    hiddenimports=hiddenimports,
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=["tkinter", "PyQt5", "PyQt6", "PySide2", "PySide6", "IPython", "notebook", "pytest"],
    noarchive=False,
)

pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    [],
    exclude_binaries=True,
    name="RAATPack",
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=False,
    console=False,                 # no console window; see the log file in the data folder
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    icon=str(ICON) if ICON.exists() else None,
)

coll = COLLECT(
    exe,
    a.binaries,
    a.datas,
    strip=False,
    upx=False,
    upx_exclude=[],
    name="RAATPack",
)
