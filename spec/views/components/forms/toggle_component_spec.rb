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
end
