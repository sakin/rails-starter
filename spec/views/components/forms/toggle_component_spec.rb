# frozen_string_literal: true

RSpec.describe(Forms::Toggle::Component, type: :view_component) do
  subject(:rendered) do
    render_inline(described_class.new(name: "enabled", checked: true))
  end

  it "renders a checkbox toggle with the given name" do
    expect(rendered).to have_css("input[type='checkbox'][name='enabled']")
  end
end
