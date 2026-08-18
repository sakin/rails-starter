# frozen_string_literal: true

# Frontend-swap acceptance: prove the Vite + Tailwind v4 + daisyUI pipeline
# actually compiles and serves styled styles, rather than just emitting utility
# class names in HTML. Two seams: the themed element renders on the page, and
# the served stylesheet contains the generated component rules for it.
RSpec.describe "Frontend build", type: :system do
  it "serves a Tailwind + daisyUI styled home page and its compiled stylesheet" do
    visit "/"

    expect(page).to have_selector("div.alert.alert-success", text: "frontend is running")
    expect(page).to have_button("Primary button", class: "btn-primary")

    css_url = page.first("link[rel=stylesheet]", visible: false)["href"]
    css = page.evaluate_async_script(<<~JS, css_url)
      const done = arguments[arguments.length - 1]
      fetch(arguments[0]).then((r) => r.text()).then(done).catch((e) => done(`ERR: ${e.message}`))
    JS

    expect(css).to include(".alert")
    expect(css).to include(".btn-primary")
  end
end
