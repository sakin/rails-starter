import '@hotwired/turbo'
import { Application } from '@hotwired/stimulus'

// Load all ViewComponent sidecar assets (see app/frontend/components/index.js).
import '../components/index'

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
