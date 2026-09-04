import type { Field, LoadedFile, ModuleSpec } from "../lib/types";

interface Props { spec: ModuleSpec; files: LoadedFile[]; selected: string | null; onSelect: (id: string) => void;
  onChange: (fid: string, patch: { specimen_id?: string; inputs?: Record<string, number | null> }) => void; onRemove: (fid: string) => void; onFill: (key: string, value: number | null) => void; }

export default function SpecimenTable({ spec, files, selected, onSelect, onChange, onRemove, onFill }: Props) {
  const inputs: Field[] = spec.specimen_inputs;
  const req = new Set(spec.required_inputs);
  return (
    <div className="tw">
      <table className="t">
        <thead><tr>
          <th style={{ width: 28 }}>#</th><th>File</th><th>Specimen ID</th>
          {inputs.map(f => <th key={f.key} className="n">{f.label}{req.has(f.key) && <span title="required" style={{ color: "var(--accent)" }}> *</span>}
            <button className="btn ghost sm" title="Copy first row's value to all rows" style={{ padding: "0 4px", marginLeft: 4 }} onClick={() => { const v = files[0]?.inputs?.[f.key]; onFill(f.key, v ?? null); }}>⇣</button></th>)}
          <th>Status</th><th></th>
        </tr></thead>
        <tbody>
          {files.map((f, i) => (
            <tr key={f.id} className={selected === f.id ? "sel" : ""} onClick={() => onSelect(f.id)}>
              <td className="num">{i + 1}</td>
              <td title={f.name} style={{ maxWidth: 220, overflow: "hidden", textOverflow: "ellipsis" }}>{f.name}</td>
              <td><input className="i" value={f.specimen_id} placeholder={`Sample #${i + 1}`} onClick={e => e.stopPropagation()} onChange={e => onChange(f.id, { specimen_id: e.target.value })} /></td>
              {inputs.map(fl => (
                <td key={fl.key} className="n">
                  <input className={"i" + (req.has(fl.key) ? " req" : "")} type="number" step="any" placeholder={req.has(fl.key) ? "required" : "—"}
                    value={f.inputs?.[fl.key] ?? ""} onClick={e => e.stopPropagation()}
                    onChange={e => onChange(f.id, { inputs: { [fl.key]: e.target.value === "" ? null : Number(e.target.value) } })} />
                </td>))}
              <td>{f.error ? <span className="chip crit" title={f.error}>error</span> : f.result ? (f.result.needs_pick ? <span className="chip warn">pick needed</span> : <span className="chip ok">done</span>) : <span className="chip n">{f.n_points} pts</span>}</td>
              <td><button className="btn ghost sm danger" onClick={e => { e.stopPropagation(); onRemove(f.id); }} title="Remove">✕</button></td>
            </tr>))}
          {!files.length && <tr><td colSpan={5 + inputs.length} className="muted" style={{ textAlign: "center", padding: 18 }}>No files yet — add machine output files above.</td></tr>}
        </tbody>
      </table>
    </div>
  );
}
