# frozen_string_literal: true

RSpec.describe(Forms::Submit::Component, type: :view_component) do
  subject(:rendered) { render_inline(described_class.new(label: "Sign in")) }

  it "renders a submit button with daisyUI styling" do
    expect(rendered).to have_button("Sign in", type: "submit")
    expect(rendered).to have_css("button.btn.btn-primary")
  end
end
