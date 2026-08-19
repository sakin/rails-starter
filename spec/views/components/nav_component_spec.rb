# frozen_string_literal: true

RSpec.describe(Nav::Component, type: :view_component) do
  subject(:rendered) { render_inline(component) }

  let(:component) { described_class.new }

  it "renders the application brand with a theme toggle" do
    expect(rendered).to have_link("Rails Starter", href: root_path)
    expect(rendered).to have_css('header[data-controller="theme"] button[data-action="click->theme#toggle"]')
    expect(rendered).to have_button("Theme")
  end

  it "offers sign-in/sign-up for a guest" do
    expect(rendered).to have_link("Sign in", href: new_session_path)
    expect(rendered).to have_link("Sign up", href: new_registration_path)
  end

  context "when signed in" do
    it "offers the account and sign-out actions instead" do
      allow(Current).to receive(:session).and_return(build(:session, user: build(:user)))

      expect(rendered).to have_link("Account", href: account_path)
      expect(rendered).to have_css("form[action='#{session_path}']")
      expect(rendered).to have_button("Sign out")
      expect(rendered).not_to have_link("Sign in")
    end
  end
end
