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
  let name = path
    .split('/')
    .pop()
    .replace(/Controller$/, '')
    .replace(/^./, (c) => c.toLowerCase())
  window.Stimulus.register(name, module.default)
}
