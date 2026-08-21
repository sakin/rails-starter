# frozen_string_literal: true

# Bare single-line text input. Renders only the `<input>` element from the
# essential `name`/`value`/`type` options plus the base `attrs`/`class`/`id`/
# `data` arguments; labels/wrapping are the caller's concern.
#
# With `floating_label: true` + a `label:` it instead renders a daisyUI
# `label-floating` wrapper and mounts the co-located `forms--text` stimulus
# controller, which floats the label into the border on focus/value.
class Forms::Text::Component < ApplicationViewComponent
  option :name
  option :value, default: -> { nil }
  option :type, default: -> { "text" }
  option :floating_label, default: -> { false }
  option :label, default: -> { nil }

  def root_options
    element_options(
      name: name,
      type: type,
      value: value,
      class: "input input-bordered w-full"
    )
  end
end
