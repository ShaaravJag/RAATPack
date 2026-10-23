"""The bundled sample data, end to end through the HTTP API.

The promise this phase makes is narrow and testable: open any module, press one button, and you
have a complete analysis you can export — with no file of your own. These tests make that
promise the thing that fails if it stops being true.
"""
import pytest
from fastapi.testclient import TestClient

from raatpack.api.app import create_app
from raatpack.config import samples
from raatpack.modules import registry
from raatpack.reports.spec import safe_filename_part

TABLE_MODULES = [m for m in registry.ORDER if m != "dynamic_modulus"]


@pytest.fixture(scope="module")
def client():
    return TestClient(create_app())


@pytest.mark.parametrize("module", TABLE_MODULES)
def test_load_sample_data_then_run_then_export(client, module, demo):
    """One button, then Run, then Export — the whole point of the phase."""
    r = client.post(f"/api/ws/{module}/samples")
    assert r.status_code == 200, f"{module}: loading samples failed — {r.text[:300]}"
    state = r.json()

    sset = samples.get(module)
    assert len(state["files"]) == len(sset.specimens()), \
        f"{module}: loaded {len(state['files'])} files, manifest declares {len(sset.specimens())}"
    bad = [(f["name"], f["error"]) for f in state["files"] if f["error"]]
    assert not bad, f"{module}: sample files failed to read — {bad}"

    # pre-filled, so Run works without the operator typing anything
    spec = registry.get(module)
    for f in state["files"]:
        assert f["specimen_id"], f"{module}: {f['name']} has no pre-filled specimen id"
        for key in spec.required_inputs:
            assert f["inputs"].get(key) is not None, \
                f"{module}: {f['name']} is missing {key}, so Run would fail straight away"

    run = client.post(f"/api/ws/{module}/run")
    assert run.status_code == 200, f"{module}: run failed — {run.text[:300]}"
    rj = run.json()
    analysed = [f for f in rj["files"] if f.get("result") and not f["error"]]
    assert len(analysed) == len(state["files"]), \
        f"{module}: only {len(analysed)} of {len(state['files'])} specimens analysed — " \
        f"{[(f['name'], f['error']) for f in rj['files'] if f['error']]}"

    ids = [f["id"] for f in analysed]
    if spec.single_export:
        ids = ids[:1]
    ex = client.post(f"/api/ws/{module}/export",
                     json={"format": "xlsx", "file_ids": ids, "options": {}})
    assert ex.status_code == 200, f"{module}: export failed — {ex.text[:300]}"
    assert int(ex.headers["content-length"]) > 4000, f"{module}: the exported report is suspiciously small"


def test_dynamic_modulus_samples_arrive_ready_to_run(client, demo):
    """E* has a workflow rather than a specimen table, so loading samples has to walk it."""
    r = client.post("/api/dm/samples")
    assert r.status_code == 200, f"loading E* samples failed — {r.text[:300]}"
    st = r.json()
    assert not st["errors"], f"sample files failed to read — {st['errors']}"
    assert len(st["files"]) == 9, f"expected 9 AMPT summaries, got {len(st['files'])}"
    assert st["volumetrics"], "volumetrics must be filled in — the Hirsch step needs VMA and VFA"
    assert st["avg"], "the averaged data table must be built, or there is nothing to fit"
    assert st["hirsch"], "the binder G* workbook ships with the samples and should be loaded"
    assert st["assignment"], "the replicate/temperature assignment must be filled in"

    slots = st["assignment"]["slots"]
    assert len(slots) == 3, f"expected 3 replicates, got {len(slots)}"
    assert all(len(row) == 3 for row in slots), f"expected 3 temperatures per replicate: {slots}"
    assert all(fid for row in slots for fid in row), f"every slot should be filled: {slots}"
    # temperatures are read from the file names, never hardcoded
    assert st["assignment"]["target_temps_c"][0] == [4.0, 20.0, 45.0], \
        f"temperatures should come from the file names: {st['assignment']['target_temps_c'][0]}"

    run = client.post("/api/dm/run", json={"curves": ["ea"], "ref_temp_c": 20.0, "temp_source": "target"})
    assert run.status_code == 200, f"master curve run failed — {run.text[:300]}"
    assert "ea" in run.json()["curves"], "the EA master curve should have been produced"
    ex = client.post("/api/dm/export", json={"format": "xlsx", "curve": "ea"})
    assert ex.status_code == 200, f"export failed — {ex.text[:300]}"


@pytest.mark.parametrize("module", TABLE_MODULES)
def test_sample_description_matches_the_manifest(client, module, demo):
    r = client.get(f"/api/ws/{module}/samples")
    assert r.status_code == 200
    info = r.json()
    sset = samples.get(module)
    assert info["available"] is True, f"{module}: sample data should be available from a source tree"
    assert info["n"] == len(sset.specimens())
    assert info["folder"] == sset.folder


def test_loading_samples_replaces_whatever_was_there(client, demo):
    """The endpoint resets the workspace; the page confirms first."""
    client.post("/api/ws/scb/samples")
    first = client.get("/api/ws/scb").json()
    assert len(first["files"]) == 4
    again = client.post("/api/ws/scb/samples").json()
    assert len(again["files"]) == 4, "loading twice should not accumulate files"


def test_sample_runs_are_labelled_as_samples(client, demo):
    """So a sample report is never mistaken for real work."""
    st = client.post("/api/ws/ideal_ct/samples").json()
    assert "sample" in (st["project"].get("project") or "").lower(), \
        f"the project name should say this is sample data: {st['project']}"


def test_unknown_module_has_no_samples(client):
    assert client.post("/api/ws/not_a_module/samples").status_code == 404


# ---------------------------------------------------------------------------
# export file naming
# ---------------------------------------------------------------------------

@pytest.mark.parametrize("raw,expect", [
    ("Route 1 - Overlay", "Route_1_-_Overlay"),
    ("Route 1 – Pöhl", "Route_1_-_Pohl"),     # en dash + umlaut: latin-1 would throw
    ("Route 1/2: Overlay", "Route_12_Overlay"),         # illegal in a Windows file name
    ("", "summary"),
    ("   ", "summary"),
    ("CON", "summary"),                                  # reserved device name on Windows
    ("trailing...", "trailing"),
])
def test_export_names_survive_whatever_the_technician_typed(raw, expect):
    assert safe_filename_part(raw) == expect


def test_export_header_encodes_after_a_non_ascii_project_name(client, demo):
    """A project name with an en dash used to raise UnicodeEncodeError when Starlette encoded
    Content-Disposition as latin-1, so the export died rather than downloading."""
    client.post("/api/ws/ideal_ct/samples")
    client.put("/api/ws/ideal_ct/project",
               json={"project": {"project": "Route 1 – Pöhl — 2026"}})
    client.post("/api/ws/ideal_ct/run")
    state = client.get("/api/ws/ideal_ct").json()
    ids = [f["id"] for f in state["files"] if f.get("result")]
    r = client.post("/api/ws/ideal_ct/export",
                    json={"format": "xlsx", "file_ids": ids, "options": {}})
    assert r.status_code == 200, f"export failed on a non-ASCII project name — {r.text[:200]}"
    cd = r.headers["content-disposition"]
    cd.encode("latin-1")        # the encoding that used to blow up
    assert "Pohl" in cd, f"the project name should survive in transliterated form: {cd}"


# ---------------------------------------------------------------------------
# packaging
# ---------------------------------------------------------------------------

def test_frozen_bundle_layout_matches_the_spec(tmp_path, monkeypatch):
    """build/raatpack.spec copies the sample data to "data/samples" inside the bundle; this is
    the other half of that contract — that settings looks for it in exactly that place when
    frozen. Getting these two out of step would disable the button only in the shipped build.
    """
    import importlib
    import sys

    meipass = tmp_path / "bundle"
    (meipass / "data" / "samples" / "SCB").mkdir(parents=True)
    (meipass / "data" / "templates").mkdir(parents=True)
    monkeypatch.setattr(sys, "frozen", True, raising=False)
    monkeypatch.setattr(sys, "_MEIPASS", str(meipass), raising=False)

    import raatpack.config.settings as s
    importlib.reload(s)
    try:
        assert s.SAMPLES_DIR == meipass / "data" / "samples", (
            f"a frozen build would look for sample data in {s.SAMPLES_DIR}, but the spec puts it "
            f"in {meipass / 'data' / 'samples'}")
        assert s.BUILTIN_TEMPLATES_DIR == meipass / "data" / "templates"
    finally:
        monkeypatch.undo()
        importlib.reload(s)


def test_spec_file_ships_the_sample_folder():
    """Read the spec as text: it is executed by PyInstaller, not importable here."""
    from pathlib import Path
    spec = (Path(__file__).resolve().parents[2] / "build" / "raatpack.spec").read_text()
    assert '"data/samples"' in spec, "the PyInstaller spec no longer ships the sample data"
    assert 'SAMPLES = ROOT.parent / "Demo Data"' in spec, \
        "the spec's sample source path changed — check it still points at the repository folder"
