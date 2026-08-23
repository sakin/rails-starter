# frozen_string_literal: true

RSpec.describe(Forms::Radio::Component, type: :view_component) do
  subject(:rendered) do
    render_inline(described_class.new(name: "plan", value: "pro"))
  end

  it "renders a radio button with the given name and value" do
    expect(rendered).to have_css("input[type='radio'][name='plan'][value='pro']")
  end

  context "with extra attrs" do
    subject(:rendered) do
      render_inline(described_class.new(name: "plan", value: "pro", attrs: { disabled: true }))
    end

    it "passes them through" do
      expect(rendered).to have_css("input[disabled='disabled']")
    end
  end

  context "with a stringy false checked (from a param)" do
    subject(:rendered) do
      render_inline(described_class.new(name: "plan", value: "pro", checked: "false"))
    end

    it "coerces it to an unchecked input" do
      expect(rendered).not_to have_css("input[checked]")
    end
  end
end
