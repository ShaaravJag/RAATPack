"""FastAPI application: JSON API under /api plus the built frontend as static files."""
from __future__ import annotations

import logging
from pathlib import Path

import json
import math
from typing import Any

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import FileResponse, JSONResponse
from fastapi.staticfiles import StaticFiles

from .. import __version__
from ..config import settings as cfg
from ..io.templates import TemplateLibrary
from .state import SessionStore
from . import routes_core, routes_ws, routes_dm

log = logging.getLogger("raatpack")


def _sanitize(o: Any):
    """NaN / ±inf -> null so charts get gaps instead of a 500 (MATLAB's plot skipped NaN silently)."""
    if isinstance(o, float):
        return None if (math.isnan(o) or math.isinf(o)) else o
    if isinstance(o, dict):
        return {k: _sanitize(v) for k, v in o.items()}
    if isinstance(o, (list, tuple)):
        return [_sanitize(v) for v in o]
    return o


class SafeJSONResponse(JSONResponse):
    def render(self, content: Any) -> bytes:
        return json.dumps(_sanitize(content), ensure_ascii=False, allow_nan=False, separators=(",", ":")).encode("utf-8")


def create_app() -> FastAPI:
    cfg.ensure_dirs()
    app = FastAPI(title="RAAT-Pack v3", version=__version__, default_response_class=SafeJSONResponse)
    app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"])
    app.state.settings = cfg.Settings.load()
    app.state.templates = TemplateLibrary(cfg.BUILTIN_TEMPLATES_DIR, cfg.DATA_DIR / "templates")
    app.state.store = SessionStore(cfg.DATA_DIR / "uploads")
    app.state.export_dir = cfg.DATA_DIR / "exports"
    app.include_router(routes_core.router, prefix="/api")
    app.include_router(routes_ws.router, prefix="/api")
    app.include_router(routes_dm.router, prefix="/api")

    dist = cfg.FRONTEND_DIST
    if dist.exists() and (dist / "index.html").exists():
        app.mount("/assets", StaticFiles(directory=str(dist / "assets")), name="assets")

        @app.get("/{full_path:path}", include_in_schema=False)
        def spa(full_path: str):
            target = dist / full_path
            if full_path and target.exists() and target.is_file():
                return FileResponse(str(target))
            return FileResponse(str(dist / "index.html"))
    else:
        @app.get("/", include_in_schema=False)
        def root():
            return {
                "app": "RAAT-Pack v3",
                "version": __version__,
                "status": "The user interface has not been built yet.",
                "fix": "Run:  cd frontend && npm install && npm run build   then reload this page.",
                "meanwhile": {"api": "/api/modules", "interactive_docs": "/docs"},
                "looked_in": str(dist),
            }
    return app


app = create_app()
