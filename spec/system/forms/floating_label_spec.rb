# frozen_string_literal: true

# Browser test for the co-located `forms--text` floating-label controller. Renders
# the sign-in page (which uses the floating email field, autofocused), then proves
# the label actually floats on focus/value and clears when the field empties and
# loses focus — the JS runs in a real headless browser, not just a markup assertion.
RSpec.describe "Floating label", type: :system do
  matcher :be_floating do
    match { |node| node[:class].to_s.include?("is-floating") }
  end

  it "floats the label on value and clears when emptied and blurred" do
    visit "/session/new"

    field = find("input[name='email_address']")
    wrapper = field.find(:xpath, "ancestor::label[1]")

    field.fill_in(with: "you@example.com")
    expect(wrapper).to be_floating

    # Empty and blur: the floating state drops.
    field.fill_in(with: "")
    field.send_keys(:tab)

    expect(wrapper).not_to be_floating
  end

  it "floats an empty field while focused" do
    visit "/session/new"

    field = find("input[name='email_address']")
    wrapper = field.find(:xpath, "ancestor::label[1]")

    field.click
    expect(wrapper).to be_floating
  end
end
