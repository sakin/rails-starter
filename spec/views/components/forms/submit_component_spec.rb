# frozen_string_literal: true

RSpec.describe(Forms::Submit::Component, type: :view_component) do
  subject(:rendered) { render_inline(described_class.new(label: "Sign in")) }

  it "renders a submit button with daisyUI primary styling" do
    expect(rendered).to have_button("Sign in", type: "submit")
    expect(rendered).to have_css("button.btn.btn-primary")
  end

  context "with an outline variant" do
    subject(:rendered) { render_inline(described_class.new(label: "Save", variant: :outline)) }

    it "renders the outline button variant" do
      expect(rendered).to have_css("button.btn.btn-outline")
    end
  end

  context "with a ghost variant" do
    subject(:rendered) { render_inline(described_class.new(label: "Save", variant: :ghost)) }

    it "renders the ghost button variant" do
      expect(rendered).to have_css("button.btn.btn-ghost")
    end
  end

  context "with a caller class" do
    subject(:rendered) { render_inline(described_class.new(label: "Save", class: "w-full")) }

    it "keeps the variant classes and adds the caller's" do
      expect(rendered).to have_css("button.btn.btn-primary.w-full")
    end
  end
end
