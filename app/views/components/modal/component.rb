# frozen_string_literal: true

# A daisyUI modal rendered as a `<dialog>`. It is a pure window: the wrapper
# mounts the co-located `modal` Stimulus controller, whose `close` action the
# backdrop and close button call (`dialog.close()`). Opening is the caller's job
# via an external trigger (e.g. the `modal-open` controller targeting the dialog
# `id`). Content is yielded into the modal box. The base `attrs`/`class`/`data`
# arguments apply to the wrapper; `id` targets the dialog element.
class Modal::Component < ApplicationViewComponent
  option :title
  option :close_label, default: -> { "Close" }

  def wrapper_options
    element_options.except(:id)
  end

  private

  def merged
    wrapper_options.deep_merge(data: { controller: controller_name })
  end
end
