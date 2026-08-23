# frozen_string_literal: true

# The Forms::Text and Forms::Field previews expose a runtime Lookbook `@param` that
# flips a single showcase between two states, so the dynamic scenario is documented
# without a per-state template. `Text` switches the input `variant`; `Field` toggles
# the validation-error state.
RSpec.describe("Forms::Text and Forms::Field preview params", type: :view_component) do
  describe "Forms::Text::Preview#default" do
    it "renders a bare input by default" do
      html = render_preview(:default, from: Forms::Text::Preview)

      expect(html).not_to have_css("label.floating-label")
      expect(html).to have_css("input[type='text'][name='email']")
    end

    it "renders the floating-label wrapper when variant is :floating" do
      html = render_preview(:default, from: Forms::Text::Preview, params: { variant: :floating })

      expect(html).to have_css("label.floating-label > span", text: "Email address")
      expect(html).to have_css("label.floating-label > span + input[type='text'][name='email']")
    end
  end

  describe "Forms::Field::Preview#default" do
    it "shows no error by default" do
      html = render_preview(:default, from: Forms::Field::Preview)

      expect(html).not_to have_css(".c-forms--field-error")
      expect(html).not_to have_css("input.input-error")
    end

    it "shows the error when show_error is on" do
      html = render_preview(:default, from: Forms::Field::Preview, params: { show_error: true })

      expect(html).to have_css(".c-forms--field-error", text: "can't be blank")
      expect(html).to have_css("input.input-error")
    end
  end
end
