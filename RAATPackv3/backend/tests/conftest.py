import json
from pathlib import Path
from typing import Any, Optional, Tuple

import pytest

from raatpack.config import samples
from raatpack.config.settings import BUILTIN_TEMPLATES_DIR, DATA_DIR, SAMPLES_DIR
from raatpack.io.templates import TemplateLibrary

HERE = Path(__file__).resolve().parent
GOLD = json.loads((HERE / "golden" / "values.json").read_text())
TOL = GOLD.get("tolerances", {})
GLOBAL_TOL = float(TOL.get("_default", 0.5))

# The sample data is resolved the same way the application resolves it, so the tests, the
# verification harness and the app can never disagree about where it is.
DEMO = SAMPLES_DIR


@pytest.fixture(scope="session")
def gold():
    return GOLD


@pytest.fixture(scope="session")
def demo():
    if not DEMO.exists():
        # Not a skip: the sample data is committed to the repository, so its absence means a
        # broken checkout, and silently skipping the whole golden suite would hide that.
        pytest.fail(f"sample data not found at {DEMO} — the 'Demo Data' folder is part of the "
                    f"repository; restore it or set RAATPACK_DATA_DIR")
    return DEMO


@pytest.fixture(scope="session")
def templates():
    return TemplateLibrary(BUILTIN_TEMPLATES_DIR, DATA_DIR / "templates")


# ---------------------------------------------------------------------------
# comparing a computed value with the reference report
# ---------------------------------------------------------------------------

def tol_for(module: str, metric: str) -> Any:
    """A percent, or {"decimals": n} to compare at the precision the report printed."""
    block = TOL.get(module, {})
    if metric in block:
        return block[metric]
    if "_default" in block:
        return block["_default"]
    return GLOBAL_TOL


def rel(v: float, g: float) -> float:
    """Relative deviation in %, tolerant of the report's own rounding.

    When the reference value is 0 there is no meaningful relative scale, so the deviation is
    reported as a percentage of the computed value instead -- which is 0% only when the computed
    value is 0 too. (This used to return a bare absolute difference that was then compared
    against a percentage, so a tiny absolute error read as a huge relative one and vice versa.)
    """
    if g == 0:
        return 0.0 if v == 0 else 100.0
    return abs(v - g) / abs(g) * 100.0


def judge(value: Optional[float], golden: float, tol: Any) -> Tuple[bool, str]:
    """(ok, human-readable comparison) under either kind of tolerance."""
    if value is None:
        return False, f"got None, expected {golden}"
    if isinstance(tol, dict) and "decimals" in tol:
        n = int(tol["decimals"])
        ok = abs(round(float(value), n) - float(golden)) < 1e-9
        return ok, f"{value} rounds to {round(float(value), n)} at {n} dp, report says {golden}"
    d = rel(float(value), float(golden))
    return d <= float(tol), f"{value} vs report {golden} (Δ={d:.3f}% > {tol}%)"


def assert_close(v, g, pct, what=""):
    ok, how = judge(v, g, pct)
    assert ok, f"{what}: {how}"


def assert_metric(module: str, metric: str, value, golden, where: str = ""):
    """Assert one reported number, naming the module, the metric and the file that produced it."""
    tol = tol_for(module, metric)
    ok, how = judge(value, golden, tol)
    assert ok, f"{module} · {where} · {metric}: {how}"


# ---------------------------------------------------------------------------
# running a sample file through the application's own code path
# ---------------------------------------------------------------------------

def run_sample(sset: samples.SampleSet, sfile: samples.SampleFile, lib: TemplateLibrary):
    """Load and analyse one sample file exactly as the app does. Returns (result_dict, LoadedFile)."""
    from raatpack.api import analysis
    from raatpack.api.state import LoadedFile

    template = lib.get(sset.template) if sset.template else None
    data = analysis.load_data(sset.module, sset.file_path(sfile), template)
    lf = LoadedFile(id="test", name=sfile.name, path=str(sset.file_path(sfile)),
                    template_id=sset.template, data=data, specimen_id=sfile.specimen_id,
                    inputs=dict(sset.dimensions))
    analysis.run_file(sset.module, lf, {})
    assert lf.error is None, f"{sset.module} · {sfile.name}: analysis failed — {lf.error}"
    assert lf.result is not None, f"{sset.module} · {sfile.name}: analysis returned no result"
    return analysis.result_dict(sset.module, lf), lf
