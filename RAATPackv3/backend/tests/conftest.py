import json
from pathlib import Path
import pytest

HERE = Path(__file__).resolve().parent
GOLD = json.loads((HERE / "golden" / "values.json").read_text())
DEMO = (HERE / GOLD["demo_root"]).resolve()


@pytest.fixture(scope="session")
def gold():
    return GOLD


@pytest.fixture(scope="session")
def demo():
    if not DEMO.exists():
        pytest.skip(f"demo data not found at {DEMO}")
    return DEMO


def rel(v, g):
    """relative deviation in %, tolerant of the report's own rounding"""
    if g == 0:
        return abs(v - g)
    return abs(v - g) / abs(g) * 100.0


def assert_close(v, g, pct, what=""):
    assert v is not None, f"{what}: got None, expected {g}"
    d = rel(v, g)
    assert d <= pct, f"{what}: {v} vs golden {g} (Δ={d:.3f}% > {pct}%)"
