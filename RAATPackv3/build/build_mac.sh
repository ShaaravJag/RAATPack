#!/usr/bin/env bash
# Build RAATPack.app — a double-clickable macOS application.
#
#   cd RAATPackv3/build && ./build_mac.sh
#
# The result is build/dist/RAATPack.app. It is not signed or notarised, so the first launch
# needs right-click → Open (once) to get past Gatekeeper.
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
FRONTEND="$ROOT/frontend"
BACKEND="$ROOT/backend"

say()  { printf '\n\033[1m==> %s\033[0m\n' "$*"; }
die()  { printf '\n\033[31merror: %s\033[0m\n' "$*" >&2; exit 1; }

[ "$(uname -s)" = "Darwin" ] || die "this builds a macOS .app and must run on a Mac (use raatpack.spec for Windows)."

# Prefer the project's virtualenv if there is one, so the build uses the same interpreter and
# package versions the tests ran against.
PY="${PYTHON:-}"
if [ -z "$PY" ]; then
  for c in "$ROOT/../.venv/bin/python" "$ROOT/.venv/bin/python" "$(command -v python3 || true)"; do
    [ -x "$c" ] && { PY="$c"; break; }
  done
fi
[ -n "$PY" ] || die "no Python found. Set PYTHON=/path/to/python and try again."

say "Checking prerequisites"
echo "    python      : $PY ($("$PY" -V 2>&1))"
command -v npm >/dev/null || die "npm not found. Install Node 18+ (https://nodejs.org) and try again."
echo "    node        : $(node -v 2>/dev/null || echo '?')  npm $(npm -v 2>/dev/null || echo '?')"

missing=""
"$PY" -c "import PyInstaller" 2>/dev/null || missing="$missing pyinstaller"
"$PY" -c "import webview"     2>/dev/null || missing="$missing pywebview"
"$PY" -c "import raatpack"    2>/dev/null || missing="$missing the raatpack package itself"
if [ -n "$missing" ]; then
  die "missing:$missing

Install the desktop extras into that interpreter:
    cd \"$BACKEND\" && \"$PY\" -m pip install -e \".[desktop]\""
fi
echo "    pyinstaller : $("$PY" -c 'import importlib.metadata as m; print(m.version("pyinstaller"))')"
echo "    pywebview   : $("$PY" -c 'import importlib.metadata as m; print(m.version("pywebview"))')"
"$PY" -c "import objc" 2>/dev/null \
  && echo "    pyobjc      : present" \
  || echo "    pyobjc      : MISSING — the app will fall back to opening a browser window"

say "Building the interface"
cd "$FRONTEND"
[ -d node_modules ] || npm ci
npm run build
[ -f dist/index.html ] || die "the frontend build produced no dist/index.html."

say "Generating the icon"
"$PY" "$HERE/make_icon.py"

say "Freezing the application"
cd "$HERE"
rm -rf build dist
"$PY" -m PyInstaller --noconfirm --clean raatpack_mac.spec

APP="$HERE/dist/RAATPack.app"
[ -d "$APP" ] || die "PyInstaller finished but $APP is missing."

say "Checking the bundle"
for p in "Contents/MacOS/RAATPack" "Contents/Resources/data/templates" "Contents/Resources/frontend_dist/index.html"; do
  [ -e "$APP/$p" ] || die "the bundle is missing $p"
  echo "    ok  $p"
done
if [ -e "$APP/Contents/Resources/data/samples" ]; then
  echo "    ok  Contents/Resources/data/samples ($(find "$APP/Contents/Resources/data/samples" -type f | wc -l | tr -d ' ') files)"
else
  echo "    !!  no sample data in the bundle — the Load sample data button will be hidden"
fi

# Smoke test: start the frozen binary headless and make sure the engine actually answers.
# This is where hidden-import failures surface, and they do not surface any earlier.
say "Smoke-testing the frozen app"
PORT=8911
"$APP/Contents/MacOS/RAATPack" --no-window --port "$PORT" >/tmp/raatpack-smoke.out 2>/tmp/raatpack-smoke.err &
SMOKE=$!
trap 'kill $SMOKE 2>/dev/null || true' EXIT
for _ in $(seq 1 120); do
  curl -fsS "http://127.0.0.1:$PORT/api/modules" >/dev/null 2>&1 && break
  sleep 0.5
done
MODULES=$(curl -fsS "http://127.0.0.1:$PORT/api/modules" | "$PY" -c 'import json,sys; print(len(json.load(sys.stdin)))' 2>/dev/null || echo 0)
[ "$MODULES" = "10" ] || { sed -n '1,40p' /tmp/raatpack-smoke.err >&2; die "the frozen app served $MODULES modules, expected 10."; }
echo "    ok  10 modules"
curl -fsS -X POST "http://127.0.0.1:$PORT/api/ws/scb/samples" >/dev/null && echo "    ok  sample data loads"
curl -fsS -X POST "http://127.0.0.1:$PORT/api/ws/scb/run"     >/dev/null && echo "    ok  analysis runs"
IDS=$(curl -fsS "http://127.0.0.1:$PORT/api/ws/scb" | "$PY" -c 'import json,sys; print(json.dumps([f["id"] for f in json.load(sys.stdin)["files"]]))')
for FMT in xlsx pdf csv png; do
  OUT="/tmp/raatpack-smoke.$FMT"
  curl -fsS -o "$OUT" -X POST "http://127.0.0.1:$PORT/api/ws/scb/export" \
    -H 'Content-Type: application/json' \
    -d "{\"format\":\"$FMT\",\"file_ids\":$IDS,\"options\":{}}" \
    && echo "    ok  export $FMT ($(wc -c < "$OUT" | tr -d ' ') bytes)" \
    || die "export $FMT failed in the frozen app — check /tmp/raatpack-smoke.err"
done
kill $SMOKE 2>/dev/null || true
trap - EXIT

say "Done"
echo "    $APP"
echo "    $(du -sh "$APP" | cut -f1) on disk"
echo
echo "    Open it from Finder. The first launch on another Mac needs right-click → Open,"
echo "    once, because the app is not signed."
