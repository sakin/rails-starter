# frozen_string_literal: true

# Bare `<select>` dropdown. Renders the element with given label/value option
# pairs; no label/blank-option handling — that stays with the caller or field.
class Forms::Select::Component < ApplicationViewComponent
  option :name
  option :options, default: -> { [] }
  option :selected, default: -> { nil }
  option :input_html, default: -> { {} }
  option :include_blank, default: -> { false }

  def html_options
    input_html.merge(name: name)
  end
end
