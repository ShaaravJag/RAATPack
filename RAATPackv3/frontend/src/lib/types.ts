export interface Field { key: string; label: string; dp: number; report?: boolean; fmt?: string; kind?: string }
export interface ModuleSpec {
  id: string; name: string; short: string; standard: string; description: string; reader: string;
  template_kind: string | null; specimen_inputs: Field[]; required_inputs: string[]; result_fields: Field[];
  x_label: string; y_label: string; chart_title: string; report_title: string; single_export: boolean;
  supports_pick: boolean; supports_trim: boolean; extra: Record<string, any>;
}
export interface Transform { offset_start: number; negative: number; offset_end: number }
export interface Template {
  id: string; name: string; kind: string; columns: Record<string, number>; data_start: number; data_end: number | null;
  delimiter: string; sheet: number; transforms: Record<string, Transform>; units: Record<string, string>; builtin: boolean; source: string;
}
export interface Preview { x: number[]; y: number[] }
export interface LoadedFile {
  id: string; name: string; template_id: string | null; specimen_id: string; inputs: Record<string, number | null>;
  picks: Record<string, number | null>; trim_x: number | null; error: string | null; n_points: number; preview: Preview;
  result?: Record<string, any>;
}
export interface Stat { mean: number | null; std: number | null; cov: number | null; n: number; values: number[]; labels?: string[]; provisional?: number }
export interface ResultsTable { columns: Field[]; rows: Record<string, any>[]; stats?: Record<string, Stat>;
  provisional?: (string | null)[]; errors?: { specimen_id: string | null; error: string | null }[] }
export interface WorkspaceState {
  module: string; project: Record<string, string>; options: Record<string, any>; ran: boolean; files: LoadedFile[];
  table: ResultsTable | null; needs_pick: string[];
}
export interface Series { name: string; x: number[]; y: number[]; style: string; color?: string | null }
export interface CurvePayload {
  id: string; name: string; x_label: string; y_label: string; series: Series[]; overlays: Series[];
  secondary: { title: string; x_label: string; y_label: string; series: Series[] } | null; log_x: boolean; log_y: boolean;
  shade?: { name: string; x: number[]; y: number[] }; shade_tail?: { name: string; x: number[]; y: number[] };
  needs_pick?: boolean; extrapolated_from?: number | null; x_max?: number;
}
export interface SampleInfo {
  available: boolean; n?: number; folder?: string; reference_pdf?: string | null;
  dimensions?: Record<string, number>; note?: string;
}
export interface Settings {
  institution: string; logo_path: string; technician: string; default_export_format: string; cov_warn_pct: number;
  theme: string; data_dir: string; has_logo: boolean;
}
