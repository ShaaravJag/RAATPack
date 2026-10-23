import { fmt } from "../lib/api";
import type { Field, ResultsTable } from "../lib/types";

/** Visual presentation of the statistics v2 already reports: per-parameter dot plots with mean ± std, COV badge, outlier highlight. */
export default function StatsPanel({ table, covWarn }: { table: ResultsTable; covWarn: number }) {
  const cols = table.columns.filter(c => c.kind === "result");
  const st = table.stats || {};
  return (
    <div className="dots">
      {cols.map(c => {
        const s = st[c.key]; if (!s || s.n === 0) return null;
        const vals = s.values; const mean = s.mean ?? 0; const std = s.std ?? 0;
        const lo = Math.min(...vals, mean - std), hi = Math.max(...vals, mean + std); const span = hi - lo || 1;
        const px = (v: number) => ((v - lo) / span) * 100;
        const warn = (s.cov ?? 0) > covWarn;
        // which replicate pulls the COV hardest: largest |v - mean|
        const worst = vals.length > 2 ? vals.reduce((a, v, i) => Math.abs(v - mean) > Math.abs(vals[a] - mean) ? i : a, 0) : -1;
        // Labels travel with the values. Indexing table.rows[i] here was wrong whenever a
        // specimen had no value for this column: every label shifted, and the highlighted
        // outlier pointed at the wrong specimen.
        const label = (i: number) => s.labels?.[i] ?? `#${i + 1}`;
        return (
          <div className="stattile" key={c.key}>
            <small>{c.label}</small>
            <div className="row spread" style={{ alignItems: "baseline" }}><b>{fmt(mean, c)}</b><span className={"chip " + (warn ? "warn" : "ok")}>COV {s.cov == null ? "—" : s.cov.toFixed(1) + "%"}</span></div>
            <div className="tiny muted">± {fmt(std, c)} · n = {s.n}{!!s.provisional && <> · <span className="warntext" title="These specimens' slopes or inflection points were guessed automatically and have not been confirmed">{s.provisional} provisional</span></>}</div>
            <div style={{ position: "relative", height: 26, marginTop: 8 }}>
              <div style={{ position: "absolute", left: `${px(mean - std)}%`, width: `${px(mean + std) - px(mean - std)}%`, top: 10, height: 6, background: "var(--surface-3)", borderRadius: 3 }} />
              <div style={{ position: "absolute", left: `${px(mean)}%`, top: 4, width: 2, height: 18, background: "var(--ink)" }} />
              {vals.map((v, i) => <div key={i} title={`${label(i)}: ${fmt(v, c)}`} style={{ position: "absolute", left: `calc(${px(v)}% - 5px)`, top: 8, width: 10, height: 10, borderRadius: "50%", background: i === worst && warn ? "var(--warn)" : "var(--accent)", border: "2px solid var(--surface)" }} />)}
            </div>
          </div>);
      })}
    </div>
  );
}
