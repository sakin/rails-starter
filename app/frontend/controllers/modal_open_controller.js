import { Controller } from '@hotwired/stimulus'

// External, caller-owned trigger for a modal rendered as a native `<dialog>`.
// The modal is a pure window and owns only dismissal; this controller is how a
// button outside the modal's wrapper opens it. It needs the dialog's `id` to
// call `showModal()`, which is the one thing an external caller must know.
//
//   <button data-controller="modal-open"
//           data-modal-open-id-value="my-dialog"
//           data-action="click->modal-open#open">Open</button>
export default class extends Controller {
  static values = { id: String }

  open() {
    document.getElementById(this.idValue)?.showModal()
  }
}
