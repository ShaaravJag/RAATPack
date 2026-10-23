import { createContext, useCallback, useContext, useRef, useState, ReactNode } from "react";
import useEscape from "../lib/useEscape";

type Kind = "ok" | "err";
interface Msg { id: number; text: string; kind: Kind; at: Date }

const Ctx = createContext<(msg: string, kind?: Kind) => void>(() => {});
export const useToast = () => useContext(Ctx);

const HISTORY = 20;                 // how many past messages stay readable
const DISMISS_OK_MS = 4000;         // successes fade on their own; errors never do

export function ToastProvider({ children }: { children: ReactNode }) {
  const [live, setLive] = useState<Msg[]>([]);        // on screen now
  const [log, setLog] = useState<Msg[]>([]);          // everything, for the history panel
  const [open, setOpen] = useState(false);
  const [copied, setCopied] = useState(false);
  const next = useRef(1);

  const show = useCallback((text: string, kind: Kind = "ok") => {
    const m: Msg = { id: next.current++, text, kind, at: new Date() };
    setLog(l => [m, ...l].slice(0, HISTORY));
    setLive(l => [...l, m]);
    // An error that disappears after six seconds is an error you cannot act on: the filename or
    // the cause is gone before you have finished reading it. Only successes self-dismiss.
    if (kind === "ok") setTimeout(() => setLive(l => l.filter(x => x.id !== m.id)), DISMISS_OK_MS);
  }, []);

  const drop = (id: number) => setLive(l => l.filter(x => x.id !== id));
  const copyAll = async () => {
    const text = log.map(m => `[${m.at.toLocaleTimeString()}] ${m.kind === "err" ? "ERROR" : "ok"}: ${m.text}`).join("\n");
    try { await navigator.clipboard.writeText(text); setCopied(true); setTimeout(() => setCopied(false), 1500); }
    catch { /* clipboard blocked — the text is on screen to select by hand */ }
  };

  useEscape(() => setOpen(false), open);
  const errors = log.filter(m => m.kind === "err").length;

  return (
    <Ctx.Provider value={show}>
      {children}

      {/* Announced to a screen reader without stealing focus. */}
      <div aria-live="polite" aria-atomic="false" className="sronly">
        {live.map(m => <div key={m.id}>{m.text}</div>)}
      </div>

      <div className="toastwrap">
        {live.map(m => (
          <div key={m.id} className={"toast" + (m.kind === "err" ? " err" : "")} role={m.kind === "err" ? "alert" : "status"}>
            <span className="toasttext">{m.text}</span>
            <button className="toastx" onClick={() => drop(m.id)} title="Dismiss" aria-label="Dismiss message">✕</button>
          </div>
        ))}
        {!!log.length && (
          <button className="toasthist" onClick={() => setOpen(o => !o)}
            title="Show recent messages — useful when reporting a problem">
            {open ? "Hide" : "Messages"} ({log.length}{errors ? `, ${errors} error${errors === 1 ? "" : "s"}` : ""})
          </button>
        )}
      </div>

      {open && (
        <div className="modalbg" onClick={() => setOpen(false)}>
          <div className="modal" onClick={e => e.stopPropagation()} style={{ maxWidth: 720 }} role="dialog" aria-modal="true">
            <div className="row spread">
              <h2>Recent messages</h2>
              <div className="row">
                <button className="btn sm" onClick={copyAll}>{copied ? "Copied" : "Copy all"}</button>
                <button className="btn sm" onClick={() => { setLog([]); setOpen(false); }}>Clear</button>
                <button className="btn sm" onClick={() => setOpen(false)}>Close</button>
              </div>
            </div>
            <div className="tw" style={{ maxHeight: "60vh" }}>
              <table className="t">
                <thead><tr><th style={{ width: 90 }}>Time</th><th style={{ width: 60 }}>Kind</th><th>Message</th></tr></thead>
                <tbody>
                  {log.map(m => (
                    <tr key={m.id}>
                      <td className="tiny muted">{m.at.toLocaleTimeString()}</td>
                      <td>{m.kind === "err" ? <span className="chip crit">error</span> : <span className="chip ok">ok</span>}</td>
                      <td style={{ whiteSpace: "pre-wrap" }}>{m.text}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      )}
    </Ctx.Provider>
  );
}
