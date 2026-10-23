import { useCallback, useEffect, useState } from "react";
import { NavLink, Route, Routes, useLocation, useNavigate } from "react-router-dom";
import { api, ENGINE_UNREACHABLE } from "./lib/api";
import type { ModuleSpec, Settings } from "./lib/types";
import Home from "./pages/Home";
import SettingsPage from "./pages/SettingsPage";
import TemplatesPage from "./pages/TemplatesPage";
import ModuleWorkspace from "./pages/ModuleWorkspace";
import DynamicModulusPage from "./pages/DynamicModulusPage";
import { ToastProvider } from "./components/Toast";
import ErrorBoundary from "./components/ErrorBoundary";

export default function App() {
  const [mods, setMods] = useState<ModuleSpec[]>([]);
  const [settings, setSettings] = useState<Settings | null>(null);
  const [err, setErr] = useState<string | null>(null);
  const [connecting, setConnecting] = useState(true);
  const [offline, setOffline] = useState(false);   // a later request could not reach the engine
  const loc = useLocation();
  const nav = useNavigate();

  // One place that knows whether the analysis engine is reachable. A settings failure used to be
  // swallowed, which silently reverted the COV threshold and the institution prefills to their
  // defaults with nothing on screen to say so.
  const connect = useCallback(async () => {
    setConnecting(true);
    try {
      const [m, s] = await Promise.all([api.modules(), api.settings()]);
      setMods(m);
      setSettings(s);
      applyTheme(s.theme);
      setErr(null);
    } catch (e: any) {
      setErr(e?.message || String(e));
    } finally {
      setConnecting(false);
    }
  }, []);
  useEffect(() => { connect(); }, [connect]);

  // Any request that cannot reach the engine raises the banner; the next one that gets an
  // answer lowers it. So the state says whether the engine is reachable now, not merely how
  // start-up went — which matters because the engine is a child process that can die.
  useEffect(() => {
    const h = (e: Event) => setOffline(((e as CustomEvent).detail as string | null) !== null);
    window.addEventListener(ENGINE_UNREACHABLE, h);
    return () => window.removeEventListener(ENGINE_UNREACHABLE, h);
  }, []);
  return (
    <ToastProvider>
      <div className="shell">
        <aside className="side">
          <div className="brand"><div className="mark">RA</div><div><b>RAAT-Pack</b><span>v3 · Rutgers Asphalt Pavement Lab</span></div></div>
          <nav className="nav">
            <NavLink to="/" end>Home</NavLink>
            <div className="sec">Modules</div>
            {mods.map(m => (
              <NavLink key={m.id} to={`/m/${m.id}`}>{m.name}<span className="std">{m.short}</span></NavLink>
            ))}
            <div className="sec">Setup</div>
            <NavLink to="/templates">File templates</NavLink>
            <NavLink to="/settings">Settings</NavLink>
          </nav>
          <div style={{ marginTop: "auto", padding: "10px 8px" }} className="tiny muted">
            {connecting ? <span className="row" style={{ gap: 6 }}><span className="spin" /> Connecting…</span>
              : (err || offline) ? <span className="col" style={{ gap: 6, alignItems: "flex-start" }}>
                  <span style={{ color: "var(--crit)" }}>Analysis engine unreachable</span>
                  <button className="btn sm" onClick={connect}>Try again</button>
                </span>
              : "Analysis engine connected"}
          </div>
        </aside>
        <main className="main">
          {(err || offline) && !connecting && (
            <div className="page" style={{ paddingBottom: 0 }}>
              <div className="alert err col">
                <b>RAAT-Pack cannot reach its analysis engine.</b>
                <span>Nothing on this screen will work until it reconnects. If you started
                  RAAT-Pack by opening the application, close it and open it again; the window and
                  the engine start together.</span>
                <span className="tiny">{err || "A request could not reach the engine."}</span>
                <div><button className="btn sm" onClick={connect}>Try again</button></div>
              </div>
            </div>
          )}
          {/* keyed on the route so moving to another module clears a crashed screen */}
          <ErrorBoundary key={loc.pathname} onReset={() => nav("/")}>
          <Routes>
            <Route path="/" element={<Home mods={mods} />} />
            <Route path="/settings" element={<SettingsPage onChange={s => { setSettings(s); applyTheme(s.theme); }} />} />
            <Route path="/templates" element={<TemplatesPage />} />
            <Route path="/m/dynamic_modulus" element={<DynamicModulusPage settings={settings} />} />
            <Route path="/m/:id" element={<ModuleWorkspace key={loc.pathname} mods={mods} settings={settings} />} />
          </Routes>
          </ErrorBoundary>
        </main>
      </div>
    </ToastProvider>
  );
}

export function applyTheme(theme: string) {
  const root = document.documentElement;
  if (theme === "dark" || theme === "light") root.setAttribute("data-theme", theme);
  else root.removeAttribute("data-theme");
}
