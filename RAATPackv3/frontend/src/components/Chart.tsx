import { useEffect, useRef } from "react";
import Plotly from "plotly.js-basic-dist-min";
import type { Series } from "../lib/types";

export interface Shade { name: string; x: number[]; y: number[]; color?: string }
interface Props {
  series: Series[]; overlays?: Series[]; shades?: Shade[]; xLabel?: string; yLabel?: string; title?: string;
  logX?: boolean; logY?: boolean; height?: number; onClick?: (x: number, y: number) => void; hidden?: Set<string>;
  xRange?: [number, number] | null; yRange?: [number, number] | null; vlines?: { x: number; label: string; color?: string }[];
  bands?: { x0: number; x1: number; color?: string; label?: string }[]; y2?: { series: Series[]; label: string } | null;
}
const PALETTE = ["#1f4e79", "#c00000", "#2e7d32", "#ed7d31", "#7030a0", "#00838f", "#8d6e63", "#455a64", "#c2185b", "#5d4037", "#0288d1", "#689f38"];

function css(name: string) { return getComputedStyle(document.documentElement).getPropertyValue(name).trim(); }

const sigOf = (list: Series[] | undefined) =>
  (list || []).map(s => [s.name, s.style, s.color, s.x?.length, s.x?.[0], s.x?.[(s.x?.length || 1) - 1],
                         s.y?.[0], s.y?.[(s.y?.length || 1) - 1]].join(",")).join("|");

export default function Chart(p: Props) {
  const ref = useRef<HTMLDivElement>(null);
  // Keep the latest click handler reachable without making it an effect dependency: it is a new
  // closure on every render, and re-running the effect is what used to reset the zoom.
  const onClickRef = useRef(p.onClick);
  onClickRef.current = p.onClick;
  const lastSig = useRef<string>("");

  // Everything the drawing actually depends on, as a string. Identity-unstable props (arrays
  // rebuilt each render) collapse to the same signature when nothing material changed.
  const sig = [
    sigOf(p.series), sigOf(p.overlays), sigOf(p.shades as any), sigOf(p.y2?.series),
    p.xLabel, p.yLabel, p.title, p.logX, p.logY, p.height,
    [...(p.hidden || [])].sort().join(","),
    JSON.stringify(p.xRange), JSON.stringify(p.yRange),
    JSON.stringify(p.vlines), JSON.stringify(p.bands), p.y2?.label, !!p.onClick,
  ].join("~");

  useEffect(() => {
    const el = ref.current; if (!el) return;
    const ink = css("--ink"), muted = css("--muted"), grid = css("--plot-grid"), bg = css("--plot-bg");
    const traces: any[] = [];
    (p.shades || []).forEach(s => traces.push({ x: s.x, y: s.y, type: "scatter", mode: "lines", fill: "tozeroy", fillcolor: (s.color || "#1f4e79") + "22", line: { width: 0 }, name: s.name, hoverinfo: "skip", showlegend: true }));
    p.series.forEach((s, i) => {
      if (p.hidden?.has(s.name)) return;
      const color = s.color || PALETTE[i % PALETTE.length];
      traces.push({ x: s.x, y: s.y, type: "scatter", mode: s.style === "marker" ? "markers" : "lines", name: s.name,
        line: { color, width: 2, dash: s.style === "dashed" ? "dash" : "solid" }, marker: { color, size: 5 } });
    });
    (p.overlays || []).forEach((s, i) => {
      if (p.hidden?.has(s.name)) return;
      const color = s.color || PALETTE[(i + 3) % PALETTE.length];
      if (s.style === "marker") traces.push({ x: s.x, y: s.y, type: "scatter", mode: "markers", name: s.name, marker: { color, size: 10, symbol: "circle-open", line: { width: 2.5, color } } });
      else if (s.style === "band") traces.push({ x: s.x, y: s.y, type: "scatter", mode: "lines", name: s.name, line: { color, width: 6 }, opacity: .45 });
      else traces.push({ x: s.x, y: s.y, type: "scatter", mode: "lines", name: s.name, line: { color, width: 1.6, dash: s.style === "dashed" ? "dash" : "solid" } });
    });
    (p.y2?.series || []).forEach((s, i) => traces.push({ x: s.x, y: s.y, yaxis: "y2", type: "scatter", mode: s.style === "marker" ? "markers" : "lines", name: s.name, marker: { color: s.color || PALETTE[(i + 5) % 12], size: 6, symbol: "diamond" }, line: { color: s.color || PALETTE[(i + 5) % 12], dash: "dot" } }));
    const shapes: any[] = [];
    const annotations: any[] = [];
    (p.vlines || []).forEach(v => { shapes.push({ type: "line", x0: v.x, x1: v.x, y0: 0, y1: 1, yref: "paper", line: { color: v.color || muted, width: 1, dash: "dot" } }); annotations.push({ x: v.x, y: 1, yref: "paper", text: v.label, showarrow: false, font: { size: 10, color: v.color || muted }, xanchor: "left", yanchor: "top" }); });
    (p.bands || []).forEach(b => { shapes.push({ type: "rect", x0: b.x0, x1: b.x1, y0: 0, y1: 1, yref: "paper", fillcolor: b.color || "#ed7d31", opacity: .12, line: { width: 0 } }); if (b.label) annotations.push({ x: (b.x0 + b.x1) / 2, y: .98, yref: "paper", text: b.label, showarrow: false, font: { size: 10, color: muted } }); });
    const layout: any = {
      paper_bgcolor: bg, plot_bgcolor: bg, font: { color: ink, family: "Source Sans 3, Helvetica, Arial", size: 12 },
      margin: { l: 60, r: p.y2 ? 60 : 20, t: p.title ? 40 : 16, b: 48 },
      xaxis: { title: { text: p.xLabel || "" }, type: p.logX ? "log" : "linear", gridcolor: grid, zerolinecolor: grid, autorange: !p.xRange },
      yaxis: { title: { text: p.yLabel || "" }, type: p.logY ? "log" : "linear", gridcolor: grid, zerolinecolor: grid, autorange: !p.yRange },
      legend: { orientation: "h", y: -0.18, font: { size: 11 } }, hovermode: "closest", shapes, annotations, height: p.height || 380,
    };
    if (p.title) layout.title = { text: p.title, font: { size: 13, color: ink } };
    if (p.xRange) layout.xaxis.range = p.logX ? p.xRange.map(v => Math.log10(v)) : p.xRange;
    if (p.yRange) layout.yaxis.range = p.logY ? p.yRange.map(v => Math.log10(v)) : p.yRange;
    if (p.y2) layout.yaxis2 = { title: { text: p.y2.label }, overlaying: "y", side: "right", gridcolor: "transparent" };

    // Hold whatever the user zoomed to. Plotly clears autorange on the axis when they zoom, so
    // that flag is the record of "they chose this view" — worth keeping while they line up a
    // pick, and worth dropping as soon as the data underneath genuinely changes.
    const prev: any = (el as any).layout;
    if (prev && sig === lastSig.current) {
      if (!p.xRange && prev.xaxis?.autorange === false && prev.xaxis?.range)
        Object.assign(layout.xaxis, { range: [...prev.xaxis.range], autorange: false });
      if (!p.yRange && prev.yaxis?.autorange === false && prev.yaxis?.range)
        Object.assign(layout.yaxis, { range: [...prev.yaxis.range], autorange: false });
    }
    lastSig.current = sig;

    Plotly.react(el, traces, layout, { responsive: true, displaylogo: false, modeBarButtonsToRemove: ["select2d", "lasso2d"] });
    const handler = (ev: any) => { const pt = ev?.points?.[0]; if (pt) onClickRef.current?.(Number(pt.x), Number(pt.y)); };
    (el as any).on?.("plotly_click", handler);
    return () => { (el as any).removeListener?.("plotly_click", handler); };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sig]);
  useEffect(() => () => { if (ref.current) Plotly.purge(ref.current); }, []);
  return <div className="chartbox" ref={ref} style={{ cursor: p.onClick ? "crosshair" : "default" }} />;
}
