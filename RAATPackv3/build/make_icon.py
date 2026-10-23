#!/usr/bin/env python3
"""Generate the application icon from the mark the interface already uses.

    python3 build/make_icon.py            # writes build/icon.icns (and build/icon.png)

Why generated rather than converted: every image in the repository is either too small for a
macOS icon (the v2 icons top out at 48 px, and macOS wants 1024) or the wrong shape (the CAIT
and Rutgers marks are wide, not square). Upscaling a 456 px logo to 1024 looks soft at exactly
the size people see it. Drawing the sidebar's own "RA" monogram instead is sharp at every size
and matches what is already on screen.

The colour is --accent from the light theme in frontend/src/styles.css.
"""
from __future__ import annotations

import importlib.util
import shutil
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ACCENT = (0xCC, 0x00, 0x33)          # --accent, light theme
INK = (0xFF, 0xFF, 0xFF)
TEXT = "RA"

# macOS draws icons inside a rounded square with a margin; these match Apple's proportions
# closely enough that the icon does not look oversized next to system apps.
CANVAS = 1024
INSET = 100                           # transparent margin around the rounded square
RADIUS = 200

FONT_CANDIDATES = [
    "/System/Library/Fonts/Supplemental/Arial Bold.ttf",
    "/System/Library/Fonts/Supplemental/Arial Black.ttf",
    "/System/Library/Fonts/HelveticaNeue.ttc",
    "/Library/Fonts/Arial Bold.ttf",
]
# The sizes macOS expects inside an .iconset, as (pixel size, file name).
ICONSET = [
    (16, "icon_16x16.png"), (32, "icon_16x16@2x.png"),
    (32, "icon_32x32.png"), (64, "icon_32x32@2x.png"),
    (128, "icon_128x128.png"), (256, "icon_128x128@2x.png"),
    (256, "icon_256x256.png"), (512, "icon_256x256@2x.png"),
    (512, "icon_512x512.png"), (1024, "icon_512x512@2x.png"),
]


def _font(size: int):
    from PIL import ImageFont
    for path in FONT_CANDIDATES:
        if Path(path).exists():
            try:
                return ImageFont.truetype(path, size)
            except Exception:
                continue
    print("warning: no bold system font found; falling back to Pillow's default", file=sys.stderr)
    from PIL import ImageFont as IF
    return IF.load_default()


def render(size: int = CANVAS):
    from PIL import Image, ImageDraw

    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    scale = size / CANVAS
    inset, radius = INSET * scale, RADIUS * scale
    d.rounded_rectangle([inset, inset, size - inset, size - inset], radius=radius, fill=ACCENT + (255,))

    f = _font(int(360 * scale))
    # Centre on the glyphs' own bounding box, not the font's line box: the latter includes
    # ascender and descender space the letters do not use, which sits the text visibly high.
    box = d.textbbox((0, 0), TEXT, font=f)
    d.text(((size - (box[2] - box[0])) / 2 - box[0], (size - (box[3] - box[1])) / 2 - box[1]),
           TEXT, font=f, fill=INK + (255,))
    return img


def main() -> int:
    if importlib.util.find_spec("PIL") is None:
        print("Pillow is required:  pip install pillow", file=sys.stderr)
        return 1
    from PIL import Image

    master = render()
    png = HERE / "icon.png"
    master.save(png)
    print(f"wrote {png.relative_to(HERE.parent)}  ({master.width}x{master.height})")

    # Windows too, from the same master: the icon that shipped with v2 is 48 px, which Windows
    # upscales into a blur anywhere it is shown larger than the taskbar.
    ico = HERE / "icon.ico"
    master.save(ico, sizes=[(s, s) for s in (16, 24, 32, 48, 64, 128, 256)])
    print(f"wrote {ico.relative_to(HERE.parent)}  ({ico.stat().st_size // 1024} KB, 16-256 px)")

    if sys.platform != "darwin":
        print("not macOS — skipping the .icns (iconutil is macOS only)")
        return 0
    if not shutil.which("iconutil"):
        print("iconutil not found — install the Xcode command line tools", file=sys.stderr)
        return 1

    iconset = HERE / "icon.iconset"
    if iconset.exists():
        shutil.rmtree(iconset)
    iconset.mkdir()
    for px, name in ICONSET:
        master.resize((px, px), Image.LANCZOS).save(iconset / name)

    icns = HERE / "icon.icns"
    subprocess.run(["iconutil", "-c", "icns", str(iconset), "-o", str(icns)], check=True)
    shutil.rmtree(iconset)
    print(f"wrote {icns.relative_to(HERE.parent)}  ({icns.stat().st_size // 1024} KB)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
