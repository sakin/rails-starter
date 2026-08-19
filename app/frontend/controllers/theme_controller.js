import { Controller } from '@hotwired/stimulus'

// Light/dark theme toggle, backed by the daisyUI `light`/`dark` themes. The
// chosen theme is applied as `data-theme` on the document root and persisted so
// it survives reloads; an explicit user choice overrides the OS preference.
export default class extends Controller {
  static targets = ['label']

  connect() {
    this.theme =
      localStorage.getItem('theme') ??
      (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light')
    this.apply()
  }

  toggle() {
    this.theme = this.theme === 'dark' ? 'light' : 'dark'
    this.apply()
  }

  apply() {
    document.documentElement.dataset.theme = this.theme
    localStorage.setItem('theme', this.theme)
    this.labelTarget.textContent = this.theme === 'dark' ? 'Light' : 'Dark'
  }
}
