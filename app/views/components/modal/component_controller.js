import { Controller } from '@hotwired/stimulus'

// daisyUI modal backed by a native `<dialog>`. The modal is a pure window: it
// only owns dismissal — the Close button and backdrop call `close` via
// `data-action`, both in the wrapper's scope. Opening is the caller's job (an
// external trigger, e.g. the `modal-open` controller, calls `dialog.showModal()`
// by id), which needs JS but lives outside this component's scope.
export default class extends Controller {
  static targets = ['dialog']

  close() {
    this.dialogTarget.close()
  }
}
