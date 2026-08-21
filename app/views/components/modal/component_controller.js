import { Controller } from '@hotwired/stimulus'

// daisyUI modal backed by a native `<dialog>`. `open`/`close` are wired to the
// trigger and dismiss buttons via `data-action`, and clicking the backdrop
// dismisses too. Open/close genuinely need JS (`dialog.showModal()`), so this is
// the reference for a component whose behaviour requires its own controller.
export default class extends Controller {
  static targets = ['dialog']

  open() {
    this.dialogTarget.showModal()
  }

  close() {
    this.dialogTarget.close()
  }
}
