# 06 — Default layout + UI primitives

**What to build:** every page renders through a default component layout assembled from a small set of thin daisyUI wrapper components (nav, flash, form field, submit button), and the nav switches the app between light and dark themes.

**Blocked by:** 03 — ViewComponent foundation + contrib + Lookbook, 04 — Auth core

**Status:** ready-for-agent

- [ ] A default layout component renders all pages with a shared nav and flash region.
- [ ] The wrapper components delegate their styling to daisyUI classes and stay thin in source.
- [ ] The nav exposes a light/dark toggle that persists and restyles the app.
- [ ] Each primitive has a Lookbook preview; the auth pages (incl. flash on sign-in/out) render through the layout.
