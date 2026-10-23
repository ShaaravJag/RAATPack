"""The launcher's failure paths.

A packaged build has no console, so when the launcher fails it fails invisibly: the icon
bounces once and nothing happens. These tests pin the four ways that used to happen.
"""
import json
import os
import socket
import sys
import threading
from pathlib import Path

import pytest

from raatpack import desktop


@pytest.fixture(autouse=True)
def _clean_module_state():
    """The launcher caches its resolved paths; give each test a fresh view."""
    desktop._LOG_PATH = None
    desktop._LOCK_PATH = None
    yield
    desktop._LOG_PATH = None
    desktop._LOCK_PATH = None


# ---------------------------------------------------------------------------
# logging must never be the thing that kills startup
# ---------------------------------------------------------------------------

def test_log_path_falls_back_when_the_data_dir_is_unwritable(monkeypatch, tmp_path):
    """_log_path() is the first thing main() touches. It used to raise straight through, and the
    failure handler then called it again and raised again — so the app died with no dialog and
    no log, which is the worst possible way for a packaged application to fail."""
    import raatpack.config.settings as cfg
    monkeypatch.setattr(cfg, "DATA_DIR", Path("/dev/null/cannot-exist"), raising=False)

    p = desktop._log_path()
    assert p is not None, "with the data dir unwritable there should still be a log somewhere"
    assert p.parent.exists() and os.access(p.parent, os.W_OK), f"{p.parent} is not writable"
    assert "RAATPack" in str(p)


def test_setup_logging_survives_having_nowhere_to_write(monkeypatch):
    monkeypatch.setattr(desktop, "_log_path", lambda: None)
    path = desktop._setup_logging(False)          # must not raise
    assert path is None
    desktop.LOG.info("still works")               # and logging must still be usable


def test_fatal_never_raises_even_with_no_log_and_no_streams(monkeypatch):
    """_fatal is the last thing that runs on a bad day; it must not be the thing that fails.

    In a packaged build sys.stderr is None, so the final `print` fallback raises unless it is
    guarded — and then the user sees nothing at all.
    """
    import subprocess
    shown = []
    monkeypatch.setattr(sys, "stderr", None)
    monkeypatch.setattr(subprocess, "run", lambda *a, **k: shown.append(a))   # don't really pop a dialog

    desktop._fatal("something broke", None)                  # no log path at all
    desktop._fatal("something broke", Path("/tmp/x.log"))    # and with one

    if sys.platform == "darwin":
        assert shown, "on macOS a native dialog is the only way to reach the user"
        joined = " ".join(str(a) for a in shown[0])
        assert "osascript" in joined and "something broke" in joined


def test_fatal_dialog_text_is_safely_quoted(monkeypatch):
    """The message is interpolated into AppleScript; a stray quote would break the dialog and
    leave the user with nothing."""
    import subprocess
    captured = []
    monkeypatch.setattr(subprocess, "run", lambda *a, **k: captured.append(a[0]))
    monkeypatch.setattr(sys, "stderr", None)
    if sys.platform != "darwin":
        pytest.skip("macOS dialog path")
    desktop._fatal('he said "no" \\ and left', Path("/tmp/x.log"))
    script = captured[0][-1]
    assert script.count('display dialog') == 1
    assert '\\"no\\"' in script or '\\"' in script, f"quotes were not escaped: {script[:120]}"


# ---------------------------------------------------------------------------
# single instance
# ---------------------------------------------------------------------------

def _point_lock_at(monkeypatch, tmp_path):
    import raatpack.config.settings as cfg
    monkeypatch.setattr(cfg, "DATA_DIR", tmp_path, raising=False)
    desktop._LOCK_PATH = None
    return tmp_path / "running.json"


def test_no_lock_file_means_no_running_instance(monkeypatch, tmp_path):
    _point_lock_at(monkeypatch, tmp_path)
    assert desktop._existing_instance() is None


def test_a_live_instance_is_detected_by_its_port(monkeypatch, tmp_path):
    lock = _point_lock_at(monkeypatch, tmp_path)
    srv = socket.socket()
    srv.bind(("127.0.0.1", 0))
    srv.listen(1)
    port = srv.getsockname()[1]
    try:
        lock.write_text(json.dumps({"pid": os.getpid() + 1, "port": port}))
        found = desktop._existing_instance()
        assert found == f"http://127.0.0.1:{port}/", f"should have found the running copy, got {found}"
        assert lock.exists(), "a live instance's lock must not be removed"
    finally:
        srv.close()


def test_a_stale_lock_is_ignored_and_cleaned_up(monkeypatch, tmp_path):
    """A crash leaves the file behind. Trusting it would make the app permanently unlaunchable,
    so the recorded port is probed rather than believed."""
    lock = _point_lock_at(monkeypatch, tmp_path)
    dead = desktop._free_port()                   # nothing is listening there
    lock.write_text(json.dumps({"pid": 999999, "port": dead}))
    assert desktop._existing_instance() is None
    assert not lock.exists(), "the stale lock should have been removed"


def test_a_corrupt_lock_does_not_stop_a_launch(monkeypatch, tmp_path):
    lock = _point_lock_at(monkeypatch, tmp_path)
    lock.write_text("this is not json")
    assert desktop._existing_instance() is None


def test_our_own_lock_is_not_mistaken_for_another_copy(monkeypatch, tmp_path):
    lock = _point_lock_at(monkeypatch, tmp_path)
    lock.write_text(json.dumps({"pid": os.getpid(), "port": 1}))
    assert desktop._existing_instance() is None


def test_claim_and_release_round_trip(monkeypatch, tmp_path):
    lock = _point_lock_at(monkeypatch, tmp_path)
    desktop._claim_instance(4321)
    rec = json.loads(lock.read_text())
    assert rec["port"] == 4321 and rec["pid"] == os.getpid()
    desktop._release_instance()
    assert not lock.exists()


def test_release_leaves_another_process_lock_alone(monkeypatch, tmp_path):
    lock = _point_lock_at(monkeypatch, tmp_path)
    lock.write_text(json.dumps({"pid": os.getpid() + 1, "port": 1234}))
    desktop._release_instance()
    assert lock.exists(), "we must not delete a lock we did not write"


# ---------------------------------------------------------------------------
# shutdown
# ---------------------------------------------------------------------------

def test_serve_loop_stops_when_signalled():
    """thread.join() with no timeout cannot be interrupted and stranded the server with no
    console to Ctrl-C. The loop now waits in slices on a stop event."""
    desktop._STOP.clear()
    running = threading.Event()
    running.set()
    t = threading.Thread(target=lambda: running.wait(10), daemon=True)
    t.start()
    done = threading.Event()
    threading.Thread(target=lambda: (desktop._serve_until_interrupted(t), done.set()), daemon=True).start()

    desktop._STOP.set()
    assert done.wait(5), "the serve loop should return promptly once stopped"
    running.clear()
    desktop._STOP.clear()


def test_serve_loop_returns_when_the_server_thread_dies():
    desktop._STOP.clear()
    t = threading.Thread(target=lambda: None, daemon=True)
    t.start()
    t.join()
    desktop._serve_until_interrupted(t)            # must return, not hang


# ---------------------------------------------------------------------------
# cold start
# ---------------------------------------------------------------------------

def test_splash_is_self_contained():
    """It is shown before the server exists, so it cannot reference anything the server serves."""
    html = desktop.SPLASH
    assert "<html" in html and "RAAT-Pack" in html
    for scheme in ("http://", "https://", "/api/", "/assets/"):
        assert scheme not in html, f"the splash must not load {scheme} — the server is not up yet"


def test_failure_page_names_the_log():
    html = desktop._failed_html(Path("/tmp/raatpack.log"))
    assert "/tmp/raatpack.log" in html
    assert "could not start" in html.lower()
    # and it has to say something useful when there is no log at all
    assert "not writable" in desktop._failed_html(None).lower()


# ---------------------------------------------------------------------------
# matplotlib's font cache
# ---------------------------------------------------------------------------

def test_matplotlib_cache_overrides_pyinstallers_throwaway_dir(monkeypatch, tmp_path):
    """PyInstaller's own matplotlib runtime hook points MPLCONFIGDIR at a fresh temp directory
    and deletes it at exit, so the font cache can never survive a restart — five seconds added
    to every single launch. A frozen build has to override it."""
    import raatpack.config.settings as cfg
    monkeypatch.setattr(cfg, "DATA_DIR", tmp_path, raising=False)
    monkeypatch.setattr(sys, "frozen", True, raising=False)
    monkeypatch.setenv("MPLCONFIGDIR", "/tmp/pyinstaller-throwaway")

    desktop._pin_matplotlib_cache()
    assert os.environ["MPLCONFIGDIR"] == str(tmp_path / "cache" / "matplotlib"), \
        "a frozen build must claim its own cache directory"
    assert (tmp_path / "cache" / "matplotlib").is_dir()


def test_a_deliberate_setting_is_respected_outside_a_bundle(monkeypatch, tmp_path):
    import raatpack.config.settings as cfg
    monkeypatch.setattr(cfg, "DATA_DIR", tmp_path, raising=False)
    monkeypatch.delattr(sys, "frozen", raising=False)
    monkeypatch.setenv("MPLCONFIGDIR", "/tmp/chosen-by-hand")

    desktop._pin_matplotlib_cache()
    assert os.environ["MPLCONFIGDIR"] == "/tmp/chosen-by-hand", \
        "running from source, a value set on purpose should be left alone"


def test_cache_is_claimed_when_nothing_set_it(monkeypatch, tmp_path):
    import raatpack.config.settings as cfg
    monkeypatch.setattr(cfg, "DATA_DIR", tmp_path, raising=False)
    monkeypatch.delattr(sys, "frozen", raising=False)
    monkeypatch.delenv("MPLCONFIGDIR", raising=False)

    desktop._pin_matplotlib_cache()
    assert os.environ["MPLCONFIGDIR"] == str(tmp_path / "cache" / "matplotlib")
