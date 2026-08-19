# frozen_string_literal: true

RSpec.describe(Mailer::Component, type: :view_component) do
  subject(:rendered) { render_inline(component) }

  let(:component) { described_class.new(subject: "Welcome", html: "<p>Hello</p>") }

  it "renders the subject" do
    expect(rendered).to have_css(".mailer-preview__subject", text: "Welcome")
  end

  it "isolates the generated mailer HTML in an iframe" do
    iframe = rendered.at_css("iframe.mailer-preview__frame")
    expect(iframe).to be_present
    expect(iframe["srcdoc"]).to include("Hello")
  end

  it "requires its declared arguments" do
    expect { described_class.new }.to raise_error(KeyError, /required/)
  end
end
