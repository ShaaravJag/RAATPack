import { useCallback, useEffect, useMemo, useState } from "react";
import useEscape from "../lib/useEscape";
import { Link, useParams } from "react-router-dom";
import { api, fmt } from "../lib/api";
import type { CurvePayload, LoadedFile, ModuleSpec, SampleInfo, Settings, Template, WorkspaceState } from "../lib/types";
import Chart from "../components/Chart";
import FileDrop from "../components/FileDrop";
import SpecimenTable from "../components/SpecimenTable";
import ResultsTable from "../components/ResultsTable";
import StatsPanel from "../components/StatsPanel";
import { useToast } from "../components/Toast";

const PROJECT_FIELDS: [string, string][] = [["project", "Project name"], ["mix_type", "Mix type"], ["test_temp", "Test temperature"], ["institution", "Institution"], ["date", "Date tested"], ["technician", "Technician"]];

// The same project is usually run through several modules in a sitting, and these six fields
// only feed the report header. Remember the last set so the next module starts filled in, per
// viewer and per browser — it is a convenience, never the source of truth for a report.
const CARRY_KEY = "raatpack.lastProject";
const readCarry = (): Record<string, string> => {
  try { return JSON.parse(localStorage.getItem(CARRY_KEY) || "{}"); } catch { return {}; }
};
const writeCarry = (p: Record<string, string>) => {
  try { localStorage.setItem(CARRY_KEY, JSON.stringify(p)); } catch { /* private window, or storage off */ }
};

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
  const [proj, setProj] = useState<Record<string, string>>({});
  const [filling, setFilling] = useState<string | null>(null);   // which column is being filled down
  const [sample, setSample] = useState<SampleInfo | null>(null);
  const [autoPicked, setAutoPicked] = useState(false);   // was the template chosen for the user?
  useEscape(() => { if (rawOpen) setRawOpen(false); else if (pickMode) setPickMode(null); });
  const covWarn = settings?.cov_warn_pct ?? 15;

  const reload = useCallback(async () => { if (!id) return; const s = await api.ws(id); setSt(s); return s; }, [id]);
  useEffect(() => { reload().catch(e => toast(e?.message || String(e), "err")); }, [reload]);
  useEffect(() => {
    if (!spec?.template_kind) return;
    api.templates(spec.template_kind).catch(e => { toast(`Could not load the file templates: ${e.message}`, "err"); return [] as Template[]; }).then(ts => {
      setTemplates(ts);
      if (!ts.length) return;
      if (tid && ts.some(t => t.id === tid)) return;
      // prefer this module's own default, then the lab's MTS template for it, then any default
      const needle = spec.short.toLowerCase().replace(/[^a-z]/g, "");
      const norm = (n: string) => n.toLowerCase().replace(/[^a-z]/g, "");
      const pick = ts.find(t => t.name.startsWith("Default") && norm(t.name).includes(needle))
        || ts.find(t => t.name.startsWith("MTS TWSX") && norm(t.name).includes(needle))
        || ts.find(t => t.name.startsWith("Default")) || ts[0];
      // Picking silently is the dangerous part: a wrong-but-plausible template parses to numbers
      // rather than failing, so the report comes out confidently wrong. Say what was chosen.
      if (pick) { setTid(pick.id); setAutoPicked(!norm(pick.name).includes(needle)); }
    });
  }, [spec?.template_kind, spec?.short]);
  useEffect(() => { if (st && sel && st.files.find(f => f.id === sel)?.result) api.curve(id, sel).then(setCurve).catch(() => setCurve(null)); else setCurve(null); }, [st, sel, id]);
  useEffect(() => { if (st && !sel && st.files.length) setSel(st.files[0].id); }, [st, sel]);
  useEffect(() => { if (id) api.samplesInfo(id).then(setSample).catch(() => setSample({ available: false })); }, [id]);
  // Keyed on *which* files have results, not how many: a re-run that repairs a specimen changes
  // neither st.ran nor files.length, so the repaired specimen used to stay out of the report.
  const analysedKey = (st?.files || []).filter(f => f.result && !f.error).map(f => f.id).join(",");
  useEffect(() => {
    if (!st) return;
    const ok = st.files.filter(f => f.result && !f.error).map(f => f.id);
    // These modules put one specimen per report in v2 and the backend still exports only the
    // first file, so pre-selecting them all promised specimens that were silently dropped.
    setExportSel(new Set(spec?.single_export ? ok.slice(0, 1) : ok));
  }, [analysedKey, st?.ran, spec?.single_export]);

  // Project fields are controlled so that Clear empties them and Load session shows what it
  // restored. They were uncontrolled, which left the previous project's name on screen.
  const projSig = JSON.stringify(st?.project ?? {});
  useEffect(() => {
    const carried = readCarry();
    const seeded: Record<string, string> = {};
    for (const [k] of PROJECT_FIELDS)
      // what this module already has, then what the last module was given, then the settings
      seeded[k] = st?.project?.[k] ?? carried[k] ?? (k === "institution" ? settings?.institution ?? ""
                 : k === "technician" ? settings?.technician ?? "" : "");
    setProj(seeded);
  }, [projSig, settings?.institution, settings?.technician]);

  const files = st?.files || [];
  const ran = !!st?.ran;
  const overlaySeries = useMemo(() => files.filter(f => f.preview?.x?.length && !f.error).map(f => ({ name: f.specimen_id || f.name, x: f.preview.x, y: f.preview.y, style: "line" })), [files]);
  if (!spec) return (
    <div className="page"><div className="alert warn row">
      {mods.length ? <>Unknown module <code>{id}</code>.</>
        : <><span className="spin" /> Waiting for the analysis engine — the module list has not
            arrived yet. If this does not clear, use <b>Try again</b> in the sidebar.</>}
    </div></div>);

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
  // One awaited request per specimen, so show progress rather than appearing to hang.
  const fillAll = async (key: string, value: number | null) => {
    setFilling(key);
    try { for (const f of files) await api.updateFile(id, f.id, { inputs: { [key]: value } }); await reload(); }
    catch (e: any) { toast(e.message, "err"); } finally { setFilling(null); }
  };
  // What the operator is asked to click, per module — "inflection point" was shown for Hamburg
  // too, where the thing to pick is a pair of slopes.
  const pickNoun = spec?.id === "hamburg" ? "slope pick" : "inflection point";

  /** Dimensions that are required but blank, as labels rather than database keys.
   *  Counts every file that actually read (n_points > 0), including ones whose last run failed
   *  — those are precisely the specimens the operator still has to fill in. */
  const missingInputs = () => {
    const out: string[] = [];
    const loaded = files.filter(f => f.n_points > 0);
    for (const key of spec?.required_inputs || []) {
      const n = loaded.filter(f => f.inputs?.[key] === null || f.inputs?.[key] === undefined).length;
      if (n) out.push(`${n} specimen${n === 1 ? "" : "s"} missing ${spec?.specimen_inputs.find(i => i.key === key)?.label || key}`);
    }
    return out;
  };

  const run = async () => {
    // Pre-flight: say what is missing once, up front, instead of failing row by row into
    // tooltips that only appear on hover.
    const missing = missingInputs();
    if (missing.length) return toast(`Cannot run yet — ${missing.join("; ")}.`, "err");
    setBusy("Running analysis…");
    try {
      const s = await api.run(id);
      setSt(s);
      const failed = s.files.filter(f => f.error).length;
      const ok = s.files.filter(f => f.result && !f.error).length;
      const picks = s.needs_pick.length;
      if (failed && !ok) toast(`Analysis failed for all ${failed} specimen${failed === 1 ? "" : "s"} — see the messages above the results table.`, "err");
      else if (failed) toast(`${ok} specimen${ok === 1 ? "" : "s"} analysed, ${failed} failed — see the messages above the results table.`, "err");
      else if (picks) toast(`${ok} analysed — ${picks} need${picks === 1 ? "s" : ""} a manual ${pickNoun}.`, "err");
      else toast(`Analysis complete — ${ok} specimen${ok === 1 ? "" : "s"}.`);
      // Put the operator where the picking actually happens: the buttons live in the
      // single-specimen chart, which is not the default view.
      if (picks) { setSel(s.needs_pick[0]); setOverlayMode("single"); }
    } catch (e: any) { toast(e.message, "err"); } finally { setBusy(null); }
  };
  const saveProject = (k: string, v: string) => {
    writeCarry({ ...readCarry(), ...proj, [k]: v });
    return api.updateProject(id, { project: { [k]: v } }).then(setSt).catch(e => toast(e.message, "err"));
  };
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
  const loadSamples = async () => {
    // Replacing real work without warning would be rude; the endpoint resets the workspace.
    if (files.length && !confirm(`Replace the ${files.length} file(s) currently loaded with the bundled sample data?`)) return;
    setBusy("Loading sample data…");
    try {
      const s = await api.samples(id);
      setSt(s);
      setSel(s.files[0]?.id ?? null);
      toast(s.sample_note || `Loaded ${s.files.length} sample specimen(s) — press Run analysis.`);
    } catch (e: any) { toast(e.message, "err"); } finally { setBusy(null); }
  };
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
          {PROJECT_FIELDS.map(([k, lab]) => <label className="f" key={k}><span>{lab}</span>
            <input className="i" type={k === "date" ? "date" : "text"} value={proj[k] ?? ""}
              onChange={e => setProj(pv => ({ ...pv, [k]: e.target.value }))}
              onBlur={e => { if ((st?.project?.[k] ?? "") !== e.target.value) saveProject(k, e.target.value); }} /></label>)}
          {!st?.project?.project && !!readCarry().project && (
            <div className="tiny muted" style={{ gridColumn: "1 / -1" }}>
              Carried over from the last module you filled in — edit any field to change it for this report.
            </div>
          )}
        </div>
      </div>

      <div className="panel"><div className="ph"><h3><span className="step">2</span>Files</h3>
        {spec.template_kind ? <div className="row"><span className="tiny muted">File template</span>
          <select className="i" style={{ width: 300 }} value={tid} onChange={e => { setTid(e.target.value); setAutoPicked(false); }}>{templates.map(t => <option key={t.id} value={t.id}>{t.name}{t.builtin ? "" : " (custom)"}</option>)}</select>
          <Link to="/templates" className="btn sm" title="See how a template reads a file, and check one against a sample">Manage…</Link></div>
          : <span className="tiny muted">Standard IPC Global workbook (sheet 2 “RawData”) — no template needed</span>}
      </div>
        <div className="pb col">
          {spec.template_kind && !!templates.length && (
            <div className={"alert tiny " + (autoPicked ? "warn" : "info")}>
              {autoPicked
                ? <>No template is named for {spec.short}, so <b>{templates.find(t => t.id === tid)?.name}</b> was
                   chosen as a starting point. Check it before you trust the numbers — a template that does not
                   match the file still parses, it just reads the wrong columns or units, and the report comes out
                   wrong rather than empty.</>
                : <>Reading files with <b>{templates.find(t => t.id === tid)?.name}</b>, matched to {spec.short}.
                   {spec.id === "scb" && <> This module's stroke is in <b>metres</b>; the millimetre template parses
                   the same file without complaint and reports values 1000× out.</>} Use <b>Manage…</b> to check a
                   template against one of your files.</>}
            </div>
          )}
          <FileDrop onFiles={addFiles} onIgnored={n => toast(`Skipped ${n.length === 1 ? n[0] : n.length + " files"} — Excel lock files and system files are not data.`, "err")} accept={spec.reader === "beam" || spec.reader === "xy" || spec.reader === "scb" || spec.reader === "four" ? ".xlsx,.csv" : ".xlsx"} disabled={!!busy} />
          {sample?.available && <div className="row" style={{ justifyContent: "space-between" }}>
            <span className="tiny muted">
              No data to hand? {sample.n} sample specimen{sample.n === 1 ? "" : "s"} ship with RAAT-Pack
              {sample.reference_pdf ? <>, together with the report v2 produced from them</> : null}.
            </span>
            <button className="btn sm" onClick={loadSamples} disabled={!!busy}
              title={`Loads ${sample.n} specimen(s) from ${sample.folder}, with their dimensions already filled in`}>
              Load sample data
            </button>
          </div>}
          {spec.supports_trim && <div className="tiny muted">The end of each SCB curve is trimmed automatically at 0.1 kN (v2 rule). Use “Trim beginning” on the chart if the curve has a seating region.</div>}
        </div>
      </div>

      <div className="panel"><div className="ph"><h3><span className="step">3</span>Specimens</h3>
        <div className="row"><span className="tiny muted">* required for the analysis</span><button className="btn primary" disabled={!files.length || !!busy} onClick={run}>{ran ? "Re-run" : "Run analysis"}</button></div></div>
        {!!files.length && missingInputs().length > 0 && <div className="pb"><div className="alert warn">Not ready to run — {missingInputs().join("; ")}.</div></div>}
        <div className="pb"><SpecimenTable spec={spec} files={files} selected={sel} onSelect={setSel} onChange={patchFile} onRemove={async fid => setSt(await api.removeFile(id, fid))} onFill={fillAll} filling={filling} onLoadSamples={sample?.available ? loadSamples : undefined} /></div>
      </div>

      {ran && st?.table && (
        <>
          <div className="panel"><div className="ph"><h3><span className="step">4</span>Results</h3><div className="row"><button className="btn sm" onClick={openRaw} disabled={!sel}>Inspect data points</button></div></div>
            <div className="pb col">
              <ResultsTable table={st.table} covWarn={covWarn} selected={sel} onSelect={setSel} hamburg={spec.id === "hamburg"} />
              {files.filter(f => f.error).length > 0 && <div className="alert err col">
                <b>{files.filter(f => f.error).length} specimen(s) could not be analysed:</b>
                {files.filter(f => f.error).map(f => <div key={f.id}>· <b>{f.specimen_id || f.name}</b> — {f.error}</div>)}
              </div>}
              {st.needs_pick.length > 0 && (spec.id === "hamburg"
                ? <div className="alert warn">Could not determine the creep and stripping slopes automatically for {st.needs_pick.length} specimen(s). The slopes shown are a provisional guess — select the specimen, switch the chart to <b>Selected + construction</b>, and use the <b>pick</b> buttons to set them, exactly as v2 asked.</div>
                : <div className="alert warn">Could not find an inflection point automatically for {st.needs_pick.length} specimen(s) — select the specimen, switch the chart to <b>Selected + construction</b>, then use <b>Pick inflection point</b> (same as v2's prompt).</div>)}
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
                      {spec.supports_pick && spec.id !== "hamburg" && (pickMode === "inflection" ? <button className="btn sm" onClick={() => setPickMode(null)}>Cancel</button> : <><button className="btn sm" onClick={() => setPickMode("inflection")}>Pick inflection point</button>{selFile?.picks?.inflection != null && <button className="btn sm ghost" onClick={() => clearPick("inflection")}>Use automatic</button>}</>)}
                      {spec.supports_trim && (pickMode === "trim" ? <button className="btn sm" onClick={() => setPickMode(null)}>Cancel</button> : <><button className="btn sm" onClick={() => setPickMode("trim")}>Trim beginning</button>{selFile?.trim_x != null && <button className="btn sm ghost" onClick={() => clearPick("trim")}>Undo trim ({selFile.trim_x.toFixed(3)} mm)</button>}</>)}
                      {spec.id === "hamburg" && ([["creep_left", "Pick left creep"], ["strip_left", "Pick left stripping"], ["creep_right", "Pick right creep"], ["strip_right", "Pick right stripping"]] as [string, string][]).map(([k, lab]) => <button key={k} className={"btn sm" + (pickMode === k ? " primary" : "") + (selFile?.picks?.[k] != null ? " ghost" : "")} onClick={() => setPickMode(pickMode === k ? null : k)} title={pickHint[k]}>{lab}{selFile?.picks?.[k] != null ? " ✓" : ""}</button>)}
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
        <div className="modalbg" onClick={() => setRawOpen(false)}><div className="modal" onClick={e => e.stopPropagation()} role="dialog" aria-modal="true">
          <div className="row spread"><h2>Data points — {selFile?.specimen_id || selFile?.name}</h2><span className="tiny muted">{raw.total.toLocaleString()} rows (after template transforms){raw.rows.length < raw.total ? `, showing every ${Math.ceil(raw.total / raw.rows.length)}th` : ""}</span><button className="btn sm" onClick={() => setRawOpen(false)}>Close</button></div>
          <div className="tw" style={{ maxHeight: "70vh" }}><table className="t"><thead><tr><th>#</th>{raw.columns.map(c => <th key={c} className="n">{c}</th>)}</tr></thead>
            <tbody>{raw.rows.map((r, i) => <tr key={i}><td className="num">{i + 1}</td>{r.map((v, j) => <td key={j} className="n">{fmt(v, { dp: 5 })}</td>)}</tr>)}</tbody></table></div>
        </div></div>
      )}
    </div>
  );
}
