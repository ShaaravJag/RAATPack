import { useRef, useState } from "react";

/** Excel writes a "~$Book.xlsx" lock file beside any workbook it has open, and macOS/Windows
 *  litter folders with .DS_Store and Thumbs.db. None of them are data, and all of them fail to
 *  parse, so drop them here rather than letting the backend report a read error per file. */
const IGNORED = [/^~\$/, /^\.~lock\./, /^\.DS_Store$/i, /^Thumbs\.db$/i];
export const isIgnoredFile = (name: string) => IGNORED.some(re => re.test(name));

export default function FileDrop({ onFiles, onIgnored, accept, label, disabled, multiple = true }: { onFiles: (f: File[]) => void; onIgnored?: (names: string[]) => void; accept?: string; label?: string; disabled?: boolean; multiple?: boolean }) {
  const [over, setOver] = useState(false);
  const inp = useRef<HTMLInputElement>(null);

  function take(all: File[]) {
    const keep = all.filter(f => !isIgnoredFile(f.name));
    const skipped = all.filter(f => isIgnoredFile(f.name)).map(f => f.name);
    if (skipped.length) onIgnored?.(skipped);
    if (keep.length) onFiles(keep);
  }

  return (
    <div className={"drop" + (over ? " over" : "")} style={disabled ? { opacity: .5, pointerEvents: "none" } : {}}
      onClick={() => inp.current?.click()}
      onDragOver={e => { e.preventDefault(); setOver(true); }} onDragLeave={() => setOver(false)}
      onDrop={e => { e.preventDefault(); setOver(false); const fs = Array.from(e.dataTransfer.files); if (fs.length) take(fs); }}>
      <input ref={inp} type="file" multiple={multiple} accept={accept} hidden onChange={e => { const fs = Array.from(e.target.files || []); if (fs.length) take(fs); e.target.value = ""; }} />
      <div><b>{label || "Drop machine files here"}</b></div>
      <div className="tiny">or click to browse · {accept || ".xlsx, .csv"}</div>
    </div>
  );
}
