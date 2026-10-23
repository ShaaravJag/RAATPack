"""Regression tests for the defects that would surface in front of a lab engineer.

These are not numerical tests — the golden suite owns the numbers. They pin *behaviour*: that a
degenerate specimen produces a usable, flagged result instead of a dead end; that messages name
things the way the form does; that a failed specimen stays visible instead of vanishing from the
table and the statistics.
"""
import numpy as np
import pytest

from raatpack.api import analysis
from raatpack.api.state import LoadedFile, Workspace
from raatpack.config import samples
from raatpack.equations import hamburg
from raatpack.modules import registry
from raatpack.reports import builders

CYCLES = np.arange(0, 20001, 2.0)


# ---------------------------------------------------------------------------
# Hamburg: the manual-pick dead end
# ---------------------------------------------------------------------------

DEGENERATE = {
    "perfectly linear": 0.0002 * CYCLES,          # creep and stripping secants are parallel
    "no rutting at all": np.zeros_like(CYCLES),   # every slope is zero
    "pure quadratic": 1e-9 * CYCLES ** 2,         # second derivative has no usable root
}


@pytest.mark.parametrize("name", sorted(DEGENERATE))
def test_hamburg_never_dead_ends(name):
    """v2 asked the operator to pick the slopes; raising here left the UI with nothing to draw
    and no button to press, because both only render once a result exists."""
    w = hamburg.analyse_wheel(CYCLES, DEGENERATE[name])
    assert w.needs_pick, f"{name}: should be flagged for a manual pick"
    assert np.isfinite(w.max_rut_mm), f"{name}: rut depth must still be reported, got {w.max_rut_mm}"
    # Deliberately not asserting whether a stripping inflection point comes out. Fitting a
    # 6th-order polynomial to these shapes leaves the high-order coefficients as pure numerical
    # noise, so the stripping/creep ratio — and therefore whether the ratio >= 2 rule reports a
    # SIP — differs between NumPy versions. What must hold is that nothing non-finite escapes.
    if w.sip_cycles is not None:
        assert np.isfinite(w.sip_cycles), f"{name}: SIP is {w.sip_cycles}, which cannot be reported"
    # the chart has to be drawable, or there is nothing to click on
    for arr, what in ((w.creep_line_x, "creep x"), (w.creep_line_y, "creep y"),
                      (w.strip_line_x, "stripping x"), (w.strip_line_y, "stripping y")):
        assert np.all(np.isfinite(arr)), f"{name}: {what} contains non-finite values, so the " \
                                         f"slope line cannot be plotted"


def test_hamburg_combined_result_reports_when_either_wheel_needs_a_pick():
    good = samples.get("hamburg")
    f = next(x for x in good.specimens() if x.name.endswith("File 1.xlsx"))
    from raatpack.io import ipc
    d = ipc.read_hamburg(good.file_path(f))
    r = hamburg.analyse(d.cycles_left, d.left, d.cycles_right, d.right)
    assert r.needs_pick is False, "both wheels of demo file 1 auto-detect, so nothing to pick"

    degenerate = 0.0002 * CYCLES
    r2 = hamburg.analyse(CYCLES, degenerate, d.cycles_right, d.right)
    assert r2.needs_pick is True, "a degenerate left wheel must flag the whole specimen"
    assert np.isfinite(r2.avg_max_rut_mm), "the average rut must still be reported"


def test_hamburg_manual_picks_are_not_second_guessed():
    """An operator's own pick is never flagged, even if it sits outside the data."""
    w = hamburg.analyse_wheel(CYCLES, 0.03 * np.sqrt(CYCLES), strip_pick=18000.0, creep_pick=-5000.0)
    assert w.manual is True
    assert w.needs_pick is False, "the operator chose these locations; do not ask them again"


# ---------------------------------------------------------------------------
# messages
# ---------------------------------------------------------------------------

def test_missing_dimension_message_uses_the_form_label(templates):
    """It used to read 'Missing required specimen dimension(s): thickness_mm'."""
    s = samples.get("ideal_ct")
    f = s.specimens()[0]
    data = analysis.load_data("ideal_ct", s.file_path(f), templates.get(s.template))
    lf = LoadedFile(id="t", name=f.name, path=str(s.file_path(f)), template_id=s.template,
                    data=data, specimen_id="1", inputs={"thickness_mm": None, "diameter_mm": None})
    analysis.run_file("ideal_ct", lf, {})
    assert lf.error, "a specimen with no dimensions cannot be analysed"
    assert "Thickness (mm)" in lf.error and "Diameter (mm)" in lf.error, \
        f"the message should name the fields as the form labels them: {lf.error}"
    assert "thickness_mm" not in lf.error, f"a database key leaked into the message: {lf.error}"
    assert not lf.error.startswith("ValueError"), \
        f"the exception class name leaked into a message meant for the operator: {lf.error}"


# ---------------------------------------------------------------------------
# a failed specimen must stay visible
# ---------------------------------------------------------------------------

def _workspace(module_id, n_ok=2, n_bad=1, templates=None):
    s = samples.get(module_id)
    ws = Workspace(module_id=module_id)
    files = s.specimens()
    t = templates.get(s.template) if s.template else None
    for i, f in enumerate(files[: n_ok + n_bad]):
        data = analysis.load_data(module_id, s.file_path(f), t)
        lf = LoadedFile(id=f"f{i}", name=f.name, path=str(s.file_path(f)), template_id=s.template,
                        data=data, specimen_id=f.specimen_id,
                        inputs={} if i >= n_ok else dict(s.dimensions))
        analysis.run_file(module_id, lf, {})
        ws.files.append(lf)
    ws.ran = True
    return ws


def test_errored_specimen_appears_in_the_results_table(templates):
    ws = _workspace("ideal_ct", n_ok=2, n_bad=1, templates=templates)
    table = analysis.results_table("ideal_ct", ws)
    assert len(table["rows"]) == 3, "every specimen gets a row, analysed or not"
    bad = [r for r in table["rows"] if r.get("error")]
    assert len(bad) == 1 and bad[0]["specimen_id"], "the failed specimen must be identifiable"
    assert table["errors"] and table["errors"][0]["error"], \
        "the table should carry the errors so the page can summarise them above it"


def test_hamburg_errored_specimen_is_not_dropped(templates):
    """The Hamburg branch used to `continue` past a failed specimen, so the results read as
    complete while a specimen was missing."""
    s = samples.get("hamburg")
    ws = Workspace(module_id="hamburg")
    for i, f in enumerate(s.specimens()):
        data = analysis.load_data("hamburg", s.file_path(f), None)
        lf = LoadedFile(id=f"h{i}", name=f.name, path=str(s.file_path(f)), template_id=None,
                        data=data, specimen_id=f.specimen_id, inputs={})
        analysis.run_file("hamburg", lf, {})
        ws.files.append(lf)
    broken = LoadedFile(id="hX", name="broken.xlsx", path="/nope", template_id=None, data=None,
                        specimen_id="broken", inputs={})
    broken.error = "Could not read file"
    ws.files.append(broken)
    ws.ran = True

    table = analysis.results_table("hamburg", ws)
    assert len(table["rows"]) == 3, f"expected 3 rows, got {len(table['rows'])}"
    assert any(r.get("error") for r in table["rows"]), "the broken specimen must still have a row"
    ok = [r for r in table["rows"] if not r.get("error")]
    assert all("left" in r and "right" in r and "average" in r for r in ok)


def test_statistics_labels_stay_aligned_when_a_specimen_fails(templates):
    """The dot plot indexed table.rows[i] against a compacted list of values, so one errored
    specimen shifted every label and highlighted the wrong point."""
    ws = _workspace("ideal_ct", n_ok=2, n_bad=1, templates=templates)
    table = analysis.results_table("ideal_ct", ws)
    # the failed specimen is first in the rows but contributes no value
    key = "Gf_J_per_m2"
    s = table["stats"][key]
    assert s["n"] == 2, f"only the analysed specimens count towards n, got {s['n']}"
    assert len(s["labels"]) == len(s["values"]) == 2, "labels travel one-per-value"
    analysed = [r["specimen_id"] for r in table["rows"] if not r.get("error")]
    assert s["labels"] == analysed, f"labels {s['labels']} do not match the analysed rows {analysed}"


# ---------------------------------------------------------------------------
# reports
# ---------------------------------------------------------------------------

def test_report_notes_a_provisional_specimen(templates):
    """A guessed inflection point is averaged in with the rest, so the report has to say so."""
    s = samples.get("scb")
    files = []
    for i, f in enumerate(s.specimens()[:2]):
        data = analysis.load_data("scb", s.file_path(f), templates.get(s.template))
        lf = LoadedFile(id=f"s{i}", name=f.name, path=str(s.file_path(f)), template_id=s.template,
                        data=data, specimen_id=f.specimen_id, inputs=dict(s.dimensions))
        analysis.run_file("scb", lf, {})
        files.append(lf)
    assert not any(getattr(f.result, "needs_pick", False) for f in files), \
        "none of the SCB samples needs a pick, so the flag has to be forced for this test"
    files[0].result.needs_pick = True

    spec = builders.build("scb", files, {}, {}, None)
    joined = " ".join(spec.notes)
    assert "PROVISIONAL" in joined, f"the report does not flag the provisional specimen: {spec.notes}"
    assert files[0].specimen_id in joined, "the note must name which specimen it refers to"


def test_report_notes_a_failed_specimen(templates):
    ws = _workspace("ideal_ct", n_ok=2, n_bad=1, templates=templates)
    spec = builders.build("ideal_ct", ws.files, {}, {}, None)
    joined = " ".join(spec.notes)
    assert "could not be analysed" in joined, \
        f"a specimen missing from the table should be named on the report: {spec.notes}"


# ---------------------------------------------------------------------------
# single-specimen exports
# ---------------------------------------------------------------------------

def test_single_export_modules_are_known():
    """The page clamps the export selection to one file for these; if the list ever grows, the
    clamp has to grow with it or the button will over-promise again."""
    single = {m for m in registry.ORDER if registry.get(m).single_export}
    assert single == {"apa", "beam", "hamburg"}, \
        f"single-export modules changed to {single} — update the clamp in ModuleWorkspace.tsx"
