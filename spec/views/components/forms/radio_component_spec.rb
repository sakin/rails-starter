# frozen_string_literal: true

RSpec.describe(Forms::Radio::Component, type: :view_component) do
  subject(:rendered) do
    render_inline(described_class.new(name: "plan", value: "pro"))
  end

  it "renders a radio button with the given name and value" do
    expect(rendered).to have_css("input[type='radio'][name='plan'][value='pro']")
  end
end
