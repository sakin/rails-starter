# 08 — bin/setup + bin/dev

**What to build:** a fresh clone gets running with one command. Setup installs gems and prepares the database; the dev command boots the web server and the asset watcher together, staying hot-reloading.

**Blocked by:** 02 — Frontend swap: Vite + bundlebun + Tailwind v4 + daisyUI 5

**Status:** ready-for-agent

- [ ] From a fresh clone, a bundle install is the only prerequisite before setup succeeds (gems installed, DB prepared).
- [ ] The dev command starts the web server and the frontend watcher together and keeps them hot-reloading.
- [ ] No manual JS runtime install; Bun comes from the bundle.
