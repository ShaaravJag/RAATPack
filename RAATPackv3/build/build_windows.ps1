# Build RAATPack.exe on Windows.  Prerequisites: Python 3.11+ on PATH, Node 18+ on PATH.
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
Push-Location "$root\frontend"
if (!(Test-Path node_modules)) { npm install }
npm run build
Pop-Location
Push-Location "$root\backend"
if (!(Test-Path .venv)) { python -m venv .venv }
.\.venv\Scripts\Activate.ps1
pip install --upgrade pip | Out-Null
pip install -e ".[desktop]"
Pop-Location
Push-Location "$root\build"
pyinstaller --noconfirm --clean raatpack.spec
Pop-Location
Write-Host ""
Write-Host "Built: $root\build\dist\RAATPack\RAATPack.exe"
Write-Host "Ship the whole dist\RAATPack folder (or wrap it with Inno Setup / NSIS for an installer)."
