import { useEffect, useState } from "react";

const API_BASE = (import.meta.env.VITE_API_BASE_URL || "").replace(/\/$/, "");

export default function App() {
  const [file, setFile] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const [conversions, setConversions] = useState([]);

  async function loadConversions() {
    try {
      const res = await fetch(`${API_BASE}/api/conversions`);
      const data = await res.json();
      setConversions(data.conversions || []);
    } catch (err) {
      setError("Failed to load saved conversions.");
    }
  }

  useEffect(() => {
    loadConversions();
  }, []);

  async function handleSubmit(event) {
    event.preventDefault();
    if (!file) {
      setError("Please select a ZIP file.");
      return;
    }

    setError("");
    setLoading(true);

    try {
      const formData = new FormData();
      formData.append("file", file);

      const res = await fetch(`${API_BASE}/api/convert`, {
        method: "POST",
        body: formData,
      });

      const data = await res.json();
      if (!res.ok) {
        throw new Error(data.error || "Conversion failed.");
      }

      window.location.href = data.url;
    } catch (err) {
      setError(err.message || "Conversion failed.");
      setLoading(false);
      await loadConversions();
    }
  }

  return (
    <main className="app-shell">
      <section className="card">
        <h1>Convert New XML File</h1>
        <form onSubmit={handleSubmit}>
          <input
            type="file"
            accept=".zip"
            disabled={loading}
            onChange={(event) => setFile(event.target.files?.[0] || null)}
          />
          <button type="submit" disabled={loading}>
            {loading ? "Converting..." : "Convert and View"}
          </button>
        </form>
        {error && <p className="error-message">{error}</p>}
      </section>

      <section className="card">
        <h2>Saved Conversions</h2>
        {conversions.length === 0 ? (
          <p className="empty-state">No saved conversions yet.</p>
        ) : (
          <ul className="conversion-list">
            {conversions.map((item) => (
              <li key={item.id}>
                <a href={item.url}>{item.id}</a>
              </li>
            ))}
          </ul>
        )}
      </section>
    </main>
  );
}
