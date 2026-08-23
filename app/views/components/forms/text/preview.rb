# frozen_string_literal: true

# Preview the text input at /lookbook via the sidecar `preview.html.erb`
# template. The `variant` Lookbook param switches between the default bare input
# and daisyUI's floating-label wrapper (see the `variant` option on
# Forms::Text::Component).
class Forms::Text::Preview < ApplicationViewComponentPreview
  # @param variant select ["default", "floating"] "Input style"
  def default(variant: "default")
    render_with(
      name: "email",
      placeholder: "you@example.com",
      variant:,
      label: variant.to_s == "floating" ? "Email address" : nil
    )
  end
end
