# 09 — Docker build + optional Kamal config

**What to build:** the app builds into a production Docker image with no Node step (Bun comes from the bundle), and the existing Kamal deploy config is kept but optional — its presence or absence never breaks the build.

**Blocked by:** 02 — Frontend swap: Vite + bundlebun + Tailwind v4 + daisyUI 5

**Status:** resolved

- [x] A multi-stage build produces a working image on the official Ruby base with no Node install.
- [x] Assets compile during the image build (Vite through bundled Bun).
- [x] The existing Kamal config is kept as optional, documented, and its absence/presence does not break the build.
- [x] The container boots the app with the HTTP cache/compression server.

## Comments

Verified with no Dockerfile logic change needed (the multi-stage layout landed with
the frontend swap in 02). `docker build` succeeds from the official
`ruby:4.0.6-slim` base — the `assets:precompile` stage runs Vite through the
bundle's Bun (`bun install v1.3.14` then `vite build`, 14 modules), with no Node
install anywhere. Ran the image: Thruster starts (`Server started http:":80"`),
proxies to Puma in production on :3000, and serves GET /up 200 (green body) with
the `X-Cache` header confirming the HTTP cache/compression server. Added Dockerfile
comments documenting the no-Node (bundlebun) frontend build and Kamal optionality —
the build never references config/deploy.yml or .kamal/.
