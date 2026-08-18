// Eagerly load every sidecar component's `index.js`, which in turn imports that
// component's `index.css`, so Vite bundles all component styles. `**` covers
// nested components (admin/sidebar); the root aggregator is excluded to avoid
// matching this file itself.
import.meta.glob("./**/index.js", { eager: true, exclude: "./index.js" })
