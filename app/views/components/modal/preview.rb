# frozen_string_literal: true

# Preview the modal at /lookbook. Clicking the trigger opens the native dialog
# via the co-located `modal` controller; the backdrop or Close dismisses it.
class Modal::Preview < ApplicationViewComponentPreview
  def default
    render_component Modal::Component.new(id: "modal-preview", title: "Modal preview") do
      "<p class='py-4'>This modal is opened with <code>dialog.showModal()</code> and can be dismissed from the backdrop or the Close button.</p>".html_safe
    end
  end
end
