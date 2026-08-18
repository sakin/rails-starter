# 02 — Frontend swap: Vite + bundlebun + Tailwind v4 + daisyUI 5

**What to build:** the frontend is built by Vite using a bundled Bun runtime — no Node anywhere (dev, CI, or Docker) — and Tailwind v4 with daisyUI 5 styles every page, hot-reloading as assets change.

**Blocked by:** None — can start immediately.

**Status:** ready-for-agent

- [ ] A fresh checkout gets the JS runtime purely from the bundle (Bun, version-pinned in the lockfile); no Node/npm/Yarn install step exists anywhere.
- [ ] The old JS pipeline is gone; entrypoints build through Vite.
- [ ] A page renders with Tailwind + daisyUI styling applied (a daisyUI button/alert is visibly themed).
- [ ] Assets dev-rebuild on change; the CSS entrypoint loads Tailwind + daisyUI at a pinned, compatible version set (side-step the `@plugin` resolution quirk).
