# frozen_string_literal: true

# Bare single-line text input. Renders only the `<input>` element from the
# given attributes; labels/wrapping are the caller's concern.
#
# With `floating_label: true` + a `label:` it instead renders a daisyUI
# `label-floating` wrapper and mounts the co-located `forms--text` stimulus
# controller, which floats the label into the border on focus/value.
class Forms::Text::Component < ApplicationViewComponent
  option :name
  option :value, default: -> { nil }
  option :type, default: -> { "text" }
  option :input_html, default: -> { {} }
  option :floating_label, default: -> { false }
  option :label, default: -> { nil }

  def html_options
    input_html.merge(name: name, type: type, value: value)
  end
end
