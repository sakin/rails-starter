# frozen_string_literal: true

# Bare multi-line text area. Renders only the `<textarea>` element from the
# essential `name`/`value`/`rows` options plus the base attrs.
class Forms::Textarea::Component < ApplicationViewComponent
  option :name
  option :value, default: -> { nil }
  option :rows, type: Dry::Types["params.integer"], default: -> { 3 }

  def root_options
    element_attrs(
      name: name,
      rows: rows,
      class: "textarea textarea-bordered w-full"
    )
  end
end
