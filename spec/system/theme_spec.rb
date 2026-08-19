# frozen_string_literal: true

# Acceptance for the light/dark theme toggle: the nav switch restyles the app
# (via daisyUI themes on the document root) and the choice survives a reload.
RSpec.describe "Theme toggle", type: :system do
  it "switches and persists the theme across reloads" do
    visit "/"

    before_theme = page.evaluate_script("document.documentElement.dataset.theme")
    expect(before_theme).to be_in(%w[light dark])

    find("button[data-action='click->theme#toggle']").click
    after_theme = page.evaluate_script("document.documentElement.dataset.theme")

    expect(after_theme).not_to eq(before_theme)
    expect(page.evaluate_script("localStorage.getItem('theme')")).to eq(after_theme)

    visit "/"
    expect(page.evaluate_script("document.documentElement.dataset.theme")).to eq(after_theme)
  end
end
