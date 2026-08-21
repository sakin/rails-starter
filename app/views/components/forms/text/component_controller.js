import { Controller } from '@hotwired/stimulus'

// Floating-label behaviour for the `Forms::Text` component, registered under the
// component folder (`component_controller.js` -> `forms--text`), matching the
// component's `data-controller` id. The label floats while the input is focused
// OR holds a value, and drops when blurred and empty.
export default class extends Controller {
  static targets = ['input']

  connect() {
    this.update()
  }

  focus() {
    this.update()
  }

  blur() {
    this.update()
  }

  input() {
    this.update()
  }

  update() {
    const floating = this.inputTarget === document.activeElement || this.inputTarget.value !== ''
    this.element.classList.toggle('is-floating', floating)
  }
}
