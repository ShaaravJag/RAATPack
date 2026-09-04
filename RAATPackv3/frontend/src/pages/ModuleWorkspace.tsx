import { useCallback, useEffect, useMemo, useState } from "react";
import { Link, useParams } from "react-router-dom";
import { api, fmt } from "../lib/api";
import type { CurvePayload, LoadedFile, ModuleSpec, Settings, Template, WorkspaceState } from "../lib/types";
import Chart from "../components/Chart";
import FileDrop from "../components/FileDrop";
import SpecimenTable from "../components/SpecimenTable";
import ResultsTable from "../components/ResultsTable";
import StatsPanel from "../components/StatsPanel";
import { useToast } from "../components/Toast";

const PROJECT_FIELDS: [string, string][] = [["project", "Project name"], ["mix_type", "Mix type"], ["test_temp", "Test temperature"], ["institution", "Institution"], ["date", "Date tested"], ["technician", "Technician"]];

export default function ModuleWorkspace({ mods, settings }: { mods: ModuleSpec[]; settings: Settings | null }) {
  const { id = "" } = useParams();
  const spec = mods.find(m => m.id === id);
  const toast = useToast();
  const [st, setSt] = useState<WorkspaceState | null>(null);
  const [templates, setTemplates] = useState<Template[]>([]);
  const [tid, setTid] = useState<string>("");
  const [busy, setBusy] = useState<string | null>(null);
  const [sel, setSel] = useState<string | null>(null);
  const [curve, setCurve] = useState<CurvePayload | null>(null);
  const [overlayMode, setOverlayMode] = useState<"single" | "all">("all");
  const [hidden, setHidden] = useState<Set<string>>(new Set());
  const [pickMode, setPickMode] = useState<string | null>(null);   // 'inflection' | 'trim' | 'strip_left' ...
  const [rawOpen, setRawOpen] = useState(false);
  const [raw, setRaw] = useState<{ columns: string[]; rows: (number | null)[][]; total: number } | null>(null);
  const [exportSel, setExportSel] = useState<Set<string>>(new Set());
  const [fmtSel, setFmtSel] = useState<string>(settings?.default_export_format || "xlsx");
  const [tails, setTails] = useState<string>("all");
  const covWarn = settings?.cov_warn_pct ?? 15;

  const reload = useCallback(async () => { if (!id) return; const s = await api.ws(id); setSt(s); return s; }, [id]);
  useEffect(() => { reload().catch(e => toast(String(e), "err")); }, [reload]);
  useEffect(() => {
    if (!spec?.template_kind) return;
    api.templates(spec.template_kind).then(ts => {
      setTemplates(ts);
      if (tid && ts.some(t => t.id === tid)) return;
      // prefer this module's own default, then the lab's MTS template for it, then any default
      const needle = spec.short.toLowerCase().replace(/[^a-z]/g, "");
      const norm = (n: string) => n.toLowerCase().replace(/[^a-z]/g, "");
      const pick = ts.find(t => t.name.startsWith("Default") && norm(t.name).includes(needle))
        || ts.find(t => t.name.startsWith("MTS TWSX") && norm(t.name).includes(needle))
        || ts.find(t => t.name.startsWith("Default")) || ts[0];
      if (pick) setTid(pick.id);
    });
  }, [spec?.template_kind, spec?.short]);
  useEffect(() => { if (st && sel && st.files.find(f => f.id === sel)?.result) api.curve(id, sel).then(setCurve).catch(() => setCurve(null)); else setCurve(null); }, [st, sel, id]);
  useEffect(() => { if (st && !sel && st.files.length) setSel(st.files[0].id); }, [st, sel]);
  useEffect(() => { if (st) setExportSel(new Set(st.files.filter(f => f.result).map(f => f.id))); }, [st?.ran, st?.files.length]);

  const files = st?.files || [];
  const ran = !!st?.ran;
  const overlaySeries = useMemo(() => files.filter(f => f.preview?.x?.length && !f.error).map(f => ({ name: f.specimen_id || f.name, x: f.preview.x, y: f.preview.y, style: "line" })), [files]);
  if (!spec) return <div className="page"><div className="alert warn">{mods.length ? <>Unknown module <code>{id}</code>.</> : <span className="spin" />}</div></div>;

  const addFiles = async (fs: File[]) => {
    if (spec.template_kind && !tid) return toast("Choose a file template first", "err");
    setBusy("Reading files…");
    try { const r = await api.addFiles(id, fs, tid); setSt(r.state); const bad = r.added.filter(a => a.error); if (bad.length) toast(`${bad.length} file(s) could not be read — check the template`, "err"); else toast(`${r.added.length} file(s) added`); }
    catch (e: any) { toast(e.message, "err"); } finally { setBusy(null); }
  };
  const patchFile = async (fid: string, patch: any) => {
    setSt(s => s && ({ ...s, files: s.files.map(f => f.id === fid ? { ...f, ...(patch.specimen_id !== undefined ? { specimen_id: patch.specimen_id } : {}), inputs: { ...f.inputs, ...(patch.inputs || {}) } } : f) }));
    try { await api.updateFile(id, fid, patch); if (ran) reload(); } catch (e: any) { toast(e.message, "err"); }
  };
  const fillAll = async (key: string, value: number | null) => { for (const f of files) await api.updateFile(id, f.id, { inputs: { [key]: value } }); reload(); };
  const run = async () => { setBusy("Running analysis…"); try { const s = await api.run(id); setSt(s); if (s.needs_pick.length) toast(`${s.needs_pick.length} specimen(s) need a manual inflection point`, "err"); else toast("Analysis complete"); } catch (e: any) { toast(e.message, "err"); } finally { setBusy(null); } };
  const saveProject = (k: string, v: string) => api.updateProject(id, { project: { [k]: v } }).then(setSt).catch(e => toast(e.message, "err"));
  const saveOption = (k: string, v: any) => api.updateProject(id, { options: { [k]: v } }).then(setSt).catch(e => toast(e.message, "err"));
  const doPick = async (x: number) => {
    if (!sel || !pickMode) return;
    try {
      if (pickMode === "trim") { await api.updateFile(id, sel, { trim_x: x }); await reload(); toast(`Trimmed before ${x.toFixed(3)} mm`); }
      else { const r = await api.pick(id, sel, pickMode, x); setCurve(r.curve); setSt(r.state); toast(`Set ${pickMode.replace("_", " ")} at ${x.toFixed(pickMode === "inflection" ? 3 : 0)}`); }
    } catch (e: any) { toast(e.message, "err"); }
    setPickMode(null);
  };
  const clearPick = async (kind: string) => { if (!sel) return; if (kind === "trim") { await api.updateFile(id, sel, { clear_trim: true }); await reload(); } else { const r = await api.pick(id, sel, kind, null); setCurve(r.curve); setSt(r.state); } };
  const doExport = async () => {
    setBusy("Building report…");
    try { const opts: any = { tails }; if (spec.id === "cold_scb" && tails === "select") opts.tail_ids = Array.from(exportSel); const name = await api.exportReport(id, { format: fmtSel, file_ids: Array.from(exportSel), options: opts }); toast(`Saved ${name}`); }
    catch (e: any) { toast(e.message, "err"); } finally { setBusy(null); }
  };
  const openRaw = async () => { if (!sel) return; setRaw(await api.raw(id, sel)); setRawOpen(true); };
  const saveSession = async () => { const snap = await api.session(id); const a = document.createElement("a"); a.href = URL.createObjectURL(new Blob([JSON.stringify(snap, null, 2)], { type: "application/json" })); a.download = `${spec.short}_session.json`; a.click(); };
  const loadSession = async (f: File) => { try { setSt(await api.loadSession(id, JSON.parse(await f.text()))); toast("Session restored — click Run to recompute"); } catch (e: any) { toast(e.message, "err"); } };

  const selFile = files.find(f => f.id === sel) || null;
  const toggle = (n: string) => setHidden(h => { const s = new Set(h); s.has(n) ? s.delete(n) : s.add(n); return s; });
  const pickHint: Record<string, string> = { inflection: "Click the point on the curve where the post-peak slope should be evaluated", trim: "Click where the curve should start (everything before is discarded)", strip_left: "Click the LEFT wheel stripping-slope point", creep_left: "Click the LEFT wheel creep-slope point", strip_right: "Click the RIGHT wheel stripping-slope point", creep_right: "Click the RIGHT wheel creep-slope point" };

  return (
    <div className="page">
      <div className="pagehead">
        <div><div className="eyebrow">{spec.standard}</div><h1>{spec.name}</h1><p>{spec.description}</p></div>
        <div className="row">
          <label className="btn sm" title="Restore a saved session">Load session<input type="file" accept=".json" hidden onChange={e => { const f = e.target.files?.[0]; if (f) loadSession(f); e.target.value = ""; }} /></label>
          <button className="btn sm" onClick={saveSession} disabled={!files.length}>Save session</button>
          <button className="btn sm danger" onClick={async () => { if (confirm("Clear all files and results for this module?")) setSt(await api.reset(id)); }}>Clear</button>
        </div>
      </div>
      {busy && <div className="alert info row"><span className="spin" /> {busy}</div>}

      <div className="panel"><div className="ph"><h3><span className="step">1</span>Project information <span className="muted small" style={{ fontWeight: 400 }}>(optional — fills the report header)</span></h3></div>
        <div className="pb grid3">
          {PROJECT_FIELDS.map(([k, lab]) => <label className="f" key={k}><span>{lab}</span><input className="i" defaultValue={st?.project?.[k] ?? (k === "institution" ? settings?.institution ?? "" : k === "technician" ? settings?.technician ?? "" : "")} onBlur={e => saveProject(k, e.target.value)} /></label>)}
        </div>
      </div>

      <div className="panel"><div className="ph"><h3><span className="step">2</span>Files</h3>
        {spec.template_kind ? <div className="row"><span className="tiny muted">File template</span>
          <select className="i" style={{ width: 300 }} value={tid} onChange={e => setTid(e.target.value)}>{templates.map(t => <option key={t.id} value={t.id}>{t.name}{t.builtin ? "" : " (custom)"}</option>)}</select>
          <Link to="/templates" className="btn sm">Manage…</Link></div>
          : <span className="tiny muted">Standard IPC Global workbook (sheet 2 “RawData”) — no template needed</span>}
      </div>
        <div className="pb col">
          <FileDrop onFiles={addFiles} accept={spec.reader === "beam" || spec.reader === "xy" || spec.reader === "scb" || spec.reader === "four" ? ".xlsx,.csv" : ".xlsx"} disabled={!!busy} />
          {spec.supports_trim && <div className="tiny muted">The end of each SCB curve is trimmed automatically at 0.1 kN (v2 rule). Use “Trim beginning” on the chart if the curve has a seating region.</div>}
        </div>
      </div>

      <div className="panel"><div className="ph"><h3><span className="step">3</span>Specimens</h3>
        <div className="row"><span className="tiny muted">* required for the analysis</span><button className="btn primary" disabled={!files.length || !!busy} onClick={run}>{ran ? "Re-run" : "Run analysis"}</button></div></div>
        <div className="pb"><SpecimenTable spec={spec} files={files} selected={sel} onSelect={setSel} onChange={patchFile} onRemove={async fid => setSt(await api.removeFile(id, fid))} onFill={fillAll} /></div>
      </div>

      {ran && st?.table && (
        <>
          <div className="panel"><div className="ph"><h3><span className="step">4</span>Results</h3><div className="row"><button className="btn sm" onClick={openRaw} disabled={!sel}>Inspect data points</button></div></div>
            <div className="pb col">
              <ResultsTable table={st.table} covWarn={covWarn} selected={sel} onSelect={setSel} hamburg={spec.id === "hamburg"} />
              {st.needs_pick.length > 0 && <div className="alert warn">Could not find an inflection point automatically for {st.needs_pick.length} specimen(s) — select the specimen, then use <b>Pick inflection point</b> on the chart (same as v2's prompt).</div>}
              {spec.id === "cold_scb" && st.table.rows.some((r: any) => r.tail_success === false) && <div className="alert warn">Could not determine a tail for some specimens — their fracture energy is reported without the extrapolated tail.</div>}
            </div>
          </div>

          <div className="panel"><div className="ph"><h3>Chart</h3>
            <div className="row">
              <div className="tabs" style={{ border: 0 }}><button className={overlayMode === "all" ? "on" : ""} onClick={() => setOverlayMode("all")}>All specimens</button><button className={overlayMode === "single" ? "on" : ""} onClick={() => setOverlayMode("single")}>Selected + construction</button></div>
            </div></div>
            <div className="pb col">
              {overlayMode === "all" && <>
                <div className="legendtoggle">{overlaySeries.map(s => <span key={s.name} className={"toggle" + (hidden.has(s.name) ? "" : " on")} onClick={() => toggle(s.name)}>{s.name}</span>)}</div>
                <Chart series={overlaySeries} hidden={hidden} xLabel={spec.x_label} yLabel={spec.y_label} logX={spec.id === "beam"} logY={spec.id === "beam"} height={420} />
              </>}
              {overlayMode === "single" && curve && (
                <>
                  <div className="row spread">
                    <div className="row"><b>{curve.name}</b>
                      {spec.id === "scb" && (pickMode === "inflection" ? <button className="btn sm" onClick={() => setPickMode(null)}>Cancel</button> : <><button className="btn sm" onClick={() => setPickMode("inflection")}>Pick inflection point</button>{selFile?.picks?.inflection != null && <button className="btn sm ghost" onClick={() => clearPick("inflection")}>Use automatic</button>}</>)}
                      {spec.supports_trim && (pickMode === "trim" ? <button className="btn sm" onClick={() => setPickMode(null)}>Cancel</button> : <><button className="btn sm" onClick={() => setPickMode("trim")}>Trim beginning</button>{selFile?.trim_x != null && <button className="btn sm ghost" onClick={() => clearPick("trim")}>Undo trim ({selFile.trim_x.toFixed(3)} mm)</button>}</>)}
                      {spec.id === "hamburg" && ["strip_left", "creep_left", "strip_right", "creep_right"].map(k => <button key={k} className={"btn sm" + (pickMode === k ? " primary" : "")} onClick={() => setPickMode(pickMode === k ? null : k)}>{k.replace("_", " ")}</button>)}
                      {spec.id === "hamburg" && Object.keys(selFile?.picks || {}).length > 0 && <button className="btn sm ghost" onClick={async () => { await api.updateFile(id, sel!, { clear_picks: true }); await reload(); }}>Use automatic slopes</button>}
                    </div>
                    <div className="legendtoggle">{[...curve.series, ...curve.overlays].map(s => <span key={s.name} className={"toggle" + (hidden.has(s.name) ? "" : " on")} onClick={() => toggle(s.name)}>{s.name}</span>)}</div>
                  </div>
                  {pickMode && <div className="alert info">{pickHint[pickMode]} — click directly on the chart.</div>}
                  <Chart series={curve.series} overlays={curve.overlays} hidden={hidden} xLabel={curve.x_label} yLabel={curve.y_label} logX={curve.log_x} logY={curve.log_y} height={440}
                    shades={[...(curve.shade && !hidden.has(curve.shade.name) ? [{ ...curve.shade, color: "#1f4e79" }] : []), ...(curve.shade_tail && !hidden.has(curve.shade_tail.name) ? [{ ...curve.shade_tail, color: "#c00000" }] : [])]}
                    bands={curve.extrapolated_from ? [{ x0: curve.extrapolated_from, x1: curve.x_max || 20000, label: "extrapolated" }] : undefined}
                    onClick={pickMode ? doPick : undefined} />
                  {curve.secondary && <><h4>{curve.secondary.title}</h4><Chart series={curve.secondary.series} xLabel={curve.secondary.x_label} yLabel={curve.secondary.y_label} height={300} /></>}
                  {curve.extrapolated_from && <div className="tiny muted">Shaded region: the reported rut at 20,000 passes is the fitted polynomial extrapolated beyond the last measured pass ({curve.extrapolated_from.toLocaleString()}). This reproduces v2.</div>}
                </>
              )}
              {overlayMode === "single" && !curve && <div className="muted small">Select an analysed specimen in the table to see its construction.</div>}
            </div>
          </div>

          {spec.id !== "hamburg" && st.table.stats && <div className="panel"><div className="ph"><h3>Statistics</h3><span className="tiny muted">mean ± std, COV — same statistics as the v2 report; badges past {covWarn}% COV</span></div><div className="pb"><StatsPanel table={st.table} covWarn={covWarn} /></div></div>}

          <div className="panel"><div className="ph"><h3><span className="step">5</span>Export</h3></div>
            <div className="pb col">
              <div className="row">
                <label className="f"><span>Format</span><select className="i" value={fmtSel} onChange={e => setFmtSel(e.target.value)}><option value="xlsx">Excel summary (.xlsx)</option><option value="pdf">PDF summary</option><option value="csv">CSV table</option><option value="png">Chart image (.png)</option></select></label>
                {spec.id === "ideal_ct" && <label className="f"><span>Pass/fail criteria (optional)</span><input className="i" type="number" step="any" defaultValue={st.options?.passfail ?? ""} onBlur={e => saveOption("passfail", e.target.value)} /></label>}
                {spec.id === "apa" && <><label className="f"><span>Hose pressure (psi)</span><input className="i" defaultValue={st.options?.hose_pressure ?? ""} onBlur={e => saveOption("hose_pressure", e.target.value)} /></label><label className="f"><span>Wheel load (lb)</span><input className="i" defaultValue={st.options?.wheel_load ?? ""} onBlur={e => saveOption("wheel_load", e.target.value)} /></label></>}
                {spec.id === "cold_scb" && <label className="f"><span>Interpolated tails</span><select className="i" value={tails} onChange={e => setTails(e.target.value)}><option value="all">Include all tails</option><option value="none">Remove all tails</option><option value="select">Only the selected specimens' tails</option></select></label>}
                <button className="btn primary" onClick={doExport} disabled={!exportSel.size || !!busy}>Export {exportSel.size} specimen{exportSel.size === 1 ? "" : "s"}</button>
                <button className="btn" onClick={() => api.openExports().catch(e => toast(e.message, "err"))} title="Every export is also kept in the app's exports folder">Open exports folder</button>
              </div>
              <div className="row">{files.filter(f => f.result).map(f => <label key={f.id} className={"toggle" + (exportSel.has(f.id) ? " on" : "")} onClick={() => setExportSel(s => { const n = new Set(s); n.has(f.id) ? n.delete(f.id) : n.add(f.id); if (spec.single_export && n.size > 1) return new Set([f.id]); return n; })}>{f.specimen_id || f.name}</label>)}</div>
              {spec.single_export && <div className="tiny muted">This report format holds one specimen per sheet (as in v2). Export each specimen separately.</div>}
            </div>
          </div>
        </>
      )}

      {rawOpen && raw && (
        <div className="modalbg" onClick={() => setRawOpen(false)}><div className="modal" onClick={e => e.stopPropagation()}>
          <div className="row spread"><h2>Data points — {selFile?.specimen_id || selFile?.name}</h2><span className="tiny muted">{raw.total.toLocaleString()} rows (after template transforms){raw.rows.length < raw.total ? `, showing every ${Math.ceil(raw.total / raw.rows.length)}th` : ""}</span><button className="btn sm" onClick={() => setRawOpen(false)}>Close</button></div>
          <div className="tw" style={{ maxHeight: "70vh" }}><table className="t"><thead><tr><th>#</th>{raw.columns.map(c => <th key={c} className="n">{c}</th>)}</tr></thead>
            <tbody>{raw.rows.map((r, i) => <tr key={i}><td className="num">{i + 1}</td>{r.map((v, j) => <td key={j} className="n">{fmt(v, { dp: 5 })}</td>)}</tr>)}</tbody></table></div>
        </div></div>
      )}
    </div>
  );
}
