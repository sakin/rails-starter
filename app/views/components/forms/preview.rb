# frozen_string_literal: true

# Preview the full forms family assembled into one `<form>` at /lookbook. Renders
# through the same `component` helper the app uses (opinionated previews, so Lookbook
# output == app output) and composes all six typed inputs plus the submit button.
class Forms::Preview < ApplicationViewComponentPreview
  def default
    render_with
  end
end
