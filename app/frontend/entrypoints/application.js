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

// Co-located Stimulus controllers that live beside a view component. These are
// named by their folder rather than a full id: `component_controller.js`
// registers under the folder-derived identifier, so
// `forms/text/component_controller.js` -> `forms--text` (matching the
// component's `controller_name`). An additional `foo_controller.js` in the same
// folder registers as `forms--text--foo`. This keeps standalone controllers in
// `app/frontend/controllers/` separate from component-coupled behaviour.
const componentControllers = import.meta.glob('../../views/components/**/*_controller.js', { eager: true })

for (const path in componentControllers) {
  const module = componentControllers[path]
  // e.g. `../../views/components/forms/text/component_controller.js`
  const rel = path.replace(/^.*\/views\/components\//, '').replace(/\.js$/, '')
  const parts = rel.split('/')
  const file = parts.pop()
  const folder = parts.join('--')
  const name =
    file === 'component_controller'
      ? folder
      : `${folder}--${file.replace(/_controller$/, '')}`
  window.Stimulus.register(name, module.default)
}
