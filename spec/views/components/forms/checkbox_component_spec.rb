# frozen_string_literal: true

RSpec.describe(Forms::Checkbox::Component, type: :view_component) do
  subject(:rendered) do
    render_inline(described_class.new(name: "subscribe", checked: true))
  end

  it "renders a checked checkbox with the given name" do
    expect(rendered).to have_css("input[type='checkbox'][name='subscribe'][value='1']")
    expect(rendered).to have_css("input[checked='checked']")
  end
end
