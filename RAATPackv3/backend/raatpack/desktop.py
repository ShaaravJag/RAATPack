"""
Desktop launcher: starts the API server on a free localhost port in a background thread and
opens it in a native window (pywebview -> Edge WebView2 on Windows). Falls back to the system
browser if pywebview is unavailable.
"""
from __future__ import annotations

import socket
import sys
import threading
import time
import webbrowser

import uvicorn


def _free_port() -> int:
    s = socket.socket()
    s.bind(("127.0.0.1", 0))
    p = s.getsockname()[1]
    s.close()
    return p


def _wait(port: int, timeout: float = 20.0) -> bool:
    t0 = time.time()
    while time.time() - t0 < timeout:
        try:
            with socket.create_connection(("127.0.0.1", port), timeout=0.5):
                return True
        except OSError:
            time.sleep(0.15)
    return False


def main(port: int = 0, open_window: bool = True) -> None:
    from raatpack.api.app import app
    port = port or _free_port()
    server = uvicorn.Server(uvicorn.Config(app, host="127.0.0.1", port=port, log_level="warning"))
    th = threading.Thread(target=server.run, daemon=True)
    th.start()
    if not _wait(port):
        print("RAAT-Pack: server failed to start", file=sys.stderr)
        sys.exit(1)
    url = f"http://127.0.0.1:{port}/"
    if not open_window:
        print(url)
        th.join()
        return
    try:
        import webview
        try:
            webview.settings["ALLOW_DOWNLOADS"] = True     # let the WebView2 window save exported reports
        except Exception:
            pass
        webview.create_window("RAAT-Pack v3", url, width=1440, height=920, min_size=(1100, 700))
        webview.start()
    except ImportError:
        webbrowser.open(url)
        print(f"RAAT-Pack v3 running at {url}  (close this window to stop)")
        try:
            th.join()
        except KeyboardInterrupt:
            pass
    server.should_exit = True


if __name__ == "__main__":
    main(open_window="--no-window" not in sys.argv)
