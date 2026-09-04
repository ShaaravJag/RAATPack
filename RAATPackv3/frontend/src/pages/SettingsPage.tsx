import { useEffect, useState } from "react";
import { api } from "../lib/api";
import type { Settings } from "../lib/types";
import { useToast } from "../components/Toast";

export default function SettingsPage({ onChange }: { onChange: (s: Settings) => void }) {
  const [s, setS] = useState<Settings | null>(null);
  const toast = useToast();
  useEffect(() => { api.settings().then(setS); }, []);
  if (!s) return <div className="page"><span className="spin" /></div>;
  const save = async (patch: Partial<Settings>) => {
    try { const n = await api.saveSettings(patch); setS(n); onChange(n); toast("Settings saved"); } catch (e: any) { toast(e.message, "err"); }
  };
  return (
    <div className="page" style={{ maxWidth: 820 }}>
      <div className="pagehead"><div><div className="eyebrow">Setup</div><h1>Settings</h1><p>These fill the report header and control how results are flagged.</p></div></div>
      <div className="panel"><div className="ph"><h3>Report identity</h3></div>
        <div className="pb col">
          <label className="f"><span>Institution</span><input className="i" defaultValue={s.institution} onBlur={e => e.target.value !== s.institution && save({ institution: e.target.value })} /></label>
          <label className="f"><span>Default technician</span><input className="i" defaultValue={s.technician} onBlur={e => e.target.value !== s.technician && save({ technician: e.target.value })} /></label>
          <div className="row" style={{ alignItems: "flex-end" }}>
            <label className="f" style={{ flex: 1 }}><span>Logo (PNG/JPG, shown top-left of every report)</span>
              <input className="i" type="file" accept="image/*" onChange={async e => { const f = e.target.files?.[0]; if (!f) return; try { const n = await api.uploadLogo(f); setS(n); onChange(n); toast("Logo updated"); } catch (er: any) { toast(er.message, "err"); } }} />
            </label>
            {s.has_logo && <img src={`/api/settings/logo?t=${Date.now()}`} alt="logo" style={{ height: 48, border: "1px solid var(--line)", background: "#fff", padding: 4 }} />}
            {s.has_logo && <button className="btn sm" onClick={async () => { const n = await api.clearLogo(); setS(n); onChange(n); }}>Remove</button>}
          </div>
        </div>
      </div>
      <div className="panel"><div className="ph"><h3>Preferences</h3></div>
        <div className="pb grid3">
          <label className="f"><span>Default export format</span>
            <select className="i" value={s.default_export_format} onChange={e => save({ default_export_format: e.target.value })}>
              <option value="xlsx">Excel (.xlsx)</option><option value="pdf">PDF</option><option value="csv">CSV</option>
            </select></label>
          <label className="f"><span>COV warning threshold (%)</span><input className="i" type="number" step="1" defaultValue={s.cov_warn_pct} onBlur={e => save({ cov_warn_pct: Number(e.target.value) })} /></label>
          <label className="f"><span>Theme</span>
            <select className="i" value={s.theme} onChange={e => save({ theme: e.target.value })}>
              <option value="system">Follow system</option><option value="light">Light</option><option value="dark">Dark</option>
            </select></label>
        </div>
      </div>
      <div className="panel"><div className="ph"><h3>Storage</h3></div>
        <div className="pb small"><dl className="kv"><dt>Data folder</dt><dd>{s.data_dir}</dd><dt>Contents</dt><dd>settings.json · templates/ · uploads/ · exports/</dd></dl></div>
      </div>
    </div>
  );
}
