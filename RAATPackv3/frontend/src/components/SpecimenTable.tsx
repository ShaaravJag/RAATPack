import type { Field, LoadedFile, ModuleSpec } from "../lib/types";

interface Props { spec: ModuleSpec; files: LoadedFile[]; selected: string | null; onSelect: (id: string) => void;
  onChange: (fid: string, patch: { specimen_id?: string; inputs?: Record<string, number | null> }) => void; onRemove: (fid: string) => void; onFill: (key: string, value: number | null) => void; filling?: string | null; onLoadSamples?: () => void; }

export default function SpecimenTable({ spec, files, selected, onSelect, onChange, onRemove, onFill, filling, onLoadSamples }: Props) {
  const inputs: Field[] = spec.specimen_inputs;
  const req = new Set(spec.required_inputs);

  /** Copy the first row's value down the column. It used to propagate an empty first row, which
   *  silently cleared the value for every other specimen with no confirmation and no undo. */
  const fillDown = (f: Field) => {
    const v = files[0]?.inputs?.[f.key];
    if (v === null || v === undefined) {
      alert(`Enter ${f.label} for the first specimen before copying it down the column.`);
      return;
    }
    const overwriting = files.slice(1).filter(x => {
      const o = x.inputs?.[f.key];
      return o !== null && o !== undefined && o !== v;
    }).length;
    if (overwriting && !confirm(`Set ${f.label} to ${v} for all ${files.length} specimens? This replaces a different value on ${overwriting} of them.`)) return;
    onFill(f.key, v);
  };
  return (
    <div className="tw">
      <table className="t">
        <thead><tr>
          <th style={{ width: 28 }}>#</th><th>File</th><th>Specimen ID</th>
          {inputs.map(f => <th key={f.key} className="n">{f.label}{req.has(f.key) && <span title="required" style={{ color: "var(--accent)" }}> *</span>}
            <button className="btn ghost sm" title={`Copy the first specimen's ${f.label} to every row`} style={{ padding: "0 4px", marginLeft: 4 }} disabled={!!filling || files.length < 2} onClick={() => fillDown(f)}>{filling === f.key ? <span className="spin" /> : "⇣"}</button></th>)}
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
              <td><button className="btn ghost sm danger" aria-label={`Remove ${f.specimen_id || f.name}`} onClick={e => {
                e.stopPropagation();
                // Removing a file resets the run, so every specimen's results disappear until
                // the analysis is run again — worth saying before it happens.
                const warn = f.result || f.error
                  ? `Remove ${f.specimen_id || f.name}? The results table will be cleared and you will need to run the analysis again.`
                  : `Remove ${f.specimen_id || f.name}?`;
                if (confirm(warn)) onRemove(f.id);
              }} title="Remove this specimen">✕</button></td>
            </tr>))}
          {!files.length && <tr><td colSpan={5 + inputs.length} className="muted" style={{ textAlign: "center", padding: 18 }}>
            No files yet — add machine output files above
            {onLoadSamples ? <>, or <button className="btn sm" onClick={onLoadSamples}>load the sample data</button> to try the module straight away</> : null}.
          </td></tr>}
        </tbody>
      </table>
    </div>
  );
}
