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

  # Wrapper element attrs: the base-merged root args, minus `:id` (the dialog
  # owns the id, so the wrapper doesn't also carry it), plus the co-located
  # `modal` Stimulus controller mounted on the wrapper.
  def element_attrs(defaults = {})
    super(defaults).deep_merge(data: { controller: controller_name }).except(:id)
  end
end
