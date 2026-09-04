# -*- mode: python ; coding: utf-8 -*-
# PyInstaller spec for RAAT-Pack v3 (run on Windows from the build/ folder)
import os, sys
from pathlib import Path
ROOT = Path(SPECPATH).resolve().parent
BACKEND = ROOT / "backend"
DIST_FE = ROOT / "frontend" / "dist"
assert DIST_FE.exists(), "frontend/dist not found — run `npm run build` in frontend/ first"

block_cipher = None
hidden = ["uvicorn.logging", "uvicorn.loops", "uvicorn.loops.auto", "uvicorn.protocols", "uvicorn.protocols.http",
          "uvicorn.protocols.http.auto", "uvicorn.protocols.websockets", "uvicorn.protocols.websockets.auto",
          "uvicorn.lifespan", "uvicorn.lifespan.on", "multipart", "scipy.special._ufuncs_cxx", "scipy._lib.messagestream",
          "matplotlib.backends.backend_pdf", "matplotlib.backends.backend_agg", "openpyxl.chart", "raatpack.api.routes_core",
          "raatpack.api.routes_ws", "raatpack.api.routes_dm", "webview.platforms.winforms", "webview.platforms.edgechromium"]

a = Analysis([str(BACKEND / "raatpack" / "desktop.py")], pathex=[str(BACKEND)], binaries=[],
             datas=[(str(BACKEND / "data" / "templates"), "data/templates"), (str(DIST_FE), "frontend_dist")],
             hiddenimports=hidden, hookspath=[], runtime_hooks=[], excludes=["tkinter", "PyQt5", "PySide2", "IPython", "notebook"],
             cipher=block_cipher, noarchive=False)
pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)
exe = EXE(pyz, a.scripts, [], exclude_binaries=True, name="RAATPack", debug=False, bootloader_ignore_signals=False,
          strip=False, upx=False, console=False, icon=str(ROOT / "build" / "icon.ico") if (ROOT / "build" / "icon.ico").exists() else None)
coll = COLLECT(exe, a.binaries, a.zipfiles, a.datas, strip=False, upx=False, name="RAATPack")
