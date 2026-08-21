# frozen_string_literal: true

RSpec.describe(Modal::Component, type: :view_component) do
  subject(:rendered) do
    render_inline(described_class.new(id: "confirm", title: "Confirm", trigger_label: "Open")) do
      "Are you sure?"
    end
  end

  it "renders a wrapper mounting the modal controller and an open trigger" do
    expect(rendered).to have_css("[data-controller='modal']")
    expect(rendered).to have_css("button[data-action='click->modal#open']", text: "Open")
  end

  it "renders a daisyUI dialog with the settled id and title" do
    expect(rendered).to have_css("dialog.modal#confirm")
    expect(rendered).to have_css("dialog.modal .modal-box h3", text: "Confirm")
  end

  it "yields content and a close action inside the dialog" do
    expect(rendered).to have_css("dialog.modal .modal-box", text: "Are you sure?")
    expect(rendered).to have_css("button[data-action='click->modal#close']", text: "Close")
  end

  describe "base component arguments" do
    subject(:rendered) do
      render_inline(described_class.new(id: "m", title: "T", class: "w-full", data: { foo: "bar" }, attrs: { role: "dialog" }))
    end

    it "applies caller class/data/attrs to the wrapper" do
      expect(rendered).to have_css("div[data-controller='modal'].w-full[data-foo='bar'][role='dialog']")
    end
  end
end
