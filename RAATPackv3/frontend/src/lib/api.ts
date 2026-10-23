import type { CurvePayload, LoadedFile, ModuleSpec, SampleInfo, Settings, Template, WorkspaceState } from "./types";

const BASE = "/api";

async function j<T>(res: Response): Promise<T> {
  if (!res.ok) {
    let msg = res.statusText;
    try { const d = await res.json(); msg = d.detail ?? JSON.stringify(d); } catch { /* ignore */ }
    throw new Error(typeof msg === "string" ? msg : JSON.stringify(msg));
  }
  return res.json();
}
const get = <T,>(u: string) => fetch(BASE + u).then(j<T>);
const send = <T,>(m: string, u: string, body?: any) =>
  fetch(BASE + u, { method: m, headers: body === undefined ? {} : { "Content-Type": "application/json" }, body: body === undefined ? undefined : JSON.stringify(body) }).then(j<T>);
const form = <T,>(m: string, u: string, fd: FormData) => fetch(BASE + u, { method: m, body: fd }).then(j<T>);

export async function download(u: string, body: any, fallbackName = "export") {
  const res = await fetch(BASE + u, { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify(body) });
  if (!res.ok) { let msg = res.statusText; try { msg = (await res.json()).detail ?? msg; } catch {} throw new Error(msg); }
  const blob = await res.blob();
  const cd = res.headers.get("Content-Disposition") || "";
  const m = /filename="?([^";]+)"?/.exec(cd);
  const name = m ? m[1] : fallbackName;
  const saved = res.headers.get("X-Saved-Path");
  const a = document.createElement("a");
  a.href = URL.createObjectURL(blob);
  a.download = name;
  document.body.appendChild(a);
  a.click();
  a.remove();
  setTimeout(() => URL.revokeObjectURL(a.href), 5000);
  return saved ? `${name} (saved in ${saved.replace(/[\\/][^\\/]*$/, "")})` : name;
}

export const api = {
  health: () => get<{ ok: boolean; version: string }>("/health"),
  exports: () => get<{ dir: string; files: { name: string; size: number; mtime: number }[] }>("/exports"),
  openExports: () => send<{ ok: boolean; dir: string }>("POST", "/exports/open"),
  modules: () => get<ModuleSpec[]>("/modules"),
  settings: () => get<Settings>("/settings"),
  saveSettings: (s: Partial<Settings>) => send<Settings>("PUT", "/settings", s),
  uploadLogo: (f: File) => { const fd = new FormData(); fd.append("file", f); return form<Settings>("POST", "/settings/logo", fd); },
  clearLogo: () => send<Settings>("DELETE", "/settings/logo"),
  templates: (kind?: string) => get<Template[]>("/templates" + (kind ? `?kind=${kind}` : "")),
  saveTemplate: (t: Partial<Template>) => t.id && !t.builtin ? send<Template>("PUT", `/templates/${t.id}`, t) : send<Template>("POST", "/templates", { ...t, id: undefined }),
  deleteTemplate: (id: string) => send<{ ok: boolean }>("DELETE", `/templates/${id}`),
  importTemplate: (f: File, name?: string) => { const fd = new FormData(); fd.append("file", f); if (name) fd.append("name", name); return form<Template>("POST", "/templates/import", fd); },
  previewTemplate: (f: File, t: Partial<Template>) => { const fd = new FormData(); fd.append("file", f); fd.append("template", JSON.stringify(t)); return form<{ grid: string[][]; sheets: string[]; parsed: any; error: string | null }>("POST", "/templates/preview", fd); },
  ws: (m: string) => get<WorkspaceState>(`/ws/${m}`),
  reset: (m: string) => send<WorkspaceState>("POST", `/ws/${m}/reset`),
  addFiles: (m: string, files: File[], templateId?: string | null) => { const fd = new FormData(); files.forEach(f => fd.append("files", f)); if (templateId) fd.append("template_id", templateId); return form<{ added: LoadedFile[]; state: WorkspaceState }>("POST", `/ws/${m}/files`, fd); },
  removeFile: (m: string, fid: string) => send<WorkspaceState>("DELETE", `/ws/${m}/files/${fid}`),
  updateFile: (m: string, fid: string, body: any) => send<LoadedFile>("PUT", `/ws/${m}/files/${fid}`, body),
  updateProject: (m: string, body: { project?: Record<string, string>; options?: Record<string, any> }) => send<WorkspaceState>("PUT", `/ws/${m}/project`, body),
  run: (m: string) => send<WorkspaceState>("POST", `/ws/${m}/run`),
  pick: (m: string, fid: string, kind: string, x: number | null) => send<{ file: LoadedFile; curve: CurvePayload; state: WorkspaceState }>("POST", `/ws/${m}/files/${fid}/pick`, { kind, x }),
  curve: (m: string, fid: string) => get<CurvePayload>(`/ws/${m}/curve/${fid}`),
  raw: (m: string, fid: string) => get<{ columns: string[]; rows: (number | null)[][]; total: number }>(`/ws/${m}/raw/${fid}`),
  exportReport: (m: string, body: { format: string; file_ids?: string[]; options?: any }) => download(`/ws/${m}/export`, body),
  session: (m: string) => get<any>(`/ws/${m}/session`),
  loadSession: (m: string, snap: any) => send<WorkspaceState>("POST", `/ws/${m}/session`, snap),
  samples: (m: string) => send<WorkspaceState & { sample_note?: string }>("POST", `/ws/${m}/samples`),
  samplesInfo: (m: string) => get<SampleInfo>(`/ws/${m}/samples`),
  // dynamic modulus
  dm: () => get<any>("/dm"),
  dmReset: () => send<any>("POST", "/dm/reset"),
  dmSamples: () => send<any>("POST", "/dm/samples"),
  dmProject: (project: Record<string, string>) => send<any>("PUT", "/dm/project", { project }),
  dmVolumetrics: (b: any) => send<any>("POST", "/dm/volumetrics", b),
  dmBinder: (kind: string, body: any) => send<any>("POST", `/dm/binder/${kind}`, body),
  dmFiles: (files: File[]) => { const fd = new FormData(); files.forEach(f => fd.append("files", f)); return form<any>("POST", "/dm/ampt/files", fd); },
  dmRemoveFile: (fid: string) => send<any>("DELETE", `/dm/ampt/files/${fid}`),
  dmAssign: (slots: (string | null)[][], target_temps_c: (number | null)[][]) => send<any>("PUT", "/dm/ampt/assign", { slots, target_temps_c }),
  dmWitczak: (b: any) => send<any>("POST", "/dm/witczak", b),
  dmHirsch: (f: File, rad: boolean) => { const fd = new FormData(); fd.append("file", f); fd.append("rad_per_s", String(rad)); return form<any>("POST", "/dm/hirsch/file", fd); },
  dmRun: (curves: string[], ref_temp_c: number, temp_source: string) => send<any>("POST", "/dm/run", { curves, ref_temp_c, temp_source }),
  dmExport: (curve: string, format: string) => download("/dm/export", { curve, format }),
};

export function fmt(v: any, f?: { dp?: number; fmt?: string }): string {
  if (v === null || v === undefined || v === "") return "—";
  if (typeof v !== "number") return String(v);
  if (!isFinite(v)) return "—";
  if (f?.fmt && f.fmt.toUpperCase().endsWith("E")) return v.toExponential(2);
  const dp = f?.dp ?? 2;
  return v.toFixed(dp);
}
