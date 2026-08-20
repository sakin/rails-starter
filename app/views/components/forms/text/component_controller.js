import { Controller } from '@hotwired/stimulus'

// Floating-label behaviour for the `Forms::Text` component. The field floats
// (gains `is-floating`) while focused or holding a value, so the daisyUI
// `label-floating` label stays raised. Registered under the component folder
// (`component_controller.js` -> `forms--text`), matching the component's
// `data-controller` id.
export default class extends Controller {
  static targets = ['input']

  connect() {
    this.update()
  }

  focus() {
    this.float()
  }

  blur() {
    this.update()
  }

  input() {
    this.update()
  }

  float() {
    this.element.classList.add('is-floating')
  }

  update() {
    const hasValue = this.inputTarget.value !== ''
    this.element.classList.toggle('is-floating', hasValue)
  }
}
