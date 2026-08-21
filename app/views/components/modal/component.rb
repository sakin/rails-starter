# frozen_string_literal: true

# A daisyUI modal rendered as a `<dialog>`. The wrapper mounts the co-located
# `modal` Stimulus controller, whose `open`/`close` actions the trigger and
# close buttons call (`dialog.showModal()`/`close()`). Content is yielded into
# the modal box. The base `attrs`/`class`/`data` arguments apply to the wrapper;
# `id` targets the dialog element.
class Modal::Component < ApplicationViewComponent
  option :title
  option :trigger_label, default: -> { "Open" }
  option :close_label, default: -> { "Close" }

  def wrapper_options
    element_options.except(:id)
  end
end
