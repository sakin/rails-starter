import '@hotwired/turbo'
import { Application } from '@hotwired/stimulus'

// Eagerly load each ViewComponent sidecar's index.js, which imports its
// styles.css, so Vite bundles all component styles (nested ones included).
// There is no index.js at the app/views/components root, so no self-match.
import.meta.glob('../../views/components/**/index.js', { eager: true })

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
