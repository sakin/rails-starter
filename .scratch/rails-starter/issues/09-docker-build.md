# 09 — Docker build + optional Kamal config

**What to build:** the app builds into a production Docker image with no Node step (Bun comes from the bundle), and the existing Kamal deploy config is kept but optional — its presence or absence never breaks the build.

**Blocked by:** 02 — Frontend swap: Vite + bundlebun + Tailwind v4 + daisyUI 5

**Status:** ready-for-agent

- [ ] A multi-stage build produces a working image on the official Ruby base with no Node install.
- [ ] Assets compile during the image build (Vite through bundled Bun).
- [ ] The existing Kamal config is kept as optional, documented, and its absence/presence does not break the build.
- [ ] The container boots the app with the HTTP cache/compression server.
