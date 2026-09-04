import { createContext, useCallback, useContext, useState, ReactNode } from "react";

const Ctx = createContext<(msg: string, kind?: "ok" | "err") => void>(() => {});
export const useToast = () => useContext(Ctx);

export function ToastProvider({ children }: { children: ReactNode }) {
  const [msg, setMsg] = useState<{ text: string; kind: string } | null>(null);
  const show = useCallback((text: string, kind: "ok" | "err" = "ok") => {
    setMsg({ text, kind });
    setTimeout(() => setMsg(null), kind === "err" ? 6000 : 3000);
  }, []);
  return (
    <Ctx.Provider value={show}>
      {children}
      {msg && <div className="toast" style={msg.kind === "err" ? { background: "var(--crit)", color: "#fff" } : {}}>{msg.text}</div>}
    </Ctx.Provider>
  );
}
