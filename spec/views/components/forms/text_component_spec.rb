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

    it "wraps the input in a label-floating field" do
      expect(rendered).to have_css("label.label-floating[data-controller='forms--text']")
      expect(rendered).to have_css("label.label-floating span.label-text", text: "Email")
    end

    it "uses the co-located forms--text controller with wired actions" do
      input = rendered.at_css("label[data-controller='forms--text'] input")
      expect(input["data-action"]).to eq(
        "focus->forms--text#focus blur->forms--text#blur input->forms--text#input"
      )
      expect(input["data-forms--text-target"]).to eq("input")
    end
  end
end
