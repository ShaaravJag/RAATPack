import { Component, ErrorInfo, ReactNode } from "react";

/** Keeps a render exception from blanking the window.
 *
 *  Without this, a single bad value in one chart takes the whole application down to a white
 *  page with nothing on screen and nothing to click — on a lab PC that looks like the software
 *  crashed, and the technician has no way to tell anyone what happened. */
export default class ErrorBoundary extends Component<
  { children: ReactNode; onReset?: () => void },
  { error: Error | null; info: string }
> {
  state = { error: null as Error | null, info: "" };

  static getDerivedStateFromError(error: Error) {
    return { error, info: "" };
  }

  componentDidCatch(error: Error, info: ErrorInfo) {
    this.setState({ error, info: info.componentStack || "" });
    // eslint-disable-next-line no-console
    console.error("RAAT-Pack render error:", error, info.componentStack);
  }

  render() {
    const { error, info } = this.state;
    if (!error) return this.props.children;
    const detail = `${error.message}\n\n${error.stack || ""}\n${info}`.trim();
    return (
      <div className="page">
        <div className="panel">
          <div className="ph"><h3>Something went wrong on this screen</h3></div>
          <div className="pb col">
            <div className="alert err">
              Your data is safe — it lives in the analysis engine, not in this window. Go back to
              the module and it will reload from the server.
            </div>
            <div className="row">
              <button className="btn primary" onClick={() => { this.setState({ error: null, info: "" }); this.props.onReset?.(); }}>
                Back to the module
              </button>
              <button className="btn" onClick={() => location.reload()}>Reload the window</button>
              <button className="btn" onClick={() => navigator.clipboard?.writeText(detail)}>
                Copy the details
              </button>
            </div>
            <details>
              <summary className="tiny muted">Technical details</summary>
              <pre className="tiny" style={{ whiteSpace: "pre-wrap", overflowWrap: "anywhere" }}>{detail}</pre>
            </details>
          </div>
        </div>
      </div>
    );
  }
}
