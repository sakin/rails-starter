# frozen_string_literal: true

RSpec.describe(Forms::Form::Component, type: :view_component) do
  subject(:rendered) do
    render_inline(described_class.new(action: "/sign-in", method: :post)) do
      '<input class="input" />'.html_safe
    end
  end

  it "renders a <form> with the given action and method" do
    expect(rendered).to have_css("form[action='/sign-in'][method='post']")
  end

  it "yields its block inside the form" do
    expect(rendered).to have_css("form input.input")
  end

  it "coerces a string method to a symbol" do
    expect(described_class.new(action: "/", method: "post").method).to eq(:post)
  end
end
