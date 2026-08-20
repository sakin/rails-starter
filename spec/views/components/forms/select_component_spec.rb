# frozen_string_literal: true

RSpec.describe(Forms::Select::Component, type: :view_component) do
  subject(:rendered) do
    render_inline(described_class.new(name: "status", options: [ %w[Active active], %w[Archived archived] ]))
  end

  it "renders a select with the given options" do
    expect(rendered).to have_css("select[name='status']")
    expect(rendered).to have_css("option[value='active']", text: "Active")
    expect(rendered).to have_css("option[value='archived']", text: "Archived")
  end
end
