"""
Desktop launcher.

Starts the API server on a local port in a background thread and opens it in a native window
(pywebview → Edge WebView2 on Windows, system WebKit on macOS). Falls back to the default
browser if the native window cannot be created for any reason.

The packaged application runs without a console, so everything is also written to a log file —
that log is the first thing to ask for when someone reports a problem.

    RAATPack                     normal use
    RAATPack --no-window         start the server only and print the URL
    RAATPack --port 8765         pin the port instead of picking a free one
    RAATPack --debug             verbose server logging
    RAATPack --new-instance      start a second copy even if one is already running
"""
from __future__ import annotations

import argparse
import json
import logging
import os
import signal
import socket
import sys
import tempfile
import threading
import time
import traceback
import webbrowser
from pathlib import Path
from typing import Optional

import uvicorn

LOG = logging.getLogger("raatpack.desktop")

# Resolved once. The failure handler must never be the thing that raises, and recomputing this
# path was exactly how a startup failure used to end with no dialog and no log.
_LOG_PATH: Optional[Path] = None
_LOCK_PATH: Optional[Path] = None


def _ensure_streams() -> None:
    """A windowed PyInstaller build has sys.stdout/sys.stderr set to None.

    Anything that writes to them then raises AttributeError — including uvicorn's default
    logging config, which binds handlers to ext://sys.stdout and ext://sys.stderr and fails
    while uvicorn.Config() is being constructed. Point them at the null device instead.
    """
    for name in ("stdout", "stderr"):
        if getattr(sys, name, None) is None:
            try:
                setattr(sys, name, open(os.devnull, "w", encoding="utf-8"))
            except Exception:
                pass


def _writable_dir(path: Path) -> bool:
    try:
        path.mkdir(parents=True, exist_ok=True)
        probe = path / ".write-test"
        probe.write_text("ok", encoding="utf-8")
        probe.unlink()
        return True
    except Exception:
        return False


def _log_path() -> Optional[Path]:
    """Where to write the log. Never raises; returns None only if nowhere is writable.

    The data directory is the first thing the launcher touches, and on a locked-down or
    roaming-profile machine it can be unwritable. Falling back to the temp directory means a
    failure still leaves something to read instead of disappearing silently.
    """
    global _LOG_PATH
    if _LOG_PATH is not None:
        return _LOG_PATH
    candidates = []
    try:
        from raatpack.config import settings as cfg
        candidates.append(Path(cfg.DATA_DIR) / "logs")
    except Exception:
        pass
    candidates.append(Path(tempfile.gettempdir()) / "RAATPack" / "logs")
    for d in candidates:
        if _writable_dir(d):
            _LOG_PATH = d / "raatpack.log"
            return _LOG_PATH
    return None


def _setup_logging(debug: bool) -> Optional[Path]:
    path = _log_path()
    handlers = []
    if path is not None:
        try:
            handlers.append(logging.FileHandler(path, encoding="utf-8"))
        except Exception:
            path = None
    if sys.stderr is not None:
        handlers.append(logging.StreamHandler(sys.stderr))
    if not handlers:
        handlers.append(logging.NullHandler())
    logging.basicConfig(
        level=logging.DEBUG if debug else logging.INFO,
        format="%(asctime)s  %(levelname)-7s %(name)s: %(message)s",
        handlers=handlers,
        force=True,
    )
    return path


def _fatal(message: str, log_path: Optional[Path] = None) -> None:
    """Report an unrecoverable error.

    A packaged build has no console, so stderr goes nowhere: without a native dialog the
    application simply vanishes from the Dock with nothing to show the user.
    """
    try:
        LOG.error(message)
    except Exception:
        pass
    where = f"\n\nDetails were written to:\n{log_path}" if log_path else \
            "\n\nNo log file could be written — the data folder is not writable."
    text = message + where
    try:
        if sys.platform == "darwin":
            import subprocess
            subprocess.run(
                ["osascript", "-e",
                 'display dialog {} with title "RAAT-Pack — could not start" '
                 'buttons {{"OK"}} default button "OK" with icon stop'.format(json.dumps(text))],
                check=False, capture_output=True, timeout=120)
            return
        if sys.platform.startswith("win"):
            import ctypes
            ctypes.windll.user32.MessageBoxW(None, text, "RAAT-Pack — could not start", 0x10)
            return
    except Exception:
        pass
    try:
        print(text, file=sys.stderr)
    except Exception:
        pass


def _pin_matplotlib_cache() -> None:
    """Give matplotlib a writable, persistent place for its font cache.

    Building that cache takes about five seconds, and a packaged build rebuilt it on every
    single launch — most of a cold start. The cause is PyInstaller's own matplotlib runtime
    hook, which points MPLCONFIGDIR at a fresh temporary directory and deletes it again at
    exit, so nothing can ever persist. That is a sensible default for an arbitrary program, but
    this one has a data folder of its own and should use it.

    So: when frozen, override whatever the hook set. When running from source, respect a value
    the developer set deliberately.

    Must run before the analysis engine is imported, because that import is what pulls
    matplotlib in; raatpack.config.settings itself does not.
    """
    if os.environ.get("MPLCONFIGDIR") and not getattr(sys, "frozen", False):
        return                                  # set deliberately outside a bundle; leave it
    try:
        from raatpack.config import settings as cfg
        d = Path(cfg.DATA_DIR) / "cache" / "matplotlib"
    except Exception:
        d = Path(tempfile.gettempdir()) / "RAATPack" / "matplotlib"
    if _writable_dir(d):
        os.environ["MPLCONFIGDIR"] = str(d)
        LOG.info("matplotlib cache: %s", d)


# ---------------------------------------------------------------------------
# single instance
# ---------------------------------------------------------------------------

def _lock_path() -> Optional[Path]:
    global _LOCK_PATH
    if _LOCK_PATH is not None:
        return _LOCK_PATH
    try:
        from raatpack.config import settings as cfg
        d = Path(cfg.DATA_DIR)
    except Exception:
        d = Path(tempfile.gettempdir()) / "RAATPack"
    if not _writable_dir(d):
        return None
    _LOCK_PATH = d / "running.json"
    return _LOCK_PATH


def _port_answers(port: int, timeout: float = 0.5) -> bool:
    try:
        with socket.create_connection(("127.0.0.1", port), timeout=timeout):
            return True
    except OSError:
        return False


def _existing_instance() -> Optional[str]:
    """The URL of a copy that is already running, or None.

    Two copies writing one data directory corrupt each other's session state, and a user who
    double-clicks twice has no way to tell which window is which. The recorded port is probed
    rather than trusted: a stale file left by a crash must not block the next launch.
    """
    p = _lock_path()
    if p is None or not p.exists():
        return None
    try:
        rec = json.loads(p.read_text(encoding="utf-8"))
        port = int(rec["port"])
    except Exception:
        return None
    if rec.get("pid") == os.getpid():
        return None
    if _port_answers(port):
        return "http://127.0.0.1:{}/".format(port)
    try:
        p.unlink()          # stale: the process died without cleaning up
    except Exception:
        pass
    return None


def _claim_instance(port: int) -> None:
    p = _lock_path()
    if p is None:
        return
    try:
        p.write_text(json.dumps({"pid": os.getpid(), "port": port, "started": time.time()}),
                     encoding="utf-8")
    except Exception as e:
        LOG.warning("could not record the running instance: %s", e)


def _release_instance() -> None:
    p = _lock_path()
    if p is None or not p.exists():
        return
    try:
        rec = json.loads(p.read_text(encoding="utf-8"))
        if rec.get("pid") == os.getpid():
            p.unlink()
    except Exception:
        pass


# ---------------------------------------------------------------------------
# server
# ---------------------------------------------------------------------------

def _free_port() -> int:
    s = socket.socket()
    s.bind(("127.0.0.1", 0))
    port = s.getsockname()[1]
    s.close()
    return port


def _wait_for_server(port: int, timeout: float = 90.0) -> bool:
    deadline = time.time() + timeout
    while time.time() < deadline:
        if _port_answers(port):
            return True
        time.sleep(0.15)
    return False


_STOP = threading.Event()


def _install_signal_handlers() -> None:
    """Quit cleanly on the signals an operating system actually sends.

    macOS sends SIGTERM when the application is quit; without a handler the process dies before
    the cleanup runs, leaving the instance lock behind. A stale lock does self-heal on the next
    launch, but tidying up properly is better than relying on that.
    """
    def _handle(signum, _frame):
        LOG.info("received signal %s; shutting down", signum)
        _STOP.set()
    for name in ("SIGTERM", "SIGINT", "SIGHUP"):
        sig = getattr(signal, name, None)
        if sig is None:
            continue
        try:
            signal.signal(sig, _handle)
        except (ValueError, OSError):
            pass        # not the main thread, or not supported on this platform


def _serve_until_interrupted(thread: threading.Thread) -> None:
    """Block, but stay interruptible.

    thread.join() with no timeout cannot be interrupted by Ctrl-C on Windows and leaves an
    orphaned server holding the port when there is no console at all. Waiting in slices keeps
    signals deliverable and lets the loop notice the server stopping on its own.
    """
    try:
        while thread.is_alive() and not _STOP.is_set():
            _STOP.wait(0.5)
    except KeyboardInterrupt:
        LOG.info("interrupted")


# ---------------------------------------------------------------------------
# window
# ---------------------------------------------------------------------------

SPLASH = """<!doctype html><html><head><meta charset="utf-8"><title>RAAT-Pack</title>
<style>
 html,body{height:100%;margin:0}
 body{background:#F7F8F6;color:#191C1B;display:flex;align-items:center;justify-content:center;
      font:15px/1.5 -apple-system,"Segoe UI","Helvetica Neue",Arial,sans-serif}
 @media (prefers-color-scheme:dark){body{background:#191D1B;color:#E7EAE6}}
 .w{text-align:center}
 .m{width:64px;height:64px;border-radius:14px;background:#CC0033;color:#fff;margin:0 auto 18px;
    font-weight:700;font-size:25px;display:flex;align-items:center;justify-content:center}
 h1{font-size:1.05rem;margin:0 0 6px;font-weight:600}
 p{margin:0;opacity:.65;font-size:.86rem}
 .b{margin:20px auto 0;width:190px;height:3px;border-radius:2px;background:rgba(128,128,128,.25);overflow:hidden}
 .b i{display:block;width:40%;height:100%;background:#CC0033;animation:s 1.1s ease-in-out infinite}
 @keyframes s{0%{transform:translateX(-100%)}100%{transform:translateX(250%)}}
</style></head><body><div class="w"><div class="m">RA</div>
<h1>Starting RAAT-Pack</h1><p>Loading the analysis engine…</p>
<div class="b"><i></i></div></div></body></html>"""


def _failed_html(log_path: Optional[Path]) -> str:
    where = ("<p>The log is at:<br><code>{}</code></p>".format(log_path)) if log_path else \
            "<p>No log file could be written — the data folder is not writable.</p>"
    return ("<!doctype html><html><head><meta charset='utf-8'><style>"
            "body{font:15px/1.6 -apple-system,'Segoe UI',Arial,sans-serif;padding:40px;"
            "background:#F7F8F6;color:#191C1B}code{font-size:.85em;word-break:break-all}"
            "@media (prefers-color-scheme:dark){body{background:#191D1B;color:#E7EAE6}}</style>"
            "</head><body><h2>RAAT-Pack could not start its analysis engine.</h2>"
            "<p>Close this window and open RAAT-Pack again. If it keeps happening, send the log "
            "to whoever maintains the toolpack.</p>" + where + "</body></html>")


def _open_native_window(url: str, port: int, log_path: Optional[Path]) -> bool:
    """Show the window straight away, then load the app once the server answers.

    Return True if a native window was shown and has since been closed.

    A packaged build takes anywhere from ten to forty seconds to reach this point on a cold
    start — unpacking itself, parsing the built-in templates, building matplotlib's font cache.
    Waiting for the server before showing anything meant double-clicking produced nothing at
    all for that whole time, which reads as "it didn't launch" and invites a second click.
    """
    try:
        import webview
    except Exception as e:
        LOG.warning("pywebview unavailable (%s); falling back to the browser", e)
        return False
    try:
        try:
            webview.settings["ALLOW_DOWNLOADS"] = True   # so exported reports can be saved
        except Exception:
            pass
        window = webview.create_window("RAAT-Pack v3", html=SPLASH,
                                       width=1440, height=920, min_size=(1100, 700))

        # Quitting from the Dock or the menu tears the process down through Cocoa, which never
        # unwinds the Python stack — so the cleanup in main()'s finally block does not run and
        # the instance lock is left behind. A stale lock does heal itself on the next launch,
        # but it should be the exception, not what happens every time.
        def _closing() -> None:
            LOG.info("window closing; releasing the instance lock")
            _STOP.set()
            _release_instance()

        try:
            window.events.closing += _closing
        except Exception as e:
            LOG.debug("could not hook the window close event: %s", e)

        def _when_ready(win) -> None:
            try:
                if _wait_for_server(port):
                    LOG.info("server is up; loading the interface")
                    win.load_url(url)
                else:
                    LOG.error("server did not answer on port %s", port)
                    win.load_html(_failed_html(log_path))
            except Exception:
                LOG.error("could not load the interface\n%s", traceback.format_exc())

        webview.start(_when_ready, window)
        return True
    except Exception:
        # Most often a missing or broken Edge WebView2 runtime on Windows.
        LOG.warning("native window failed; falling back to the browser\n%s", traceback.format_exc())
        return False


def main(argv=None) -> int:
    ap = argparse.ArgumentParser(prog="RAATPack", add_help=True)
    ap.add_argument("--port", type=int, default=0, help="port to serve on (default: pick a free one)")
    ap.add_argument("--no-window", action="store_true", help="server only; print the URL")
    ap.add_argument("--debug", action="store_true", help="verbose logging")
    ap.add_argument("--new-instance", action="store_true",
                    help="start another copy even if one is already running")
    args = ap.parse_args(argv)

    _ensure_streams()
    log_path = _setup_logging(args.debug)
    _install_signal_handlers()
    LOG.info("RAAT-Pack starting (frozen=%s, python=%s)",
             getattr(sys, "frozen", False), sys.version.split()[0])
    if log_path is None:
        LOG.warning("no writable log location")

    if not args.new_instance:
        running = _existing_instance()
        if running:
            LOG.info("another copy is already running at %s; opening it instead", running)
            if args.no_window:
                print(running, flush=True)
            else:
                webbrowser.open(running)
            return 0

    _pin_matplotlib_cache()
    try:
        from raatpack import __version__
        from raatpack.api.app import app
        from raatpack.config import settings as cfg
        LOG.info("version %s, data dir %s", __version__, cfg.DATA_DIR)
        if not _writable_dir(Path(cfg.DATA_DIR)):
            _fatal("RAAT-Pack cannot write to its data folder:\n{}\n\nResults, settings and "
                   "exported reports are kept there.".format(cfg.DATA_DIR), log_path)
            return 1
    except Exception:
        LOG.error("failed to load the analysis engine\n%s", traceback.format_exc())
        _fatal("RAAT-Pack could not load its analysis engine.", log_path)
        return 1

    port = args.port or _free_port()
    # log_config=None: keep uvicorn from installing its own stdio handlers; ours already write
    # to the log file, which is the only place a windowed build can report anything.
    config = uvicorn.Config(app, host="127.0.0.1", port=port, log_config=None,
                            log_level="debug" if args.debug else "warning")
    server = uvicorn.Server(config)
    thread = threading.Thread(target=server.run, daemon=True, name="raatpack-server")
    thread.start()
    _claim_instance(port)
    url = "http://127.0.0.1:{}/".format(port)

    try:
        if args.no_window:
            if not _wait_for_server(port):
                _fatal("RAAT-Pack's server did not start on port {}.".format(port), log_path)
                return 1
            LOG.info("serving at %s", url)
            print(url, flush=True)
            _serve_until_interrupted(thread)
            return 0

        # The native window shows a splash immediately and loads the app when the server is up.
        if not _open_native_window(url, port, log_path):
            if not _wait_for_server(port):
                _fatal("RAAT-Pack's server did not start on port {}.".format(port), log_path)
                return 1
            LOG.info("serving at %s", url)
            webbrowser.open(url)
            LOG.info("opened in the default browser; quit this application to stop the server")
            _serve_until_interrupted(thread)
        return 0
    finally:
        server.should_exit = True
        _release_instance()
        LOG.info("RAAT-Pack stopped")


if __name__ == "__main__":
    try:
        sys.exit(main())
    except SystemExit:
        raise
    except Exception:
        try:
            LOG.error("unhandled exception\n%s", traceback.format_exc())
            _fatal("RAAT-Pack stopped unexpectedly.", _log_path())
        except Exception:
            try:
                traceback.print_exc()
            except Exception:
                pass
        sys.exit(1)
