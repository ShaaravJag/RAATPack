"""Dynamic Modulus workflow: volumetrics -> binder -> AMPT files -> (Witczak/Hirsch) -> master curves -> export."""
from __future__ import annotations

import time
from pathlib import Path
from typing import Any, Dict, List, Optional

import numpy as np
from fastapi import APIRouter, File, Form, HTTPException, Request, UploadFile
from fastapi.responses import FileResponse
from pydantic import BaseModel

from ..config import settings as cfg
from ..equations import dynamic_modulus as dm
from ..equations._base import clean
from ..io import ampt
from ..reports import builders, excel as xl, pdf as pdfw
from .state import SessionStore, new_id

router = APIRouter(prefix="/dm")


def _st(request: Request) -> Dict[str, Any]:
    store: SessionStore = request.app.state.store
    if not store.dm:
        store.dm = dict(project={}, volumetrics=None, binder=None, files={}, assignment=None, avg=None,
                        witczak=None, hirsch=None, curves={}, ref_temp_c=20.0, temp_source="target",
                        curve_options={})
    return store.dm


def _mc_dict(mc: dm.MasterCurve) -> Dict[str, Any]:
    return dict(key=mc.key, title=mc.title, params=clean(mc.params), sse=clean(mc.sse), reduced=clean(mc.reduced),
                logE_measured=clean(mc.logE_measured), logE_predicted=clean(mc.logE_predicted),
                reduced_frequency=clean(mc.reduced_frequency), E_measured=clean(mc.E_measured),
                grid_x=clean(mc.grid_x), grid_y=clean(mc.grid_y), phase=clean(mc.phase), phase_fit=clean(mc.phase_fit),
                phase_rsq=clean(mc.phase_rsq), temperature_f=clean(mc.temperature_f), frequency=clean(mc.frequency),
                shift_factors=clean(mc.shift_factors))


def _avg_dict(a: dm.AverageTable) -> Dict[str, Any]:
    p, rsq = dm.blackspace_fit(a.logE, a.phase)
    rows = [dict(target_temp_f=clean(a.target_temp_f[i]), chamber_temp_f=clean(a.chamber_temp_f[i]), frequency=clean(a.frequency[i]),
                 E_psi=clean(a.E_psi[i]), phase=clean(a.phase[i]), logE=clean(a.logE[i]), stdev_E=clean(a.stdev_E[i]),
                 cov_E=clean(a.cov_E[i]), stdev_phase=clean(a.stdev_phase[i]), cov_phase=clean(a.cov_phase[i]))
            for i in range(len(a.frequency))]
    samples = []
    for t in a.samples:
        pp, rr = dm.blackspace_fit(t[:, 5], t[:, 4]) if len(t) > 2 else (None, None)
        samples.append(dict(rows=[dict(target_temp_f=clean(r[0]), chamber_temp_f=clean(r[1]), frequency=clean(r[2]), E_psi=clean(r[3]),
                                       phase=clean(r[4]), logE=clean(r[5])) for r in t],
                            blackspace_poly=clean(pp) if pp is not None else None, blackspace_rsq=clean(rr) if rr is not None else None))
    return dict(rows=rows, samples=samples, blackspace_poly=clean(p), blackspace_rsq=clean(rsq), warn_unequal_freqs=a.warn_unequal_freqs)


def _public(st: Dict[str, Any]) -> Dict[str, Any]:
    return dict(project=st["project"], volumetrics=st["volumetrics"], binder=st["binder"],
                files=[dict(id=k, name=v["name"], identification=v["summary"].identification,
                            target_temp_c_file=v["summary"].target_temp_c_file, guess_c=v["guess_c"],
                            frequencies=clean(v["summary"].frequencies_hz), n=int(len(v["summary"].frequencies_hz)))
                       for k, v in st["files"].items()],
                assignment=st["assignment"], avg=(_avg_dict(st["avg"]) if st["avg"] is not None else None),
                witczak=st["witczak"], hirsch=(dict(temps_f=clean(st["hirsch"]["temps_f"]), frequency=clean(st["hirsch"]["frequency"]),
                                                 g_star=clean(st["hirsch"]["g_star"]), E=clean(st["hirsch"]["E"]), rad_per_s=st["hirsch"]["rad_per_s"])
                                            if st["hirsch"] else None),
                curves={k: _mc_dict(v) for k, v in st["curves"].items()}, ref_temp_c=st["ref_temp_c"],
                temp_source=st["temp_source"], pg_grades=list(dm.PG_TABLE.keys()), curve_names=dm.CURVE_NAMES)


@router.get("")
def get_state(request: Request):
    return _public(_st(request))


@router.post("/reset")
def reset(request: Request):
    request.app.state.store.dm = {}
    return _public(_st(request))


class ProjectIn(BaseModel):
    project: Dict[str, str]


@router.put("/project")
def project(body: ProjectIn, request: Request):
    st = _st(request)
    st["project"].update(body.project)
    return _public(st)


class VolIn(BaseModel):
    Gmm: float
    Gsb: float
    air_voids: float
    ac_pct: float


@router.post("/volumetrics")
def volumetrics(body: VolIn, request: Request):
    st = _st(request)
    v = dm.emax_hirsch(body.Gmm, body.Gsb, body.air_voids, body.ac_pct)
    st["volumetrics"] = clean(vars(v))
    if st["hirsch"]:
        st["hirsch"]["E"] = dm.hirsch_from_gstar(v.VMA, v.VFA, np.asarray(st["hirsch"]["g_star"]))
    return _public(st)


class RowsIn(BaseModel):
    rows: List[List[float]]


@router.post("/binder/dsr")
def binder_dsr(body: RowsIn, request: Request):
    st = _st(request)
    a = np.array(body.rows, float)
    f = dm.a_vts_from_dsr(a[:, 0], a[:, 1], a[:, 2])
    st["binder"] = clean(vars(f))
    return _public(st)


@router.post("/binder/penetration")
def binder_pen(body: RowsIn, request: Request):
    st = _st(request)
    a = np.array(body.rows, float)
    f = dm.a_vts_from_penetration(a[:, 0], a[:, 1])
    st["binder"] = clean(vars(f))
    return _public(st)


@router.post("/binder/rotational")
def binder_rv(body: RowsIn, request: Request):
    st = _st(request)
    a = np.array(body.rows, float)
    f = dm.a_vts_from_rotational(a[:, 0], a[:, 1])
    st["binder"] = clean(vars(f))
    return _public(st)


class PGIn(BaseModel):
    grade: str


@router.post("/binder/pg")
def binder_pg(body: PGIn, request: Request):
    st = _st(request)
    if body.grade not in dm.PG_TABLE:
        raise HTTPException(400, "unknown grade")
    st["binder"] = clean(vars(dm.a_vts_from_pg(body.grade)))
    return _public(st)


class ManualBinder(BaseModel):
    A: float
    VTS: float


@router.post("/binder/manual")
def binder_manual(body: ManualBinder, request: Request):
    st = _st(request)
    st["binder"] = dict(A=body.A, VTS=body.VTS, rsq=None, source="Entered manually", log_temp=[], loglog_visc=[])
    return _public(st)


@router.post("/ampt/files")
async def ampt_files(request: Request, files: List[UploadFile] = File(...)):
    st = _st(request)
    store: SessionStore = request.app.state.store
    errors = []
    for up in files:
        dest = store.new_upload_path("dynamic_modulus", up.filename)
        dest.write_bytes(await up.read())
        try:
            s = ampt.read_ampt_summary(dest)
        except Exception as e:
            errors.append(f"{up.filename}: {e}")
            continue
        fid = new_id()
        st["files"][fid] = dict(name=Path(up.filename).name, path=str(dest), summary=s,
                                guess_c=ampt.guess_temperature_from_name(up.filename))
    out = _public(st)
    out["errors"] = errors
    return out


@router.delete("/ampt/files/{fid}")
def ampt_remove(fid: str, request: Request):
    st = _st(request)
    st["files"].pop(fid, None)
    st["avg"] = None
    st["curves"] = {}
    return _public(st)


class AssignIn(BaseModel):
    slots: List[List[Optional[str]]]           # [replicate][temperature slot] -> file id or null
    target_temps_c: List[List[Optional[float]]]


@router.put("/ampt/assign")
def ampt_assign(body: AssignIn, request: Request):
    st = _st(request)
    reps, temps = [], []
    for i, row in enumerate(body.slots):
        rr, tt = [], []
        for j, fid in enumerate(row):
            if fid:
                if fid not in st["files"]:
                    raise HTTPException(400, f"unknown file id {fid}")
                rr.append(st["files"][fid]["summary"])
                t = body.target_temps_c[i][j]
                if t is None:
                    t = st["files"][fid]["guess_c"]
                if t is None:
                    raise HTTPException(400, f"Enter the target temperature for {st['files'][fid]['name']}")
                tt.append(float(t))
            else:
                rr.append(None)
                tt.append(float(body.target_temps_c[i][j] or 0))
        reps.append(rr)
        temps.append(tt)
    reps = [r for r in reps if any(x is not None for x in r)] or reps
    try:
        st["avg"] = dm.build_average_table(reps, temps[: len(reps)])
    except Exception as e:
        raise HTTPException(400, f"Could not build the data table: {e}")
    st["assignment"] = dict(slots=body.slots, target_temps_c=body.target_temps_c)
    st["curves"] = {}
    return _public(st)


class WitczakIn(BaseModel):
    Gb: float
    passing200: float
    retained34: float
    retained38: float
    retained4: float


@router.post("/witczak")
def witczak(body: WitczakIn, request: Request):
    st = _st(request)
    v = st["volumetrics"]
    b = st["binder"]
    a: dm.AverageTable = st["avg"]
    if not v or not b or a is None:
        raise HTTPException(400, "Witczak needs volumetrics, binder A/VTS and loaded AMPT data")
    Tf = a.target_temp_f if st["temp_source"] == "target" else a.chamber_temp_f
    w = dm.witczak_prediction(v["Gmm"], v["Gsb"], v["air_voids"], v["ac_pct"], body.Gb, body.passing200, body.retained34,
                              body.retained38, body.retained4, b["A"], b["VTS"], Tf, a.frequency)
    st["witczak"] = dict(inputs=body.dict(), volumetrics=clean(w.volumetrics), delta=clean(w.delta), alpha=clean(w.alpha),
                         E_psi=clean(w.E_psi), temperature_f=clean(w.temperature_f), frequency=clean(w.frequency))
    return _public(st)


@router.post("/hirsch/file")
async def hirsch_file(request: Request, file: UploadFile = File(...), rad_per_s: bool = Form(False)):
    st = _st(request)
    v = st["volumetrics"]
    if not v:
        raise HTTPException(400, "Calculate E*max from volumetrics first (Hirsch needs VMA and VFA)")
    store: SessionStore = request.app.state.store
    dest = store.new_upload_path("dynamic_modulus", file.filename)
    dest.write_bytes(await file.read())
    h = ampt.read_hirsch_input(dest)
    freq = h.frequency / (2 * np.pi) if rad_per_s else h.frequency
    E = dm.hirsch_from_gstar(v["VMA"], v["VFA"], h.g_star_psi)
    st["hirsch"] = dict(temps_f=h.temps_f, frequency=freq, g_star=h.g_star_psi, E=E, rad_per_s=rad_per_s, name=file.filename)
    return _public(st)


class RunIn(BaseModel):
    curves: List[str]
    ref_temp_c: float = 20.0
    temp_source: str = "target"


@router.post("/run")
def run(body: RunIn, request: Request):
    st = _st(request)
    a: dm.AverageTable = st["avg"]
    v = st["volumetrics"]
    b = st["binder"]
    if a is None:
        raise HTTPException(400, "Load the AMPT files first")
    if not v:
        raise HTTPException(400, "Calculate E*max from volumetrics first")
    st["ref_temp_c"] = body.ref_temp_c
    st["temp_source"] = body.temp_source
    Tf = a.target_temp_f if body.temp_source == "target" else a.chamber_temp_f
    EMAX = v["EMAX"]
    out = {}
    errors = {}
    for key in body.curves:
        try:
            if key == "ea":
                out[key] = dm.fit_ea(a.frequency, Tf, a.logE, a.E_psi, a.phase, EMAX, body.ref_temp_c)
            elif key == "vts":
                if not b:
                    raise ValueError("VTS shifting needs binder A/VTS")
                out[key] = dm.fit_vts(a.frequency, Tf, a.logE, a.E_psi, a.phase, EMAX, body.ref_temp_c, b["A"], b["VTS"])
            elif key == "free":
                out[key] = dm.fit_free(a.frequency, Tf, a.logE, a.E_psi, a.phase, EMAX)
            elif key == "witczak":
                w = st["witczak"]
                if not w or not b:
                    raise ValueError("Run the Witczak prediction first")
                Ew = np.asarray(w["E_psi"], float)
                out[key] = dm.fit_vts(a.frequency, Tf, np.log10(Ew), Ew, a.phase, EMAX, body.ref_temp_c, b["A"], b["VTS"],
                                      key="witczak", setup=dm.FIT_WITCZAK)
            elif key in ("hirsch_ea", "hirsch_vts"):
                h = st["hirsch"]
                if not h:
                    raise ValueError("Load the Hirsch G* file first")
                Eh = np.asarray(h["E"], float)
                ph = a.phase[: len(Eh)] if len(a.phase) >= len(Eh) else np.full(len(Eh), np.nan)
                if key == "hirsch_ea":
                    out[key] = dm.fit_ea(h["frequency"], h["temps_f"], np.log10(Eh), Eh, ph, EMAX, body.ref_temp_c,
                                         key="hirsch_ea", setup=dm.FIT_HIRSCH_EA)
                else:
                    if not b:
                        raise ValueError("Hirsch VTS shifting needs binder A/VTS")
                    out[key] = dm.fit_vts(h["frequency"], h["temps_f"], np.log10(Eh), Eh, ph, EMAX, body.ref_temp_c, b["A"], b["VTS"],
                                          key="hirsch_vts")
            else:
                raise ValueError(f"unknown curve {key}")
        except Exception as e:
            errors[key] = f"{type(e).__name__}: {e}"
    st["curves"] = out
    res = _public(st)
    res["errors"] = errors
    return res


class ExportIn(BaseModel):
    curve: str
    format: str = "xlsx"


@router.post("/export")
def export(body: ExportIn, request: Request):
    st = _st(request)
    mc = st["curves"].get(body.curve)
    if mc is None:
        raise HTTPException(400, "run that master curve first")
    settings: cfg.Settings = request.app.state.settings
    project = dict(st["project"])
    project.setdefault("institution", settings.institution)
    a: dm.AverageTable = st["avg"]
    stdev = a.stdev_E if (a is not None and body.curve in ("ea", "vts", "free")) else None
    spec = builders.build_dm(mc, project, stdev, settings.logo_path or None)
    stamp = time.strftime("%Y%m%d-%H%M%S")
    out_dir: Path = request.app.state.export_dir
    base = f"E-star_{body.curve}_{stamp}"
    hdr = lambda out: {"X-Saved-Path": str(out), "Access-Control-Expose-Headers": "X-Saved-Path, Content-Disposition"}
    if body.format == "pdf":
        out = pdfw.render_pdf(spec, out_dir / f"{base}.pdf")
        return FileResponse(str(out), filename=out.name, media_type="application/pdf", headers=hdr(out))
    if body.format == "png":
        out = pdfw.render_chart_png(spec, out_dir / f"{base}.png")
        return FileResponse(str(out), filename=out.name, media_type="image/png", headers=hdr(out))
    out = xl.write_report(spec, out_dir / f"{base}.xlsx")
    return FileResponse(str(out), filename=out.name, headers=hdr(out))
