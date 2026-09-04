import { useEffect, useState } from "react";
import { NavLink, Route, Routes, useLocation } from "react-router-dom";
import { api } from "./lib/api";
import type { ModuleSpec, Settings } from "./lib/types";
import Home from "./pages/Home";
import SettingsPage from "./pages/SettingsPage";
import TemplatesPage from "./pages/TemplatesPage";
import ModuleWorkspace from "./pages/ModuleWorkspace";
import DynamicModulusPage from "./pages/DynamicModulusPage";
import { ToastProvider } from "./components/Toast";

export default function App() {
  const [mods, setMods] = useState<ModuleSpec[]>([]);
  const [settings, setSettings] = useState<Settings | null>(null);
  const [err, setErr] = useState<string | null>(null);
  const loc = useLocation();
  useEffect(() => {
    api.modules().then(setMods).catch(e => setErr(String(e)));
    api.settings().then(s => { setSettings(s); applyTheme(s.theme); }).catch(() => {});
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
            {err ? <span style={{ color: "var(--crit)" }}>Backend unreachable: {err}</span> : "Analysis engine connected"}
          </div>
        </aside>
        <main className="main">
          <Routes>
            <Route path="/" element={<Home mods={mods} />} />
            <Route path="/settings" element={<SettingsPage onChange={s => { setSettings(s); applyTheme(s.theme); }} />} />
            <Route path="/templates" element={<TemplatesPage />} />
            <Route path="/m/dynamic_modulus" element={<DynamicModulusPage settings={settings} />} />
            <Route path="/m/:id" element={<ModuleWorkspace key={loc.pathname} mods={mods} settings={settings} />} />
          </Routes>
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
