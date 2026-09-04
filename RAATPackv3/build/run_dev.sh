#!/usr/bin/env bash
# Development: backend on :8765 with reload, frontend dev server on :5173 (proxies /api).
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT/backend" && (python3 -m uvicorn raatpack.api.app:app --reload --port 8765 &) 
cd "$ROOT/frontend" && npm run dev
