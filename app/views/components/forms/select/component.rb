# frozen_string_literal: true

# Bare `<select>` dropdown. Renders the element with given label/value option
# pairs plus the base attrs; no label/blank-option handling beyond `include_blank`.
class Forms::Select::Component < ApplicationViewComponent
  option :name
  option :options, default: -> { [] }
  option :selected, default: -> { nil }
  option :include_blank, default: -> { false }

  def root_options
    element_attrs(
      name: name,
      class: "select select-bordered w-full"
    )
  end
end
