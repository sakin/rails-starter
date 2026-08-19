import '@hotwired/turbo'
import { Application } from '@hotwired/stimulus'

// Bundle every ViewComponent sidecar's styles.css (nested ones included) so
// per-component authored CSS ships with the app. `eager` is required because
// CSS cannot be dynamically imported.
import.meta.glob('../../views/components/**/styles.css', { eager: true })

window.Stimulus = Application.start()

const controllers = import.meta.glob('../controllers/**/*_controller.js', { eager: true })

for (const path in controllers) {
  const module = controllers[path]
  // Derive the Stimulus identifier from the filename: `theme_controller.js`
  // -> `theme`, `hello_controller.js` -> `hello`. Plain glob keys carry the
  // extension, so the `_controller` and `.js` suffixes must both be stripped.
  const name = path
    .split('/')
    .pop()
    .replace(/\.js$/, '')
    .replace(/_controller$/, '')
    .replace(/^./, (c) => c.toLowerCase())
  window.Stimulus.register(name, module.default)
}
