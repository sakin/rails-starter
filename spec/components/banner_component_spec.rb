# frozen_string_literal: true

RSpec.describe(Banner::Component, type: :component) do
  subject(:rendered) { render_inline(component) }

  let(:component) { described_class.new(title: "Welcome") }

  it "renders the title" do
    expect(rendered).to have_css("h2", text: "Welcome")
  end

  it "scopes its CSS classes with the component token" do
    expect(rendered).to have_css(".c-banner-root")
    expect(rendered).to have_css(".c-banner-eyebrow")
  end

  it "resolves string keys against the component i18n scope" do
    expect(rendered).to have_text("Rails Starter")
  end

  it "renders a nested component" do
    expect(rendered).to have_css(".c-badge-root", text: "ViewComponent")
  end

  it "requires its named arguments" do
    expect { described_class.new }.to raise_error(ArgumentError)
  end
end
