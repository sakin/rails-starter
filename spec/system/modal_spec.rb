# frozen_string_literal: true

# Browser test that the modal's co-located `modal` controller actually opens and
# closes the native `<dialog>` — real JS in a real browser, on a real routed page
# (the frontend demo home page) so the full app layout and JS bundle load.
RSpec.describe "Modal", type: :system do
  matcher :be_open do
    match { |node| node[:open] }
  end

  it "opens and closes the dialog via its controller" do
    visit "/"

    dialog = find("dialog.modal", id: "starter-modal", visible: :all)
    expect(dialog).not_to be_open

    click_on "Open"
    expect(dialog).to be_open

    click_on "Close"
    expect(dialog).not_to be_open
  end
end
