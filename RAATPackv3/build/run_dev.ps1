$root = Split-Path -Parent $PSScriptRoot
Start-Process powershell -ArgumentList "-NoExit","-Command","cd '$root\backend'; python -m uvicorn raatpack.api.app:app --reload --port 8765"
Set-Location "$root\frontend"; npm run dev
