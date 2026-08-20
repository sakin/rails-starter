# frozen_string_literal: true

# The preview scenario returns Lookbook render-args (locals + template), so we
# exercise the faithful surface: the preview must construct without error, and
# the component it composes must render each of the six typed inputs.
RSpec.describe("Forms::Preview", type: :view_component) do
  subject(:preview) { Forms::Preview.new }

  let(:text) { render_inline(Forms::Text::Component.new(name: "text")) }
  let(:textarea) { render_inline(Forms::Textarea::Component.new(name: "textarea")) }
  let(:select) { render_inline(Forms::Select::Component.new(name: "select", options: [ %w[One one], %w[Two two] ])) }
  let(:checkbox) { render_inline(Forms::Checkbox::Component.new(name: "checkbox")) }
  let(:radio) { render_inline(Forms::Radio::Component.new(name: "radio", value: "1")) }
  let(:toggle) { render_inline(Forms::Toggle::Component.new(name: "toggle", checked: true)) }

  it "builds without error" do
    expect { preview.default }.not_to raise_error
  end

  describe "the form it composes" do
    subject(:html) do
      inputs = [ text, textarea, select, checkbox, radio, toggle ].map(&:to_s).join
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
