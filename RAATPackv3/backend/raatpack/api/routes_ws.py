"""Per-module workspace: files, specimen table, run, picks, export, session save/load."""
from __future__ import annotations

import csv
import io
import json
import time
from pathlib import Path
from typing import Any, Dict, List, Optional

from fastapi import APIRouter, File, Form, HTTPException, Request, UploadFile
from fastapi.responses import FileResponse, StreamingResponse
from pydantic import BaseModel

from ..config import samples, settings as cfg
from ..equations._base import clean
from ..io import readers
from ..modules import registry
from ..reports import builders, excel as xl, pdf as pdfw
from ..reports.spec import fmt_value, safe_filename_part
from . import analysis
from .state import LoadedFile, SessionStore, Workspace, new_id

router = APIRouter()


def _ws(request: Request, module: str) -> Workspace:
    if module not in registry.MODULES or module == "dynamic_modulus":
        raise HTTPException(404, "unknown module")
    return request.app.state.store.workspace(module)


def _state(module: str, ws: Workspace) -> Dict[str, Any]:
    m = registry.get(module)
    return dict(module=module, project=ws.project, options=ws.options, ran=ws.ran,
                files=[analysis.file_summary(module, f) for f in ws.files],
                table=analysis.results_table(module, ws) if ws.ran else None,
                needs_pick=[f.id for f in ws.files if f.result is not None and getattr(f.result, "needs_pick", False)])


@router.get("/ws/{module}")
def get_ws(module: str, request: Request):
    return _state(module, _ws(request, module))


@router.post("/ws/{module}/reset")
def reset_ws(module: str, request: Request):
    request.app.state.store.reset(module)
    return _state(module, _ws(request, module))


@router.post("/ws/{module}/files")
async def add_files(module: str, request: Request, files: List[UploadFile] = File(...), template_id: Optional[str] = Form(None)):
    ws = _ws(request, module)
    m = registry.get(module)
    store: SessionStore = request.app.state.store
    lib = request.app.state.templates
    template = None
    if m.template_kind:
        if not template_id:
            raise HTTPException(400, "A file template is required for this module")
        try:
            template = lib.get(template_id)
        except KeyError:
            raise HTTPException(400, "template not found")
        if template.kind != m.template_kind:
            raise HTTPException(400, f"Template '{template.name}' is a {template.kind} template; this module needs {m.template_kind}")
    added = []
    for up in files:
        dest = store.new_upload_path(module, up.filename)
        dest.write_bytes(await up.read())
        lf = LoadedFile(new_id(), Path(up.filename).name, str(dest), template_id, None,
                        specimen_id="", inputs={f.key: None for f in m.specimen_inputs})
        try:
            lf.data = analysis.load_data(module, dest, template)
            n = len(analysis.primary_xy(module, lf)[0])
            if n == 0:
                lf.error = "No numeric data found — check the template's columns and data-start row."
        except Exception as e:
            lf.error = readers.describe_read_failure(lf.name, e)
        ws.files.append(lf)
        ws.ran = False
        added.append(analysis.file_summary(module, lf))
    return dict(added=added, state=_state(module, ws))


@router.delete("/ws/{module}/files/{fid}")
def remove_file(module: str, fid: str, request: Request):
    ws = _ws(request, module)
    ws.remove(fid)
    return _state(module, ws)


class FileUpdate(BaseModel):
    specimen_id: Optional[str] = None
    inputs: Optional[Dict[str, Optional[float]]] = None
    picks: Optional[Dict[str, Optional[float]]] = None
    trim_x: Optional[float] = None
    clear_trim: bool = False
    clear_picks: bool = False


@router.put("/ws/{module}/files/{fid}")
def update_file(module: str, fid: str, body: FileUpdate, request: Request):
    ws = _ws(request, module)
    try:
        lf = ws.get(fid)
    except KeyError:
        raise HTTPException(404, "file not found")
    if body.specimen_id is not None:
        lf.specimen_id = body.specimen_id
    if body.inputs is not None:
        lf.inputs.update(body.inputs)
    if body.clear_picks:
        lf.picks = {}
    if body.picks is not None:
        lf.picks.update({k: v for k, v in body.picks.items()})
    if body.clear_trim:
        lf.trim_x = None
    elif body.trim_x is not None:
        lf.trim_x = body.trim_x
    if ws.ran:
        analysis.run_file(module, lf, ws.options)
    return analysis.file_summary(module, lf)


class ProjectIn(BaseModel):
    project: Optional[Dict[str, str]] = None
    options: Optional[Dict[str, Any]] = None


@router.put("/ws/{module}/project")
def update_project(module: str, body: ProjectIn, request: Request):
    ws = _ws(request, module)
    if body.project is not None:
        ws.project.update(body.project)
    if body.options is not None:
        ws.options.update(body.options)
    return _state(module, ws)


@router.post("/ws/{module}/run")
def run(module: str, request: Request):
    ws = _ws(request, module)
    if not ws.files:
        raise HTTPException(400, "Add files first")
    for i, lf in enumerate(ws.files):
        if not lf.specimen_id:
            lf.specimen_id = f"Sample #{i + 1}"
        if lf.data is None:
            continue
        analysis.run_file(module, lf, ws.options)
    ws.ran = True
    return _state(module, ws)


class PickIn(BaseModel):
    kind: str            # scb: 'inflection' ; hamburg: 'strip_left' | 'creep_left' | 'strip_right' | 'creep_right'
    x: Optional[float] = None


@router.post("/ws/{module}/files/{fid}/pick")
def pick(module: str, fid: str, body: PickIn, request: Request):
    ws = _ws(request, module)
    lf = ws.get(fid)
    if body.x is None:
        lf.picks.pop(body.kind, None)
    else:
        lf.picks[body.kind] = float(body.x)
    analysis.run_file(module, lf, ws.options)
    return dict(file=analysis.file_summary(module, lf), curve=analysis.curve_payload(module, lf), state=_state(module, ws))


@router.get("/ws/{module}/curve/{fid}")
def curve(module: str, fid: str, request: Request):
    ws = _ws(request, module)
    try:
        lf = ws.get(fid)
    except KeyError:
        raise HTTPException(404, "file not found")
    if lf.data is None:
        raise HTTPException(400, lf.error or "file not loaded")
    return analysis.curve_payload(module, lf)


@router.get("/ws/{module}/raw/{fid}")
def raw(module: str, fid: str, request: Request, limit: int = 5000):
    """The processed data points (after template transforms) for inspection."""
    ws = _ws(request, module)
    lf = ws.get(fid)
    d = lf.data
    m = registry.get(module)
    if m.reader in ("xy", "scb"):
        x, y = analysis.primary_xy(module, lf)
        cols, data = [m.x_label, m.y_label], [x, y]
    elif m.reader == "four":
        cols, data = ["Time (s)", "Stroke (mm)", "Load (kN)", "COD (mm)"], [d.time, d.stroke, d.load, d.cod]
    elif m.reader == "beam":
        cols, data = ["Cycles", "Flexural stiffness (MPa)", "E (MPa)", "Normalized modulus"], [d.cycles, d.stiffness, d.modulus, d.normalized_modulus]
    elif m.reader == "apa":
        cols, data = ["Cycle", "Average rut (mm)"], [d.cycles_avg, d.avg]
    else:
        cols, data = ["Left cycles", "Left (mm)", "Right cycles", "Right (mm)"], [d.cycles_left, d.left, d.cycles_right, d.right]
    n = max(len(c) for c in data)
    rows = []
    step = max(1, n // limit)
    for i in range(0, n, step):
        rows.append([clean(c[i]) if i < len(c) else None for c in data])
    return dict(columns=cols, rows=rows, total=n)


class ExportIn(BaseModel):
    format: str = "xlsx"                  # xlsx | pdf | csv | png
    file_ids: Optional[List[str]] = None
    options: Dict[str, Any] = {}


@router.post("/ws/{module}/export")
def export(module: str, body: ExportIn, request: Request):
    ws = _ws(request, module)
    m = registry.get(module)
    settings: cfg.Settings = request.app.state.settings
    files = [f for f in ws.files if f.result is not None and (body.file_ids is None or f.id in body.file_ids)]
    if not files:
        raise HTTPException(400, "Run the analysis first (or select at least one analysed specimen)")
    if m.single_export and len(files) > 1 and body.format != "csv":
        files = files[:1]
    project = dict(ws.project)
    project.setdefault("institution", settings.institution)
    project.setdefault("technician", settings.technician)
    opts = dict(ws.options)
    opts.update(body.options or {})
    spec = builders.build(module, files, project, opts, settings.logo_path or None)
    stamp = time.strftime("%Y%m%d-%H%M%S")
    base = f"{safe_filename_part(m.short, 'report')}_{safe_filename_part(project.get('project'))}_{stamp}"
    out_dir: Path = request.app.state.export_dir
    out_dir.mkdir(parents=True, exist_ok=True)
    hdr = lambda out: {"X-Saved-Path": str(out), "Access-Control-Expose-Headers": "X-Saved-Path, Content-Disposition"}
    if body.format == "xlsx":
        out = xl.write_report(spec, out_dir / f"{base}.xlsx")
        return FileResponse(str(out), filename=out.name, media_type="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", headers=hdr(out))
    if body.format == "pdf":
        out = pdfw.render_pdf(spec, out_dir / f"{base}.pdf")
        return FileResponse(str(out), filename=out.name, media_type="application/pdf", headers=hdr(out))
    if body.format == "png":
        out = pdfw.render_chart_png(spec, out_dir / f"{base}.png")
        return FileResponse(str(out), filename=out.name, media_type="image/png", headers=hdr(out))
    if body.format == "csv":
        buf = io.StringIO()
        w = csv.writer(buf)
        w.writerow(["Specimen ID"] + [f.label for f in spec.columns])
        for r in spec.rows:
            w.writerow([r.get("specimen_id")] + [fmt_value(r.get(f.key), f) for f in spec.columns])
        buf.seek(0)
        return StreamingResponse(iter([buf.getvalue()]), media_type="text/csv",
                                 headers={"Content-Disposition": f'attachment; filename="{base}.csv"'})
    raise HTTPException(400, "unknown format")


@router.post("/ws/{module}/samples")
def load_samples(module: str, request: Request):
    """Load this module's bundled sample set, pre-filled and ready to Run.

    Same path-loading as restoring a session — the files already sit on disk, so nothing is
    uploaded. Specimen ids and dimensions come from the manifest in raatpack.config.samples,
    which is also what the verification harness and the golden tests read.
    """
    sset = samples.find(module)
    if sset is None:
        raise HTTPException(404, f"No sample data ships for {module}.")
    if not sset.path().exists():
        raise HTTPException(404, "The sample data is not installed with this copy of RAAT-Pack.")

    m = registry.get(module)
    store: SessionStore = request.app.state.store
    lib = request.app.state.templates
    store.reset(module)
    ws = _ws(request, module)
    # Named on the report so a sample run is never mistaken for real work.
    ws.project = {"project": f"RAAT-Pack sample data - {m.short}",
                  "mix_type": "", "test_temp": "", "technician": ""}

    missing: List[str] = []
    for sf in sset.specimens():
        path = sset.file_path(sf)
        if not path.exists():
            missing.append(sf.name)
            continue
        inputs: Dict[str, Optional[float]] = {f.key: None for f in m.specimen_inputs}
        for k, v in sset.dimensions.items():
            if k in inputs:
                inputs[k] = float(v)
        lf = LoadedFile(new_id(), Path(sf.name).name, str(path), sset.template, None,
                        sf.specimen_id, inputs)
        try:
            t = lib.get(sset.template) if sset.template else None
            lf.data = analysis.load_data(module, path, t)
        except Exception as e:
            lf.error = readers.describe_read_failure(lf.name, e)
        ws.files.append(lf)

    if not ws.files:
        raise HTTPException(404, "The sample data folder is present but empty.")
    out = _state(module, ws)
    out["sample_note"] = (f"Loaded {len(ws.files)} sample specimen(s) for {m.short}"
                          + (f" — {sset.reference_pdf.split('/')[-1]} is the report v2 produced "
                             f"from them." if sset.reference_pdf else
                             " — this module ships no v2 reference report."))
    if missing:
        out["sample_note"] += f" Missing from the install: {', '.join(missing)}."
    return out


@router.get("/ws/{module}/samples")
def describe_samples(module: str, request: Request):
    """What the Load sample data button would load, for the button's tooltip."""
    sset = samples.find(module)
    if sset is None or not sset.path().exists():
        return dict(available=False)
    return dict(available=True, n=len(sset.specimens()), folder=sset.folder,
                reference_pdf=sset.reference_pdf,
                dimensions={k: float(v) for k, v in sset.dimensions.items()},
                note=sset.note)


@router.get("/ws/{module}/session")
def save_session(module: str, request: Request):
    ws = _ws(request, module)
    snap = dict(module=module, saved=time.time(), project=ws.project, options=ws.options,
                files=[dict(name=f.name, path=f.path, template_id=f.template_id, specimen_id=f.specimen_id,
                            inputs=f.inputs, picks=f.picks, trim_x=f.trim_x) for f in ws.files])
    return snap


@router.post("/ws/{module}/session")
def load_session(module: str, body: Dict[str, Any], request: Request):
    store: SessionStore = request.app.state.store
    lib = request.app.state.templates
    store.reset(module)
    ws = _ws(request, module)
    ws.project = dict(body.get("project", {}))
    ws.options = dict(body.get("options", {}))
    for fd in body.get("files", []):
        lf = LoadedFile(new_id(), fd["name"], fd["path"], fd.get("template_id"), None, fd.get("specimen_id", ""),
                        dict(fd.get("inputs", {})), dict(fd.get("picks", {})), fd.get("trim_x"))
        try:
            t = lib.get(lf.template_id) if lf.template_id else None
            lf.data = analysis.load_data(module, Path(lf.path), t)
        except Exception as e:
            lf.error = readers.describe_read_failure(lf.name, e)
        ws.files.append(lf)
    return _state(module, ws)
