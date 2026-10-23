import { useEffect } from "react";

/** Close a modal with Escape.
 *
 *  Every dialog in the app could only be dismissed by clicking, which made the keyboard a
 *  dead end once one was open. */
export default function useEscape(onEscape: (() => void) | null | undefined, active = true) {
  useEffect(() => {
    if (!active || !onEscape) return;
    const h = (e: KeyboardEvent) => { if (e.key === "Escape") { e.stopPropagation(); onEscape(); } };
    window.addEventListener("keydown", h);
    return () => window.removeEventListener("keydown", h);
  }, [onEscape, active]);
}
