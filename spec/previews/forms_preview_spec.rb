# frozen_string_literal: true

# The Forms::Preview renders the whole family through a preview template that
# composes the same `component` calls the app uses. Exercising it directly lets
# us assert the form scene renders all six typed inputs.
RSpec.describe("Forms::Preview", type: :view_component) do
  subject(:preview) { Forms::Preview.new }

  it "builds without error" do
    expect { preview.default }.not_to raise_error
    expect { preview.builder }.not_to raise_error
  end

  describe "the rendered form scene" do
    subject(:html) { render_inline_form }

    # Render a plain <form> wrapping the six controls, mirroring the preview's
    # composition, so the render surfaces are tested without Lookbook.
    def render_inline_form
      inputs = [
        Forms::Text::Component.new(name: "text"),
        Forms::Textarea::Component.new(name: "textarea"),
        Forms::Select::Component.new(name: "select", options: [ %w[One one], %w[Two two] ]),
        Forms::Checkbox::Component.new(name: "checkbox"),
        Forms::Radio::Component.new(name: "radio", value: "1"),
        Forms::Toggle::Component.new(name: "toggle", checked: true)
      ].map { render_inline(_1) }.map(&:to_s).join

      render_inline(Forms::Form::Component.new(action: "/", method: :post)) { inputs.html_safe }
    end

    it "wraps the inputs in a form element" do
      expect(html).to have_css("form[action='/']")
    end

    it "renders all six typed inputs" do
      expect(html).to have_css("input[type='text'][name='text']")
      expect(html).to have_css("textarea[name='textarea']")
      expect(html).to have_css("select[name='select']")
      expect(html).to have_css("input[type='checkbox'][name='checkbox']")
      expect(html).to have_css("input[type='radio'][name='radio']")
      expect(html).to have_css("input[type='checkbox'][name='toggle']")
    end
  end
end
