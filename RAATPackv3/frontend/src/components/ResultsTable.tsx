import { fmt } from "../lib/api";
import type { Field, ResultsTable as RT } from "../lib/types";

export default function ResultsTable({ table, covWarn, selected, onSelect, hamburg }: { table: RT; covWarn: number; selected: string | null; onSelect: (id: string) => void; hamburg?: boolean }) {
  if (hamburg) {
    const cols = table.columns;
    return (
      <div className="tw"><table className="t">
        <thead><tr><th>Specimen</th><th>Wheel</th>{cols.map(c => <th key={c.key} className="n">{c.label}</th>)}<th>SIP ratio</th></tr></thead>
        <tbody>{table.rows.map(r => (["left", "right", "average"] as const).map((w, k) => (
          <tr key={r.file_id + w} className={(k === 2 ? "stat " : "") + (selected === r.file_id ? "sel" : "")} onClick={() => onSelect(r.file_id)}>
            {k === 0 && <td rowSpan={3}>{r.specimen_id}</td>}
            <td>{w === "average" ? "Average" : w === "left" ? "Left" : "Right"}{r[w]?.manual && <span className="chip info" style={{ marginLeft: 6 }}>manual</span>}{r[w]?.extrapolated && <span className="chip warn" style={{ marginLeft: 6 }} title="Rut at 20,000 passes is extrapolated beyond the last data point">extrapolated</span>}</td>
            {cols.map(c => <td key={c.key} className="n">{fmt(r[w]?.[c.key], c)}</td>)}
            <td className="n">{w === "average" ? "" : fmt(r[w]?.sip_ratio, { dp: 2 })}{w !== "average" && r[w]?.sip_ratio != null && r[w].sip_ratio < 2 && <span className="chip n" style={{ marginLeft: 6 }} title="Stripping/creep ratio below 2 — no inflection point reported (v2 rule)">&lt; 2</span>}</td>
          </tr>)))}</tbody>
      </table></div>);
  }
  const cols: Field[] = table.columns;
  const st = table.stats || {};
  const statRow = (label: string, key: "mean" | "std" | "cov") => (
    <tr className="stat" key={label}><td>{label}</td>
      {cols.map(c => { const s = st[c.key]; const v = s?.[key]; const warn = key === "cov" && typeof v === "number" && v > covWarn;
        return <td key={c.key} className="n" style={warn ? { color: "var(--warn)" } : {}}>{key === "cov" ? (v == null ? "—" : v.toFixed(1)) : fmt(v, c)}{warn && " ⚠"}</td>; })}
      <td /></tr>);
  return (
    <div className="tw"><table className="t">
      <thead><tr><th>Specimen ID</th>{cols.map(c => <th key={c.key} className="n" title={c.kind}>{c.label}</th>)}<th></th></tr></thead>
      <tbody>
        {table.rows.map(r => (
          <tr key={r.file_id} className={selected === r.file_id ? "sel" : ""} onClick={() => onSelect(r.file_id)}>
            <td>{r.specimen_id}</td>
            {cols.map(c => <td key={c.key} className="n">{fmt(r[c.key], c)}</td>)}
            <td>{r.error ? <span className="chip crit" title={r.error}>error</span> : r.needs_pick ? <span className="chip warn">pick needed</span> : r.picked ? <span className="chip info">manual pick</span> : r.tail_success === false ? <span className="chip warn" title="Tail extrapolation failed — Gf reported without tail">no tail</span> : null}</td>
          </tr>))}
        {statRow("Average", "mean")}{statRow("Std Dev", "std")}{statRow("COV (%)", "cov")}
      </tbody>
    </table></div>);
}
