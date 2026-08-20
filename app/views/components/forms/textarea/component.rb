# frozen_string_literal: true

# Bare multi-line text area. Renders only the `<textarea>` element.
class Forms::Textarea::Component < ApplicationViewComponent
  option :name
  option :value, default: -> { nil }
  option :rows, default: -> { 3 }
  option :input_html, default: -> { {} }

  def html_options
    input_html.merge(name: name, rows: rows)
  end
end
