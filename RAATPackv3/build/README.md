# Building & running

## Development (any OS)
1. `cd backend && pip install -e ".[dev]"` — then `python -m uvicorn raatpack.api.app:app --reload --port 8765`
2. `cd frontend && npm install && npm run dev` — open http://localhost:5173

`build/run_dev.sh` / `build/run_dev.ps1` do both.

## Production desktop build (Windows)
`build/build_windows.ps1` builds the frontend, installs the backend + pywebview + PyInstaller into a venv,
and produces `build/dist/RAATPack/RAATPack.exe`. Requires Windows 10/11 (uses the Edge WebView2 runtime that
ships with Windows). Distribute the whole `dist/RAATPack` folder, or wrap it with Inno Setup for an installer.

## Running the server without a window (e.g. on a shared lab PC or later a web host)
`python -m raatpack.desktop --no-window` prints the URL; or `uvicorn raatpack.api.app:app --host 0.0.0.0 --port 8765`.

## Tests
`cd backend && pytest` — the golden-value suite reads `RAATdev/Demo Data` and asserts against the v2 demo reports.
