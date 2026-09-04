import { useEffect, useMemo, useState } from "react";
import { api, fmt } from "../lib/api";
import type { Settings } from "../lib/types";
import Chart from "../components/Chart";
import FileDrop from "../components/FileDrop";
import { useToast } from "../components/Toast";

const CURVES: [string, string, string][] = [["ea", "AMPT — Arrhenius (EA) shifting", "AASHTO R62 / R84 master curve from the AMPT data"], ["vts", "VTS shifting", "MEPDG viscosity–temperature shifting (needs binder A & VTS)"], ["free", "No-constraints shifting", "Free per-isotherm shift factors"], ["witczak", "Witczak prediction equation", "NCHRP 1-37A predicted E* (needs gradation + binder)"], ["hirsch_ea", "Hirsch model — EA shifting", "From binder G* (needs Hirsch file)"], ["hirsch_vts", "Hirsch model — VTS shifting", "From binder G* (needs Hirsch file + binder)"]];
const TEMP_SLOTS = ["Low", "Intermediate", "High"];

export default function DynamicModulusPage({ settings }: { settings: Settings | null }) {
  const toast = useToast();
  const [st, setSt] = useState<any>(null);
  const [busy, setBusy] = useState<string | null>(null);
  const [vol, setVol] = useState({ Gmm: "", Gsb: "", air_voids: "", ac_pct: "" });
  const [binderTab, setBinderTab] = useState<"pg" | "dsr" | "penetration" | "rotational" | "manual">("pg");
  const [rows, setRows] = useState<string[][]>([["", "", ""], ["", "", ""], ["", "", ""], ["", "", ""]]);
  const [grade, setGrade] = useState("PG 64-22");
  const [manual, setManual] = useState({ A: "", VTS: "" });
  const [slots, setSlots] = useState<(string | null)[][]>([[null, null, null], [null, null, null], [null, null, null]]);
  const [temps, setTemps] = useState<(number | null)[][]>([[null, null, null], [null, null, null], [null, null, null]]);
  const [wit, setWit] = useState({ Gb: "1.03", passing200: "", retained34: "", retained38: "", retained4: "" });
  const [rad, setRad] = useState(false);
  const [sel, setSel] = useState<string[]>(["ea"]);
  const [ref, setRef] = useState("20");
  const [tsrc, setTsrc] = useState("target");
  const [view, setView] = useState<string>("ea");
  const [dataView, setDataView] = useState<number>(-1);   // -1 average, 0..2 replicate
  const reload = () => api.dm().then(setSt).catch(e => toast(String(e), "err"));
  useEffect(() => { reload(); }, []);
  useEffect(() => { if (st?.assignment) { setSlots(st.assignment.slots); setTemps(st.assignment.target_temps_c); } if (st?.volumetrics && vol.Gmm === "") setVol({ Gmm: String(st.volumetrics.Gmm), Gsb: String(st.volumetrics.Gsb), air_voids: String(st.volumetrics.air_voids), ac_pct: String(st.volumetrics.ac_pct) }); }, [st?.assignment, st?.volumetrics]);
  const wrap = async (label: string, fn: () => Promise<any>) => { setBusy(label); try { const r = await fn(); setSt(r); return r; } catch (e: any) { toast(e.message, "err"); } finally { setBusy(null); } };
  const files: any[] = st?.files || [];
  const curves: Record<string, any> = st?.curves || {};
  const cur = curves[view];
  const avg = st?.avg;
  const autoAssign = () => {
    // group files by replicate token (#1/#2/#3) and temperature; fall back to sort order
    const byRep: Record<string, any[]> = {};
    files.forEach(f => { const m = /#(\d+)/.exec(f.name); const k = m ? m[1] : "1"; (byRep[k] ||= []).push(f); });
    const reps = Object.keys(byRep).sort().slice(0, 3);
    const ns: (string | null)[][] = [[null, null, null], [null, null, null], [null, null, null]];
    const nt: (number | null)[][] = [[null, null, null], [null, null, null], [null, null, null]];
    reps.forEach((r, i) => { const fs = byRep[r].slice().sort((a, b) => (a.guess_c ?? 0) - (b.guess_c ?? 0)).slice(0, 3); fs.forEach((f, j) => { ns[i][j] = f.id; nt[i][j] = f.guess_c ?? f.target_temp_c_file ?? null; }); });
    setSlots(ns); setTemps(nt);
  };
  const tableRows = useMemo(() => { if (!avg) return []; return dataView < 0 ? avg.rows : (avg.samples[dataView]?.rows || []); }, [avg, dataView]);
  const bsPoly = dataView < 0 ? avg?.blackspace_poly : avg?.samples?.[dataView]?.blackspace_poly;
  const bsRsq = dataView < 0 ? avg?.blackspace_rsq : avg?.samples?.[dataView]?.blackspace_rsq;
  const bsFit = useMemo(() => { if (!bsPoly || !tableRows.length) return null; const xs = tableRows.map((r: any) => r.logE).sort((a: number, b: number) => a - b); return { x: xs, y: xs.map((x: number) => bsPoly[0] * x * x + bsPoly[1] * x + bsPoly[2]) }; }, [bsPoly, tableRows]);

  return (
    <div className="page">
      <div className="pagehead"><div><div className="eyebrow">AASHTO T342 · R62 · R84</div><h1>Dynamic Modulus</h1><p>Build master curves from AMPT summary files. Steps mirror v2: volumetrics → binder → AMPT data → optional Witczak / Hirsch → master curves → export.</p></div>
        <div className="row"><button className="btn sm danger" onClick={async () => { if (confirm("Clear the Dynamic Modulus session?")) setSt(await api.dmReset()); }}>Clear</button></div></div>
      {busy && <div className="alert info row"><span className="spin" /> {busy}</div>}

      <div className="panel"><div className="ph"><h3><span className="step">0</span>Project information</h3></div>
        <div className="pb grid3">{([["project", "Project name"], ["mix_type", "Mix type"], ["institution", "Institution"], ["date", "Date tested"], ["technician", "Technician"]] as [string, string][]).map(([k, lab]) => <label className="f" key={k}><span>{lab}</span><input className="i" defaultValue={st?.project?.[k] ?? (k === "institution" ? settings?.institution ?? "" : "")} onBlur={e => api.dmProject({ [k]: e.target.value }).then(setSt)} /></label>)}</div></div>

      <div className="grid2">
        <div className="panel"><div className="ph"><h3><span className="step">1</span>Volumetrics → E*max (Hirsch)</h3></div>
          <div className="pb col">
            <div className="grid2">{([["Gmm", "Gmm"], ["Gsb", "Gsb"], ["air_voids", "Air voids (%)"], ["ac_pct", "AC by mix weight (%)"]] as [keyof typeof vol, string][]).map(([k, lab]) => <label className="f" key={k}><span>{lab}</span><input className="i" type="number" step="any" value={vol[k]} onChange={e => setVol({ ...vol, [k]: e.target.value })} /></label>)}</div>
            <div className="row"><button className="btn primary" onClick={() => wrap("Calculating E*max…", () => api.dmVolumetrics({ Gmm: +vol.Gmm, Gsb: +vol.Gsb, air_voids: +vol.air_voids, ac_pct: +vol.ac_pct }))} disabled={Object.values(vol).some(v => v === "")}>Calculate E*max</button>
              {st?.volumetrics && <dl className="kv"><dt>Gmb</dt><dd>{fmt(st.volumetrics.Gmb, { dp: 4 })}</dd><dt>VMA</dt><dd>{fmt(st.volumetrics.VMA, { dp: 2 })} %</dd><dt>VFA</dt><dd>{fmt(st.volumetrics.VFA, { dp: 2 })} %</dd><dt>E*max</dt><dd><b>{fmt(st.volumetrics.EMAX, { dp: 0 })} psi</b></dd></dl>}</div>
          </div></div>

        <div className="panel"><div className="ph"><h3><span className="step">2</span>Binder A &amp; VTS <span className="tiny muted" style={{ fontWeight: 400 }}>(for VTS / Witczak / Hirsch-VTS)</span></h3></div>
          <div className="pb col">
            <div className="tabs">{(["pg", "dsr", "penetration", "rotational", "manual"] as const).map(t => <button key={t} className={binderTab === t ? "on" : ""} onClick={() => setBinderTab(t)}>{{ pg: "PG grade (NCHRP 1-37A)", dsr: "DSR", penetration: "Penetration", rotational: "Rotational visc.", manual: "Manual" }[t]}</button>)}</div>
            {binderTab === "pg" && <div className="row"><select className="i" style={{ width: 200 }} value={grade} onChange={e => setGrade(e.target.value)}>{(st?.pg_grades || []).map((g: string) => <option key={g}>{g}</option>)}</select><button className="btn" onClick={() => wrap("…", () => api.dmBinder("pg", { grade }))}>Use grade</button></div>}
            {(binderTab === "dsr" || binderTab === "penetration" || binderTab === "rotational") && <>
              <div className="tw"><table className="t"><thead><tr>{(binderTab === "dsr" ? ["Temperature (°C)", "G* (Pa)", "δ (degrees)"] : binderTab === "penetration" ? ["Temperature (°F)", "Penetration (0.1 mm)"] : ["Temperature (°F)", "Viscosity (cP)"]).map(h => <th key={h}>{h}</th>)}</tr></thead>
                <tbody>{rows.map((r, i) => <tr key={i}>{r.slice(0, binderTab === "dsr" ? 3 : 2).map((v, j) => <td key={j}><input className="i" type="number" step="any" value={v} onChange={e => setRows(rs => rs.map((rr, ii) => ii === i ? rr.map((vv, jj) => jj === j ? e.target.value : vv) : rr))} /></td>)}</tr>)}</tbody></table></div>
              <div className="row"><button className="btn sm" onClick={() => setRows(r => [...r, ["", "", ""]])}>+ row</button><button className="btn" onClick={() => wrap("Fitting…", () => api.dmBinder(binderTab, { rows: rows.filter(r => r[0] !== "" && r[1] !== "").map(r => r.slice(0, binderTab === "dsr" ? 3 : 2).map(Number)) }))}>Fit A &amp; VTS</button></div></>}
            {binderTab === "manual" && <div className="row"><label className="f"><span>A</span><input className="i" type="number" step="any" value={manual.A} onChange={e => setManual({ ...manual, A: e.target.value })} /></label><label className="f"><span>VTS</span><input className="i" type="number" step="any" value={manual.VTS} onChange={e => setManual({ ...manual, VTS: e.target.value })} /></label><button className="btn" onClick={() => wrap("…", () => api.dmBinder("manual", { A: +manual.A, VTS: +manual.VTS }))}>Use</button></div>}
            {st?.binder && <div className="row"><span className="chip info">{st.binder.source}</span><dl className="kv"><dt>A</dt><dd>{fmt(st.binder.A, { dp: 4 })}</dd><dt>VTS</dt><dd>{fmt(st.binder.VTS, { dp: 4 })}</dd>{st.binder.rsq != null && <><dt>R²</dt><dd>{fmt(st.binder.rsq, { dp: 4 })}</dd></>}</dl></div>}
            {st?.binder?.log_temp?.length > 0 && <Chart height={220} series={[{ name: "data", x: st.binder.log_temp, y: st.binder.loglog_visc, style: "marker" }, { name: "fit", x: st.binder.log_temp, y: st.binder.log_temp.map((x: number) => st.binder.A + st.binder.VTS * x), style: "dashed" }]} xLabel="log Temp (°R)" yLabel="log log viscosity (cP)" />}
          </div></div>
      </div>

      <div className="panel"><div className="ph"><h3><span className="step">3</span>AMPT summary files</h3><span className="tiny muted">the “…Sum.csv” files, one per specimen per temperature</span></div>
        <div className="pb col">
          <FileDrop onFiles={fs => wrap("Reading AMPT files…", async () => { const r = await api.dmFiles(fs); if (r.errors?.length) toast(r.errors.join("; "), "err"); return r; })} accept=".csv" label="Drop the AMPT *Sum.csv files here" />
          {files.length > 0 && <>
            <div className="tw"><table className="t"><thead><tr><th>File</th><th>Identification</th><th className="n">Frequencies</th><th className="n">Temp in file (°C)</th><th></th></tr></thead>
              <tbody>{files.map(f => <tr key={f.id}><td>{f.name}</td><td className="mono">{f.identification}</td><td className="n">{f.n}</td><td className="n">{f.target_temp_c_file ?? "—"}</td><td><button className="btn sm ghost danger" onClick={() => wrap("…", () => api.dmRemoveFile(f.id))}>✕</button></td></tr>)}</tbody></table></div>
            <div className="row spread"><h4>Assign files to replicates &amp; temperatures</h4><button className="btn sm" onClick={autoAssign}>Auto-assign from file names</button></div>
            <div className="tw"><table className="t"><thead><tr><th>Replicate</th>{TEMP_SLOTS.map(t => <th key={t}>{t} temperature file</th>)}{TEMP_SLOTS.map(t => <th key={t + "t"} className="n">{t} target °C</th>)}</tr></thead>
              <tbody>{[0, 1, 2].map(i => <tr key={i}><td>Sample {i + 1}</td>{[0, 1, 2].map(j => <td key={j}><select className="i" value={slots[i][j] || ""} onChange={e => setSlots(s => s.map((r, ii) => ii === i ? r.map((v, jj) => jj === j ? (e.target.value || null) : v) : r))}><option value="">—</option>{files.map(f => <option key={f.id} value={f.id}>{f.name}</option>)}</select></td>)}
                {[0, 1, 2].map(j => <td key={j} className="n"><input className="i" type="number" step="any" style={{ width: 80 }} value={temps[i][j] ?? ""} onChange={e => setTemps(t => t.map((r, ii) => ii === i ? r.map((v, jj) => jj === j ? (e.target.value === "" ? null : Number(e.target.value)) : v) : r))} /></td>)}</tr>)}</tbody></table></div>
            <div className="tiny muted">Target temperatures are rounded to whole °F for the shifting, exactly as v2 did. The file's own “Target test temperature” row is shown for reference only (v2 used the value you type).</div>
            <div><button className="btn primary" onClick={() => wrap("Building data table…", () => api.dmAssign(slots, temps))} disabled={!slots.flat().some(Boolean)}>Load project files</button></div>
          </>}
          {avg && <>
            <div className="row spread"><div className="tabs" style={{ border: 0 }}>{[-1, 0, 1, 2].map(k => <button key={k} className={dataView === k ? "on" : ""} onClick={() => setDataView(k)} disabled={k >= 0 && !avg.samples[k]?.rows?.length}>{k < 0 ? "Average" : `Sample ${k + 1}`}</button>)}</div>
              {avg.warn_unequal_freqs && <span className="chip warn">files have different frequency sets — missing frequencies are skipped</span>}</div>
            <div className="grid2">
              <div className="tw" style={{ maxHeight: 360 }}><table className="t"><thead><tr><th className="n">Target °F</th><th className="n">Chamber °F</th><th className="n">Freq (Hz)</th><th className="n">E* (psi)</th><th className="n">Phase (°)</th><th className="n">log E*</th>{dataView < 0 && <><th className="n">E* COV %</th><th className="n">Phase COV %</th></>}</tr></thead>
                <tbody>{tableRows.map((r: any, i: number) => <tr key={i}><td className="n">{fmt(r.target_temp_f, { dp: 0 })}</td><td className="n">{fmt(r.chamber_temp_f, { dp: 1 })}</td><td className="n">{fmt(r.frequency, { dp: 2 })}</td><td className="n">{fmt(r.E_psi, { dp: 0 })}</td><td className="n">{fmt(r.phase, { dp: 1 })}</td><td className="n">{fmt(r.logE, { dp: 4 })}</td>{dataView < 0 && <><td className="n">{fmt(r.cov_E, { dp: 1 })}</td><td className="n">{fmt(r.cov_phase, { dp: 1 })}</td></>}</tr>)}</tbody></table></div>
              <div><Chart height={340} title={`Black space — ${dataView < 0 ? "average" : `sample ${dataView + 1}`} (R² ${fmt(bsRsq, { dp: 4 })})`} series={[{ name: "data", x: tableRows.map((r: any) => r.logE), y: tableRows.map((r: any) => r.phase), style: "marker" }, ...(bsFit ? [{ name: "2nd-order fit", x: bsFit.x, y: bsFit.y, style: "line" }] : [])]} xLabel="log E* (psi)" yLabel="Phase angle (°)" /></div>
            </div>
          </>}
        </div></div>

      <div className="grid2">
        <div className="panel"><div className="ph"><h3><span className="step">4a</span>Witczak inputs <span className="tiny muted" style={{ fontWeight: 400 }}>(optional)</span></h3></div>
          <div className="pb col"><div className="grid3">{([["Gb", "Gb"], ["passing200", "% passing #200"], ["retained34", "% retained 3/4\""], ["retained38", "% retained 3/8\""], ["retained4", "% retained #4"]] as [keyof typeof wit, string][]).map(([k, lab]) => <label className="f" key={k}><span>{lab}</span><input className="i" type="number" step="any" value={wit[k]} onChange={e => setWit({ ...wit, [k]: e.target.value })} /></label>)}</div>
            <div className="row"><button className="btn" disabled={!st?.volumetrics || !st?.binder || !avg} onClick={() => wrap("Witczak…", () => api.dmWitczak({ Gb: +wit.Gb, passing200: +wit.passing200, retained34: +wit.retained34, retained38: +wit.retained38, retained4: +wit.retained4 }))}>Predict E* (Witczak)</button>{st?.witczak && <dl className="kv"><dt>δ</dt><dd>{fmt(st.witczak.delta, { dp: 4 })}</dd><dt>α</dt><dd>{fmt(st.witczak.alpha, { dp: 4 })}</dd></dl>}</div>
            {!st?.volumetrics || !st?.binder || !avg ? <div className="tiny muted">Needs E*max, binder A/VTS and loaded AMPT data.</div> : null}</div></div>
        <div className="panel"><div className="ph"><h3><span className="step">4b</span>Hirsch binder G* file <span className="tiny muted" style={{ fontWeight: 400 }}>(optional)</span></h3></div>
          <div className="pb col"><div className="tiny muted">Workbook, first sheet: columns temperature (°F), frequency, G* (psi).</div>
            <label className="toggle" style={{ alignSelf: "flex-start" }}><input type="checkbox" checked={rad} onChange={e => setRad(e.target.checked)} /> frequency column is in rad/s (divide by 2π)</label>
            <input className="i" type="file" accept=".xlsx" disabled={!st?.volumetrics} onChange={e => { const f = e.target.files?.[0]; if (f) wrap("Reading Hirsch file…", () => api.dmHirsch(f, rad)); e.target.value = ""; }} />
            {st?.hirsch && <span className="chip ok">{st.hirsch.E.length} rows loaded</span>}{!st?.volumetrics && <div className="tiny muted">Calculate E*max first (Hirsch needs VMA and VFA).</div>}</div></div>
      </div>

      <div className="panel"><div className="ph"><h3><span className="step">5</span>Master curves</h3></div>
        <div className="pb col">
          <div className="row" style={{ alignItems: "flex-start" }}>
            <div className="col" style={{ flex: 1 }}>{CURVES.map(([k, lab, desc]) => <label key={k} className="row" style={{ gap: 8 }}><input type="checkbox" checked={sel.includes(k)} onChange={e => setSel(s => e.target.checked ? [...s, k] : s.filter(x => x !== k))} /><b>{lab}</b><span className="tiny muted">{desc}</span></label>)}</div>
            <div className="col"><label className="f"><span>Reference temperature (°C)</span><input className="i" type="number" step="any" value={ref} onChange={e => setRef(e.target.value)} /></label>
              <label className="f"><span>Temperature used for shifting</span><select className="i" value={tsrc} onChange={e => setTsrc(e.target.value)}><option value="target">Target temperature</option><option value="chamber">Measured chamber temperature</option></select></label>
              <button className="btn primary" disabled={!avg || !st?.volumetrics || !sel.length} onClick={() => wrap("Fitting master curves…", async () => { const r = await api.dmRun(sel, +ref, tsrc); if (r.errors && Object.keys(r.errors).length) toast(Object.entries(r.errors).map(([k, v]) => `${k}: ${v}`).join(" | "), "err"); setView(sel.find(k => r.curves[k]) || "ea"); return r; })}>Run master curves</button></div>
          </div>
          {Object.keys(curves).length > 0 && <>
            <div className="tabs">{Object.keys(curves).map(k => <button key={k} className={view === k ? "on" : ""} onClick={() => setView(k)}>{st.curve_names[k]}</button>)}</div>
            {cur && <>
              <div className="grid2">
                <Chart height={420} title={cur.title} logX logY series={[{ name: "Measured E*", x: cur.reduced_frequency, y: cur.E_measured, style: "marker" }, { name: "Predicted E*", x: cur.grid_x, y: cur.grid_y, style: "line" }]} xLabel="Reduced frequency (Hz)" yLabel="Dynamic modulus (psi)" />
                <Chart height={420} title={`Phase angle (poly R² ${fmt(cur.phase_rsq, { dp: 4 })})`} series={[{ name: "Phase angle", x: cur.reduced, y: cur.phase, style: "marker" }, { name: "5th-order fit", x: cur.reduced, y: cur.phase_fit, style: "dashed" }]} xLabel="Reduced frequency (log)" yLabel="Phase angle (°)" />
              </div>
              <div className="grid2">
                <div className="col"><h4>Fit</h4><dl className="kv">{Object.entries(cur.params).map(([k, v]: any) => <><dt key={k + "k"}>{k}</dt><dd key={k + "v"}>{fmt(v, { dp: 4 })}</dd></>)}<dt>Σ error²</dt><dd>{fmt(cur.sse, { dp: 5 })}</dd></dl>
                  <h4>Shift factors (log a<sub>T</sub>)</h4><dl className="kv">{Object.entries(cur.shift_factors).map(([k, v]: any) => <><dt key={k + "k"}>{k} °F</dt><dd key={k + "v"}>{fmt(v, { dp: 4 })}</dd></>)}</dl>
                  <div className="row"><button className="btn primary" onClick={() => wrap("Exporting…", async () => { await api.dmExport(view, "xlsx"); return st; })}>Export Excel</button><button className="btn" onClick={() => wrap("Exporting…", async () => { await api.dmExport(view, "pdf"); return st; })}>Export PDF</button><button className="btn" onClick={() => wrap("Exporting…", async () => { await api.dmExport(view, "png"); return st; })}>Chart PNG</button><button className="btn" onClick={() => api.openExports().catch(e => toast(e.message, "err"))}>Open exports folder</button></div></div>
                <div className="tw" style={{ maxHeight: 380 }}><table className="t"><thead><tr><th className="n">Temp °F</th><th className="n">Freq (Hz)</th><th className="n">Reduced freq</th><th className="n">E* (psi)</th><th className="n">log E* meas.</th><th className="n">log E* pred.</th><th className="n">Phase</th></tr></thead>
                  <tbody>{cur.frequency.map((_: any, i: number) => <tr key={i}><td className="n">{fmt(cur.temperature_f[i], { dp: 0 })}</td><td className="n">{fmt(cur.frequency[i], { dp: 2 })}</td><td className="n">{cur.reduced_frequency[i]?.toExponential(2)}</td><td className="n">{fmt(cur.E_measured[i], { dp: 0 })}</td><td className="n">{fmt(cur.logE_measured[i], { dp: 4 })}</td><td className="n">{fmt(cur.logE_predicted[i], { dp: 4 })}</td><td className="n">{fmt(cur.phase[i], { dp: 1 })}</td></tr>)}</tbody></table></div>
              </div>
            </>}
          </>}
        </div></div>
    </div>
  );
}
