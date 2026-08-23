# frozen_string_literal: true

RSpec.describe(Forms::Toggle::Component, type: :view_component) do
  subject(:rendered) do
    render_inline(described_class.new(name: "enabled", checked: true))
  end

  it "renders a toggle checkbox with the given name" do
    expect(rendered).to have_css("input[type='checkbox'][name='enabled']")
  end

  context "with extra attrs" do
    subject(:rendered) do
      render_inline(described_class.new(name: "enabled", attrs: { disabled: true }))
    end

    it "passes them through" do
      expect(rendered).to have_css("input[disabled='disabled']")
    end
  end

  context "with a stringy false checked (from a param)" do
    subject(:rendered) do
      render_inline(described_class.new(name: "enabled", checked: "false"))
    end

    it "coerces it to an unchecked input" do
      expect(rendered).not_to have_css("input[checked]")
    end
  end
end
