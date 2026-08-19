# frozen_string_literal: true

RSpec.describe(Flash::Component, type: :view_component) do
  subject(:rendered) { render_inline(component) }

  let(:component) { described_class.new(messages:) }

  describe "with explicit messages" do
    let(:messages) { { notice: "Signed up.", alert: "Try again." } }

    it "renders a styled alert per message" do
      expect(rendered).to have_css("div.alert.alert-success", text: "Signed up.")
      expect(rendered).to have_css("div.alert.alert-error", text: "Try again.")
    end
  end

  describe "with no messages" do
    let(:messages) { {} }

    it "renders nothing" do
      expect(rendered).not_to have_css("div.alert")
    end
  end
end
