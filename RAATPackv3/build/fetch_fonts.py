#!/usr/bin/env python3
"""Vendor the interface's web fonts so the application needs no internet.

    python3 build/fetch_fonts.py

Writes the woff2 files to frontend/public/fonts/ (Vite copies public/ into dist/ verbatim, so
they are served at /fonts/…) and prints the @font-face block to paste into
frontend/src/styles.css. Re-run it to pick up a newer version of a family.

Only the latin and latin-ext subsets are kept. Google serves the full set — Cyrillic, Greek,
Vietnamese and more — which this application will never render and which would quadruple the
size on disk.

Archivo and Source Sans 3 are variable fonts, so one file covers every weight; Google's CSS
still lists it once per weight, which is why the download is de-duplicated by content hash and
the rules collapse to a weight *range*.

All three families are SIL Open Font License 1.1 — see frontend/public/fonts/OFL.txt.
"""
from __future__ import annotations

import hashlib
import re
import subprocess
import sys
from collections import defaultdict
from pathlib import Path

HERE = Path(__file__).resolve().parent
FONTS = HERE.parent / "frontend" / "public" / "fonts"

# A modern browser UA, or the API answers with .ttf instead of .woff2.
UA = ("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 "
      "(KHTML, like Gecko) Chrome/120.0 Safari/537.36")
CSS_URL = ("https://fonts.googleapis.com/css2?family=Archivo:wght@500;600;700"
           "&family=IBM+Plex+Mono:wght@400;500&family=Source+Sans+3:wght@400;600&display=swap")
KEEP_SUBSETS = {"latin", "latin-ext"}


def fetch(url: str, binary: bool = False):
    out = subprocess.run(["curl", "-sSL", "--max-time", "30", "-A", UA, url],
                         capture_output=True, check=True).stdout
    return out if binary else out.decode()


def main() -> int:
    FONTS.mkdir(parents=True, exist_ok=True)
    css = fetch(CSS_URL)
    blocks = re.findall(r"/\*\s*([a-z-]+)\s*\*/\s*(@font-face\s*\{.*?\})", css, re.S)
    if not blocks:
        print("could not parse the Google Fonts stylesheet", file=sys.stderr)
        return 1

    # (family, subset, content-hash) -> the weights that file serves
    groups: dict[tuple, dict] = {}
    weights = defaultdict(set)
    for subset, block in blocks:
        if subset not in KEEP_SUBSETS:
            continue
        fam = re.search(r"font-family:\s*'([^']+)'", block).group(1)
        weight = int(re.search(r"font-weight:\s*(\d+)", block).group(1))
        style = (re.search(r"font-style:\s*(\w+)", block) or [None, "normal"])[1]
        url = re.search(r"url\((https://[^)]+\.woff2)\)", block).group(1)
        rng = re.search(r"unicode-range:\s*([^;}]+)", block)

        data = fetch(url, binary=True)
        digest = hashlib.md5(data).hexdigest()
        key = (fam, subset, digest)
        weights[key].add(weight)
        if key not in groups:
            name = f"{fam.replace(' ', '')}-{subset}-{digest[:8]}.woff2"
            (FONTS / name).write_bytes(data)
            groups[key] = {"name": name, "style": style, "size": len(data),
                           "range": rng.group(1).strip() if rng else None}

    total = sum(g["size"] for g in groups.values())
    for (fam, subset, _), g in sorted(groups.items()):
        w = sorted(weights[(fam, subset, _)])
        print(f"  {g['name']:<40} {g['size']/1024:6.1f} KB  {fam} {subset} {w}")
    print(f"  {'total':<40} {total/1024:6.1f} KB in {len(groups)} files")

    lines = [
        "/* Self-hosted fonts — the interface looks the same on a machine with no internet.",
        "   Archivo, Source Sans 3 and IBM Plex Mono are SIL Open Font License 1.1; the licence",
        "   is in public/fonts/OFL.txt. Latin and latin-ext subsets only, and the variable",
        "   families carry a weight range because one file serves every weight.",
        "   Regenerate with: python3 build/fetch_fonts.py */",
    ]
    for (fam, subset, digest), g in sorted(groups.items(), key=lambda kv: (kv[0][0], kv[0][1])):
        w = sorted(weights[(fam, subset, digest)])
        wspec = str(w[0]) if len(w) == 1 else f"{w[0]} {w[-1]}"
        rng = f"unicode-range:{g['range']};" if g["range"] else ""
        lines.append(
            f"@font-face{{font-family:'{fam}';font-style:{g['style']};font-weight:{wspec};"
            f"font-display:swap;src:url('/fonts/{g['name']}') format('woff2');{rng}}}")
    block = "\n".join(lines)
    (HERE / "fontface.generated.css").write_text(block + "\n")
    print(f"\nwrote {len(groups)} @font-face rules to build/fontface.generated.css")
    print("paste that block at the top of frontend/src/styles.css")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
