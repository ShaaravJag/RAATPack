"""
In-memory session state for the single-user desktop app.

One `Workspace` per module holds the loaded files (parsed curves), the specimen table, the
last results and any manual picks. Everything is plain python so it serialises to JSON for
session save/load.
"""
from __future__ import annotations

import threading
import time
import uuid
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Dict, List, Optional


@dataclass
class LoadedFile:
    id: str
    name: str
    path: str
    template_id: Optional[str]
    data: Any                        # reader output (XYCurve / FourChannel / BeamData / APAData / HamburgData)
    specimen_id: str = ""
    inputs: Dict[str, Optional[float]] = field(default_factory=dict)
    picks: Dict[str, Any] = field(default_factory=dict)       # manual picks (SCB inflection x, HAM slopes...)
    trim_x: Optional[float] = None                            # SCB begin trim
    result: Any = None
    error: Optional[str] = None
    added: float = field(default_factory=time.time)


@dataclass
class Workspace:
    module_id: str
    files: List[LoadedFile] = field(default_factory=list)
    project: Dict[str, str] = field(default_factory=dict)
    options: Dict[str, Any] = field(default_factory=dict)
    ran: bool = False

    def get(self, fid: str) -> LoadedFile:
        for f in self.files:
            if f.id == fid:
                return f
        raise KeyError(fid)

    def remove(self, fid: str) -> None:
        self.files = [f for f in self.files if f.id != fid]
        self.ran = False


class SessionStore:
    def __init__(self, upload_dir: Path):
        self.upload_dir = Path(upload_dir)
        self.upload_dir.mkdir(parents=True, exist_ok=True)
        self._ws: Dict[str, Workspace] = {}
        self._lock = threading.Lock()
        self.dm: Dict[str, Any] = {}          # Dynamic Modulus state (free-form)

    def workspace(self, module_id: str) -> Workspace:
        with self._lock:
            if module_id not in self._ws:
                self._ws[module_id] = Workspace(module_id)
            return self._ws[module_id]

    def reset(self, module_id: str) -> None:
        with self._lock:
            self._ws[module_id] = Workspace(module_id)

    def new_upload_path(self, module_id: str, filename: str) -> Path:
        d = self.upload_dir / module_id
        d.mkdir(parents=True, exist_ok=True)
        stem = Path(filename).name
        return d / f"{uuid.uuid4().hex[:8]}_{stem}"


def new_id() -> str:
    return uuid.uuid4().hex[:10]
