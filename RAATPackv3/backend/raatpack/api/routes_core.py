"""Modules, settings and templates."""
from __future__ import annotations

import csv
import io
import shutil
from pathlib import Path
from typing import List, Optional

from fastapi import APIRouter, File, Form, HTTPException, Request, UploadFile
from fastapi.responses import FileResponse
from pydantic import BaseModel

from .. import __version__
from ..config import settings as cfg
from ..io.templates import Template, ChannelTransform, write_template_workbook, KIND_XY, KIND_FOUR, KIND_BEAM
from ..io import readers
from ..modules import registry

router = APIRouter()


@router.get("/health")
def health():
    return {"ok": True, "version": __version__}


@router.get("/exports")
def list_exports(request: Request):
    d: Path = request.app.state.export_dir
    files = sorted(d.glob("*"), key=lambda p: p.stat().st_mtime, reverse=True)[:50]
    return dict(dir=str(d), files=[dict(name=f.name, size=f.stat().st_size, mtime=f.stat().st_mtime) for f in files if f.is_file()])


@router.post("/exports/open")
def open_exports(request: Request):
    """Open the exports folder in the OS file manager (desktop use only; the server must be local)."""
    import subprocess, sys
    d: Path = request.app.state.export_dir
    d.mkdir(parents=True, exist_ok=True)
    try:
        if sys.platform.startswith("win"):
            import os
            os.startfile(str(d))  # type: ignore[attr-defined]
        elif sys.platform == "darwin":
            subprocess.Popen(["open", str(d)])
        else:
            subprocess.Popen(["xdg-open", str(d)])
    except Exception as e:
        raise HTTPException(500, f"could not open folder: {e}")
    return {"ok": True, "dir": str(d)}


@router.get("/modules")
def modules():
    return [registry.public(registry.MODULES[m]) for m in registry.ORDER]


# ---- settings ---------------------------------------------------------------

class SettingsIn(BaseModel):
    institution: Optional[str] = None
    technician: Optional[str] = None
    default_export_format: Optional[str] = None
    cov_warn_pct: Optional[float] = None
    theme: Optional[str] = None


@router.get("/settings")
def get_settings(request: Request):
    s: cfg.Settings = request.app.state.settings
    return dict(vars(s), data_dir=str(cfg.DATA_DIR), has_logo=bool(s.logo_path and Path(s.logo_path).exists()))


@router.put("/settings")
def put_settings(body: SettingsIn, request: Request):
    s: cfg.Settings = request.app.state.settings
    for k, v in body.dict(exclude_none=True).items():
        setattr(s, k, v)
    s.save()
    return get_settings(request)


@router.post("/settings/logo")
async def upload_logo(request: Request, file: UploadFile = File(...)):
    s: cfg.Settings = request.app.state.settings
    dest = cfg.DATA_DIR / "logos" / Path(file.filename).name
    dest.parent.mkdir(parents=True, exist_ok=True)
    dest.write_bytes(await file.read())
    s.logo_path = str(dest)
    s.save()
    return get_settings(request)


@router.delete("/settings/logo")
def clear_logo(request: Request):
    s: cfg.Settings = request.app.state.settings
    s.logo_path = ""
    s.save()
    return get_settings(request)


@router.get("/settings/logo")
def get_logo(request: Request):
    s: cfg.Settings = request.app.state.settings
    if s.logo_path and Path(s.logo_path).exists():
        return FileResponse(s.logo_path)
    raise HTTPException(404, "no logo")


# ---- templates ---------------------------------------------------------------

class TransformIn(BaseModel):
    offset_start: int = 0
    negative: int = 0
    offset_end: int = 0


class TemplateIn(BaseModel):
    id: Optional[str] = None
    name: str
    kind: str
    columns: dict
    data_start: int = 1
    data_end: Optional[int] = None
    delimiter: str = ","
    sheet: int = 1
    transforms: dict = {}
    units: dict = {}


def _to_template(t: TemplateIn) -> Template:
    import re, uuid
    tid = t.id or (re.sub(r"[^A-Za-z0-9_.-]+", "_", t.name) + "_" + uuid.uuid4().hex[:4])
    tr = {k: ChannelTransform(**v) if isinstance(v, dict) else v for k, v in t.transforms.items()}
    return Template(tid, t.name, t.kind, {k: int(v) for k, v in t.columns.items()}, int(t.data_start), t.data_end,
                    t.delimiter or ",", int(t.sheet or 1), tr, dict(t.units), False, "")


@router.get("/templates")
def list_templates(request: Request, kind: Optional[str] = None):
    lib = request.app.state.templates
    return [t.to_dict() for t in lib.list(kind)]


@router.get("/templates/{tid}")
def get_template(tid: str, request: Request):
    try:
        return request.app.state.templates.get(tid).to_dict()
    except KeyError:
        raise HTTPException(404, "template not found")


@router.post("/templates")
def create_template(body: TemplateIn, request: Request):
    lib = request.app.state.templates
    t = _to_template(body)
    return lib.save(t).to_dict()


@router.put("/templates/{tid}")
def update_template(tid: str, body: TemplateIn, request: Request):
    lib = request.app.state.templates
    body.id = tid
    t = _to_template(body)
    try:
        if lib.get(tid).builtin:
            t.id = tid + "_copy"
            t.name = t.name if t.name.endswith("(copy)") else t.name + " (copy)"
    except KeyError:
        pass
    return lib.save(t).to_dict()


@router.delete("/templates/{tid}")
def delete_template(tid: str, request: Request):
    request.app.state.templates.delete(tid)
    return {"ok": True}


@router.post("/templates/import")
async def import_template(request: Request, file: UploadFile = File(...), name: Optional[str] = Form(None)):
    lib = request.app.state.templates
    tmp = cfg.DATA_DIR / "uploads" / "templates"
    tmp.mkdir(parents=True, exist_ok=True)
    dest = tmp / Path(file.filename).name
    dest.write_bytes(await file.read())
    try:
        t = lib.import_workbook(dest, name=name)
    except Exception as e:
        raise HTTPException(400, f"Could not read template workbook: {e}")
    return t.to_dict()


@router.get("/templates/{tid}/download")
def download_template(tid: str, request: Request):
    lib = request.app.state.templates
    try:
        t = lib.get(tid)
    except KeyError:
        raise HTTPException(404, "template not found")
    out = request.app.state.export_dir / f"{t.name}.xlsx"
    write_template_workbook(t, out)
    return FileResponse(str(out), filename=f"{t.name}.xlsx")


@router.post("/templates/preview")
async def preview_file(request: Request, file: UploadFile = File(...), template: str = Form(...), rows: int = Form(25)):
    """Raw grid of the first rows of an uploaded file plus what the template would parse."""
    import json
    tmp = cfg.DATA_DIR / "uploads" / "preview"
    tmp.mkdir(parents=True, exist_ok=True)
    dest = tmp / Path(file.filename).name
    dest.write_bytes(await file.read())
    t = _to_template(TemplateIn(**json.loads(template)))
    grid: List[List] = []
    ext = dest.suffix.lower()
    if ext in (".xlsx", ".xlsm"):
        import openpyxl
        wb = openpyxl.load_workbook(str(dest), data_only=True, read_only=True)
        ws = wb.worksheets[max(0, min(t.sheet - 1, len(wb.worksheets) - 1))]
        for i, r in enumerate(ws.iter_rows(values_only=True), 1):
            grid.append([("" if v is None else str(v)) for v in r[:12]])
            if i >= rows:
                break
        sheets = [w.title for w in wb.worksheets]
    else:
        rdr = csv.reader(io.StringIO(dest.read_text(errors="replace")), delimiter=t.delimiter or ",")
        for i, r in enumerate(rdr, 1):
            grid.append(r[:12])
            if i >= rows:
                break
        sheets = []
    parsed = None
    err = None
    try:
        if t.kind == KIND_XY:
            c = readers.read_xy(dest, t)
            parsed = dict(n=int(len(c.x)), x=c.x[:8].tolist(), y=c.y[:8].tolist(), x_max=float(c.x.max()) if len(c.x) else None, y_max=float(c.y.max()) if len(c.y) else None)
        elif t.kind == KIND_FOUR:
            c = readers.read_four_channel(dest, t)
            parsed = dict(n=int(len(c.time)), time=c.time[:6].tolist(), stroke=c.stroke[:6].tolist(), load=c.load[:6].tolist(), cod=c.cod[:6].tolist())
        elif t.kind == KIND_BEAM:
            c = readers.read_beam(dest, t)
            parsed = dict(n=int(len(c.cycles)), cycles=c.cycles[:6].tolist(), stiffness=c.stiffness[:6].tolist(), modulus=c.modulus[:6].tolist())
    except Exception as e:
        err = f"{type(e).__name__}: {e}"
    return dict(grid=grid, sheets=sheets, parsed=parsed, error=err)
