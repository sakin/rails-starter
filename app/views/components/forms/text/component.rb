# frozen_string_literal: true

# Bare single-line text input. Renders only the `<input>` element from the
# essential `name`/`value`/`type` options plus the base `attrs`/`class`/`id`/
# `data` arguments; labels/wrapping are the caller's concern.
#
# With `variant: :floating` + a `label:` it instead renders daisyUI's
# `floating-label` wrapper (span before the input). daisyUI floats the label
# with pure CSS via `:placeholder-shown`/`:focus`, so no Stimulus controller is
# needed.
class Forms::Text::Component < ApplicationViewComponent
  option :name
  option :value, default: -> { nil }
  option :type, default: -> { "text" }
  option :variant, type: ->(value) { value.to_sym }, default: -> { :default }
  option :label, default: -> { nil }

  def floating?
    variant == :floating
  end

  def root_options
    options = {
      name: name,
      type: type,
      value: value,
      class: "input input-bordered w-full"
    }
    # daisyUI's float keys off `:placeholder-shown`, which needs a placeholder
    # attribute present; ensure one exists so the label always floats correctly.
    options[:placeholder] ||= "" if floating?
    element_attrs(options)
  end
end
