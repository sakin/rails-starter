# frozen_string_literal: true

# Preview the field wrapper at /lookbook via the sidecar `preview.html.erb`
# template. The `show_error` Lookbook param toggles the validation-error state
# (error message + red control styling).
class Forms::Field::Preview < ApplicationViewComponentPreview
  # @param show_error [Boolean] "Show a validation error"
  def default(show_error: false)
    render_with(show_error:)
  end
end
