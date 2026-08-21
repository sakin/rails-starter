# frozen_string_literal: true

RSpec.describe(Forms::Text::Component, type: :view_component) do
  subject(:rendered) do
    render_inline(described_class.new(name: "email_address", value: "you@example.com"))
  end

  it "renders a text input with the given name and value" do
    expect(rendered).to have_css("input[type='text'][name='email_address'][value='you@example.com']")
  end

  context "with extra attrs" do
    subject(:rendered) do
      render_inline(described_class.new(name: "email", attrs: { required: true, placeholder: "hi" }))
    end

    it "passes them through as element attributes" do
      expect(rendered).to have_css("input[required='required'][placeholder='hi']")
    end
  end

  context "with a root class arg" do
    subject(:rendered) do
      render_inline(described_class.new(name: "email", class: "foo px-3"))
    end

    it "combines it with the component default class" do
      expect(rendered).to have_css("input.px-3.foo")
    end
  end

  context "with a floating label" do
    subject(:rendered) do
      render_inline(described_class.new(name: "email", value: "", floating_label: true, label: "Email"))
    end

    it "wraps a span + input in a daisyUI floating-label field for CSS-driven float" do
      expect(rendered).to have_css("label.floating-label:not([data-controller])")
      expect(rendered).to have_css("label.floating-label > span", text: "Email")
      expect(rendered).to have_css("label.floating-label > span + input[type='text'][name='email']")
    end

    it "is driven purely by daisyUI CSS, not a stimulus controller" do
      expect(rendered).not_to have_css("data-controller")
    end
  end
end
