"""
Desktop launcher.

Starts the API server on a local port in a background thread and opens it in a native window
(pywebview → Edge WebView2 on Windows). Falls back to the default browser if the native window
cannot be created for any reason.

The packaged application runs without a console, so everything is also written to a log file —
that log is the first thing to ask for when someone reports a problem.

    RAATPack.exe                 normal use
    RAATPack.exe --no-window     start the server only and print the URL
    RAATPack.exe --port 8765     pin the port instead of picking a free one
    RAATPack.exe --debug         verbose server logging
"""
from __future__ import annotations

import argparse
import logging
import socket
import sys
import threading
import time
import traceback
import webbrowser
from pathlib import Path

import uvicorn

LOG = logging.getLogger("raatpack.desktop")


def _ensure_streams() -> None:
    """A windowed PyInstaller build has sys.stdout/sys.stderr set to None.

    Anything that writes to them then raises AttributeError — including uvicorn's default
    logging config, which binds handlers to ext://sys.stdout and ext://sys.stderr and fails
    while uvicorn.Config() is being constructed. Point them at the null device instead.
    """
    import os
    for name in ("stdout", "stderr"):
        if getattr(sys, name, None) is None:
            setattr(sys, name, open(os.devnull, "w", encoding="utf-8"))


def _log_path() -> Path:
    from raatpack.config import settings as cfg
    d = cfg.DATA_DIR / "logs"
    d.mkdir(parents=True, exist_ok=True)
    return d / "raatpack.log"


def _setup_logging(debug: bool) -> Path:
    path = _log_path()
    handlers: list[logging.Handler] = [logging.FileHandler(path, encoding="utf-8")]
    if sys.stderr is not None:
        handlers.append(logging.StreamHandler(sys.stderr))
    logging.basicConfig(
        level=logging.DEBUG if debug else logging.INFO,
        format="%(asctime)s  %(levelname)-7s %(name)s: %(message)s",
        handlers=handlers,
        force=True,
    )
    return path


def _fatal(message: str, log_path: Path) -> None:
    """Report an unrecoverable error. With no console attached, use a native dialog on Windows."""
    LOG.error(message)
    text = f"{message}\n\nDetails were written to:\n{log_path}"
    if sys.platform.startswith("win"):
        try:
            import ctypes
            ctypes.windll.user32.MessageBoxW(None, text, "RAAT-Pack — could not start", 0x10)
            return
        except Exception:
            pass
    print(text, file=sys.stderr)


def _free_port() -> int:
    s = socket.socket()
    s.bind(("127.0.0.1", 0))
    port = s.getsockname()[1]
    s.close()
    return port


def _wait_for_server(port: int, timeout: float = 40.0) -> bool:
    deadline = time.time() + timeout
    while time.time() < deadline:
        try:
            with socket.create_connection(("127.0.0.1", port), timeout=0.5):
                return True
        except OSError:
            time.sleep(0.15)
    return False


def _open_native_window(url: str) -> bool:
    """Return True if a native window was shown and has since been closed."""
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
        webview.create_window("RAAT-Pack v3", url, width=1440, height=920, min_size=(1100, 700))
        webview.start()
        return True
    except Exception:
        # Most often a missing or broken Edge WebView2 runtime.
        LOG.warning("native window failed; falling back to the browser\n%s", traceback.format_exc())
        return False


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(prog="RAATPack", add_help=True)
    ap.add_argument("--port", type=int, default=0, help="port to serve on (default: pick a free one)")
    ap.add_argument("--no-window", action="store_true", help="server only; print the URL")
    ap.add_argument("--debug", action="store_true", help="verbose logging")
    args = ap.parse_args(argv)

    _ensure_streams()
    log_path = _setup_logging(args.debug)
    LOG.info("RAAT-Pack starting (frozen=%s, python=%s)", getattr(sys, "frozen", False), sys.version.split()[0])

    try:
        from raatpack import __version__
        from raatpack.api.app import app
        from raatpack.config import settings as cfg
        LOG.info("version %s, data dir %s", __version__, cfg.DATA_DIR)
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
    thread = threading.Thread(target=server.run, daemon=True)
    thread.start()

    if not _wait_for_server(port):
        _fatal(f"RAAT-Pack's server did not start on port {port}.", log_path)
        return 1

    url = f"http://127.0.0.1:{port}/"
    LOG.info("serving at %s", url)

    if args.no_window:
        print(url, flush=True)
        try:
            thread.join()
        except KeyboardInterrupt:
            pass
        server.should_exit = True
        return 0

    if not _open_native_window(url):
        webbrowser.open(url)
        LOG.info("opened in the default browser; close this application to stop the server")
        try:
            thread.join()
        except KeyboardInterrupt:
            pass

    server.should_exit = True
    LOG.info("RAAT-Pack stopped")
    return 0


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
            traceback.print_exc()
        sys.exit(1)
