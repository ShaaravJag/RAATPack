import { useRef, useState } from "react";

export default function FileDrop({ onFiles, accept, label, disabled, multiple = true }: { onFiles: (f: File[]) => void; accept?: string; label?: string; disabled?: boolean; multiple?: boolean }) {
  const [over, setOver] = useState(false);
  const inp = useRef<HTMLInputElement>(null);
  return (
    <div className={"drop" + (over ? " over" : "")} style={disabled ? { opacity: .5, pointerEvents: "none" } : {}}
      onClick={() => inp.current?.click()}
      onDragOver={e => { e.preventDefault(); setOver(true); }} onDragLeave={() => setOver(false)}
      onDrop={e => { e.preventDefault(); setOver(false); const fs = Array.from(e.dataTransfer.files); if (fs.length) onFiles(fs); }}>
      <input ref={inp} type="file" multiple={multiple} accept={accept} hidden onChange={e => { const fs = Array.from(e.target.files || []); if (fs.length) onFiles(fs); e.target.value = ""; }} />
      <div><b>{label || "Drop machine files here"}</b></div>
      <div className="tiny">or click to browse · {accept || ".xlsx, .csv"}</div>
    </div>
  );
}
