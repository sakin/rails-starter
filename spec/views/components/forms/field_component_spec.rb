# frozen_string_literal: true

RSpec.describe(Forms::Field::Component, type: :view_component) do
  subject(:rendered) do
    render_inline(described_class.new(label:, error_message:)) do
      '<input class="input" />'.html_safe
    end
  end

  let(:label) { "Email address" }
  let(:error_message) { nil }

  it "renders the label above the yielded control" do
    expect(rendered).to have_css("label.c-forms--field-label", text: label)
    expect(rendered).to have_css("input.input")
  end

  context "with an error" do
    let(:error_message) { "can't be blank" }

    it "renders the error message" do
      expect(rendered).to have_css(".c-forms--field-error", text: "can't be blank")
    end
  end
end
