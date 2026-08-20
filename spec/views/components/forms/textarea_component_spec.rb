# frozen_string_literal: true

RSpec.describe(Forms::Textarea::Component, type: :view_component) do
  subject(:rendered) do
    render_inline(described_class.new(name: "message", value: "Hello", rows: 4))
  end

  it "renders a textarea with the given name, value, and rows" do
    expect(rendered).to have_css("textarea[name='message'][rows='4']", text: "Hello")
  end
end
