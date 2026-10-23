"""
Application settings & on-disk layout.

  <data_dir>/settings.json     institution name, logo path, report preferences
  <data_dir>/templates/*.json  user-created file templates
  <data_dir>/uploads/          per-session uploaded raw files
  <data_dir>/exports/          generated reports

data_dir defaults to a per-user location (APPDATA on Windows, ~/Library/Application Support on
macOS, ~/.local/share elsewhere) and can be overridden with RAATPACK_DATA_DIR.
"""
from __future__ import annotations

import json
import os
import sys
from dataclasses import dataclass, asdict
from pathlib import Path
from typing import Optional


def _default_data_dir() -> Path:
    env = os.environ.get("RAATPACK_DATA_DIR")
    if env:
        return Path(env)
    if sys.platform.startswith("win"):
        base = Path(os.environ.get("APPDATA", Path.home() / "AppData" / "Roaming"))
    elif sys.platform == "darwin":
        base = Path.home() / "Library" / "Application Support"
    else:
        base = Path(os.environ.get("XDG_DATA_HOME", Path.home() / ".local" / "share"))
    return base / "RAATPack"


def bundle_dir() -> Path:
    """Directory holding bundled resources (data/templates, frontend/dist). Works from source
    and from a PyInstaller bundle."""
    if getattr(sys, "frozen", False):
        return Path(getattr(sys, "_MEIPASS", Path(sys.executable).parent))
    return Path(__file__).resolve().parents[2]      # .../backend


DATA_DIR = _default_data_dir()
BUILTIN_TEMPLATES_DIR = bundle_dir() / "data" / "templates"
FRONTEND_DIST = bundle_dir() / "frontend_dist"
if not FRONTEND_DIST.exists():
    FRONTEND_DIST = bundle_dir().parent / "frontend" / "dist"

# Bundled sample data (the v2 demo set). Frozen builds carry it under data/samples;
# from a source checkout it is the repository's own "Demo Data" folder.
SAMPLES_DIR = bundle_dir() / "data" / "samples"
if not SAMPLES_DIR.exists():
    SAMPLES_DIR = bundle_dir().parents[1] / "Demo Data"


@dataclass
class Settings:
    institution: str = "Rutgers Asphalt Pavement Laboratory"
    logo_path: str = ""                 # empty => no logo
    technician: str = ""
    default_export_format: str = "xlsx"
    cov_warn_pct: float = 15.0          # results table shows a warning badge past this COV
    theme: str = "system"

    @staticmethod
    def path() -> Path:
        return DATA_DIR / "settings.json"

    @classmethod
    def load(cls) -> "Settings":
        p = cls.path()
        if p.exists():
            try:
                d = json.loads(p.read_text())
                return cls(**{k: v for k, v in d.items() if k in cls.__dataclass_fields__})
            except Exception:
                pass
        return cls()

    def save(self) -> None:
        self.path().parent.mkdir(parents=True, exist_ok=True)
        self.path().write_text(json.dumps(asdict(self), indent=2))


def ensure_dirs() -> None:
    for sub in ("templates", "uploads", "exports", "logos"):
        (DATA_DIR / sub).mkdir(parents=True, exist_ok=True)
