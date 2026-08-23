# frozen_string_literal: true

# Preview the modal at /lookbook via the `previews/default.html.erb` template.
# The external `modal-open` trigger opens the dialog by id; the backdrop or
# Close dismisses it (the modal itself only owns dismissal).
class Modal::Preview < ApplicationViewComponentPreview
  def default
    render_with
  end
end
