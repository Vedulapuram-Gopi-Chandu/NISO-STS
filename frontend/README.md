# Frontend (React)

This is the separate frontend repo for the XML-to-HTML converter UI.

## Run

1. Install dependencies:
   npm install
2. Configure API URL:
   copy `.env.example` to `.env` only if you need a non-default backend URL.
3. Start dev server:
   npm run dev
4. Start the Flask backend from `../backend`:
   python app.py

By default, the frontend uses Vite's dev proxy and sends `/api/*` and `/conversions/*` requests to `http://localhost:5000`.
If your backend runs somewhere else, set `VITE_API_BASE_URL` in `.env`.
