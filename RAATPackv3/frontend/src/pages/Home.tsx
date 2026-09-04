import { Link } from "react-router-dom";
import type { ModuleSpec } from "../lib/types";

export default function Home({ mods }: { mods: ModuleSpec[] }) {
  return (
    <div className="page">
      <div className="pagehead">
        <div>
          <div className="eyebrow">Rutgers Asphalt Analysis Tool-Pack</div>
          <h1>Choose a test</h1>
          <p>Ten performance-test analyses, each reproducing the v2 calculations exactly. Load your machine files, enter specimen dimensions, run, and export a summary report.</p>
        </div>
      </div>
      <div className="cards">
        {mods.map(m => (
          <Link key={m.id} to={`/m/${m.id}`} className="card">
            <div className="std">{m.standard}</div>
            <h3>{m.name}</h3>
            <p>{m.description}</p>
          </Link>
        ))}
      </div>
      <div className="panel"><div className="ph"><h3>Before you start</h3></div>
        <div className="pb small">
          <ol style={{ margin: 0, paddingLeft: 18 }}>
            <li>Set your institution name and logo under <Link to="/settings">Settings</Link> — they appear on every report.</li>
            <li>Check <Link to="/templates">File templates</Link>: a template tells RAAT-Pack where the data lives in your machine's output file. The lab's library from v2 is built in; add your own for new machines.</li>
            <li>Open a module, add files, fill in the specimen table, and click <b>Run</b>.</li>
          </ol>
        </div>
      </div>
    </div>
  );
}
