import { useEffect, useState } from "react";
import useEscape from "../lib/useEscape";
import { api } from "../lib/api";
import type { Template, Transform } from "../lib/types";
import { useToast } from "../components/Toast";

const KINDS: Record<string, { label: string; channels: [string, string][]; units: Record<string, string[]> }> = {
  xy: { label: "Two-channel (displacement / load) — IDEAL-CT, SCB, HT-IDT, Bond", channels: [["x", "Displacement"], ["y", "Load"]], units: { x: ["mm", "m", "Inches"], y: ["kN", "N", "lb", "kip"] } },
  four: { label: "Four-channel (time / stroke / load / COD) — Cold SCB, DCT", channels: [["time", "Time"], ["stroke", "Stroke"], ["load", "Load"], ["cod", "COD gauge"]], units: { time: ["sec", "min"], stroke: ["mm", "m", "in"], load: ["kN", "N", "lb", "kip"], cod: ["mm", "m", "in"] } },
  beam: { label: "Beam fatigue (cycles / flexural stiffness / modulus)", channels: [["cycles", "Cycles"], ["stiffness", "Flexural stiffness"], ["modulus", "Elastic modulus"]], units: { stiffness: ["MPa"], modulus: ["MPa"] } },
};
// v2 mapping for four-channel transform rows (reproduced): the rows labelled Time/Stroke/COD/Load act on COD/Load/Time/Stroke.
const FOUR_TR: [string, string][] = [["row12", "COD gauge"], ["row15", "Load"], ["row18", "Time"], ["row21", "Stroke"]];
const XY_TR: [string, string][] = [["x", "Displacement"], ["y", "Load"]];

const blank = (kind: string): Partial<Template> => ({ name: "", kind, columns: kind === "four" ? { time: 1, stroke: 2, load: 3, cod: 4 } : kind === "beam" ? { cycles: 1, stiffness: 4, modulus: 5 } : { x: 1, y: 2 }, data_start: 1, data_end: null, delimiter: ",", sheet: 1, transforms: {}, units: kind === "four" ? { time: "sec", stroke: "mm", load: "kN", cod: "mm" } : kind === "beam" ? { stiffness: "MPa", modulus: "MPa" } : { x: "mm", y: "kN" } });

export default function TemplatesPage() {
  const [list, setList] = useState<Template[]>([]);
  const [edit, setEdit] = useState<Partial<Template> | null>(null);
  // A template takes real effort to fill in; losing it to a stray click on the backdrop is not
  // a reasonable outcome, so confirm once anything has been typed.
  const closeEditor = () => { if (!edit?.name || confirm("Discard this template without saving?")) setEdit(null); };
  const [sample, setSample] = useState<File | null>(null);
  const [preview, setPreview] = useState<any>(null);
  const toast = useToast();
  const load = () => api.templates().then(setList);
  useEffect(() => { load(); }, []);
  const tr = (k: string): Transform => (edit?.transforms?.[k] as Transform) || { offset_start: 0, negative: 0, offset_end: 0 };
  const setTr = (k: string, patch: Partial<Transform>) => setEdit(e => e && ({ ...e, transforms: { ...(e.transforms || {}), [k]: { ...tr(k), ...patch } } }));
  const runPreview = async (t = edit) => { if (!sample || !t) return; try { setPreview(await api.previewTemplate(sample, t)); } catch (e: any) { toast(e.message, "err"); } };
  useEffect(() => { if (sample && edit) runPreview(); }, [sample]);
  useEscape(closeEditor, !!edit);
  const save = async () => { if (!edit?.name) return toast("Give the template a name", "err"); try { await api.saveTemplate(edit); toast("Template saved"); setEdit(null); load(); } catch (e: any) { toast(e.message, "err"); } };
  const kind = edit?.kind || "xy";
  const K = KINDS[kind];
  const trRows = kind === "four" ? FOUR_TR : kind === "xy" ? XY_TR : [];

  return (
    <div className="page">
      <div className="pagehead"><div><div className="eyebrow">Setup</div><h1>File templates</h1><p>A template describes where the data sits in a machine's output file: which columns, which row the numbers start on, sign/offset corrections and units. The lab's v2 template library is built in.</p></div>
        <div className="row"><label className="btn">Import v2 template (.xlsx)<input type="file" accept=".xlsx" hidden onChange={async e => { const f = e.target.files?.[0]; if (!f) return; try { await api.importTemplate(f); toast("Imported"); load(); } catch (er: any) { toast(er.message, "err"); } e.target.value = ""; }} /></label>
          <button className="btn primary" onClick={() => setEdit(blank("xy"))}>New template</button></div></div>

      <div className="tw"><table className="t"><thead><tr><th>Name</th><th>Kind</th><th>Columns</th><th>Data starts</th><th>Sheet</th><th>Units</th><th></th></tr></thead>
        <tbody>{list.map(t => <tr key={t.id}><td>{t.name} {t.builtin && <span className="chip n">built-in</span>}</td><td>{t.kind}</td><td className="mono">{Object.entries(t.columns).map(([k, v]) => `${k}:${v}`).join("  ")}</td><td className="n">row {t.data_start}</td><td className="n">{t.sheet}</td><td className="mono">{Object.values(t.units).join(" / ")}</td>
          <td className="row"><button className="btn sm" onClick={() => setEdit({ ...t, transforms: { ...t.transforms } })}>{t.builtin ? "Copy & edit" : "Edit"}</button><a className="btn sm" href={`/api/templates/${t.id}/download`}>Download</a>{!t.builtin && <button className="btn sm danger" onClick={async () => { if (confirm(`Delete “${t.name}”?`)) { await api.deleteTemplate(t.id); load(); } }}>Delete</button>}</td></tr>)}</tbody></table></div>

      {edit && (
        <div className="modalbg" onClick={closeEditor}><div className="modal" onClick={e => e.stopPropagation()} role="dialog" aria-modal="true">
          <div className="row spread"><h2>{edit.id && !edit.builtin ? "Edit template" : "New template"}</h2><button className="btn sm" onClick={closeEditor}>Close</button></div>
          <div className="grid2">
            <div className="col">
              <label className="f"><span>Name</span><input className="i" value={edit.name || ""} onChange={e => setEdit({ ...edit, name: e.target.value })} placeholder="e.g. Pine IDEAL-CT (CSV)" /></label>
              <label className="f"><span>Kind</span><select className="i" value={kind} disabled={!!edit.id} onChange={e => setEdit(blank(e.target.value))}>{Object.entries(KINDS).map(([k, v]) => <option key={k} value={k}>{v.label}</option>)}</select></label>
              <h4>Columns (1-based) &amp; units</h4>
              {K.channels.map(([k, lab]) => <div className="row" key={k}><label className="f" style={{ flex: 1 }}><span>{lab} column</span><input className="i" type="number" min={1} value={edit.columns?.[k] ?? 1} onChange={e => setEdit({ ...edit, columns: { ...(edit.columns || {}), [k]: Number(e.target.value) } })} /></label>
                {K.units[k] && <label className="f" style={{ flex: 1 }}><span>{lab} units</span><select className="i" value={edit.units?.[k] || K.units[k][0]} onChange={e => setEdit({ ...edit, units: { ...(edit.units || {}), [k]: e.target.value } })}>{K.units[k].map(u => <option key={u}>{u}</option>)}</select></label>}</div>)}
              <div className="row"><label className="f" style={{ flex: 1 }}><span>Data starts at row</span><input className="i" type="number" min={1} value={edit.data_start || 1} onChange={e => setEdit({ ...edit, data_start: Number(e.target.value) })} /></label>
                <label className="f" style={{ flex: 1 }}><span>Sheet (workbooks)</span><input className="i" type="number" min={1} value={edit.sheet || 1} onChange={e => setEdit({ ...edit, sheet: Number(e.target.value) })} /></label>
                <label className="f" style={{ flex: 1 }}><span>CSV delimiter</span><input className="i" value={edit.delimiter || ","} onChange={e => setEdit({ ...edit, delimiter: e.target.value })} /></label></div>
              {trRows.length > 0 && <><h4>Corrections {kind === "four" && <span className="tiny muted" style={{ textTransform: "none", letterSpacing: 0 }}>(applied exactly as v2 did)</span>}</h4>
                {trRows.map(([k, lab]) => <div className="row" key={k} style={{ fontSize: ".86rem" }}><b style={{ width: 110 }}>{lab}</b>
                  <label className="toggle"><input type="checkbox" checked={!!tr(k).offset_start} onChange={e => setTr(k, { offset_start: e.target.checked ? 1 : 0 })} /> offset from start</label>
                  <label className="toggle"><input type="checkbox" checked={!!tr(k).negative} onChange={e => setTr(k, { negative: e.target.checked ? 1 : 0 })} /> negative</label>
                  <label className="toggle"><input type="checkbox" checked={!!tr(k).offset_end} onChange={e => setTr(k, { offset_end: e.target.checked ? 1 : 0 })} /> offset from end</label></div>)}
                <div className="tiny muted">start: subtract the first value · negative: flip sign · end: subtract the last value. Combinations behave as in v2 (e.g. start+negative = −(x − x₁)).</div></>}
              <div className="row"><button className="btn primary" onClick={save}>Save template</button><button className="btn" onClick={() => runPreview()} disabled={!sample}>Re-check preview</button></div>
            </div>
            <div className="col">
              <h4>Check against a sample file</h4>
              <input className="i" type="file" accept=".xlsx,.csv" onChange={e => setSample(e.target.files?.[0] || null)} />
              {preview && <>
                {preview.error ? <div className="alert err">{preview.error}</div> : <div className="alert ok">Parsed {preview.parsed?.n?.toLocaleString()} rows. {preview.parsed?.x_max != null && <>Max x = {preview.parsed.x_max.toFixed(3)}, max y = {preview.parsed.y_max.toFixed(3)}</>}</div>}
                <div className="tiny muted">First rows of the file ({preview.sheets?.length ? `sheets: ${preview.sheets.join(", ")}` : "CSV"}) — row numbers as the template sees them:</div>
                <div className="tw" style={{ maxHeight: 340 }}><table className="t"><thead><tr><th>row</th>{(preview.grid[0] || []).map((_: any, i: number) => <th key={i} className="n">{i + 1}</th>)}</tr></thead>
                  <tbody>{preview.grid.map((r: string[], i: number) => <tr key={i} style={i + 1 >= (edit.data_start || 1) ? {} : { opacity: .45 }}><td className="num">{i + 1}</td>{r.map((c, j) => <td key={j} className="n" style={{ maxWidth: 110, overflow: "hidden", textOverflow: "ellipsis" }}>{c}</td>)}</tr>)}</tbody></table></div>
                {preview.parsed && !preview.error && <div className="tiny mono">parsed head: {JSON.stringify(preview.parsed, (k, v) => typeof v === "number" ? Number(v.toFixed(4)) : v).slice(0, 400)}</div>}
              </>}
            </div>
          </div>
        </div></div>
      )}
    </div>
  );
}
