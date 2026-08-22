# frozen_string_literal: true

# The Forms::Preview documents the whole family in two Lookbook scenes — `default`
# and `builder` — assembled into one `<form>`. Both must actually render the six
# typed inputs plus the submit button (not just return render args, and not blank),
# so Lookbook isn't broken.
RSpec.describe("Forms::Preview", type: :view_component) do
  it "renders the builder scene with all six typed inputs" do
    html = render_preview(:builder, from: Forms::Preview)

    expect(html).to have_css("form .c-forms--field-root", count: 6)
    expect(html).to have_css("form .c-forms--field-root input[type='text']")
    expect(html).to have_css("form .c-forms--field-root textarea")
    expect(html).to have_css("form .c-forms--field-root select")
    expect(html).to have_css("form .c-forms--field-root input[type='checkbox'].checkbox")
    expect(html).to have_css("form .c-forms--field-root input[type='radio']")
    expect(html).to have_css("form .c-forms--field-root input[type='checkbox'].toggle")
    expect(html).to have_css("form button[type='submit']")
  end

  it "renders the default scene with all six typed inputs" do
    html = render_preview(:default, from: Forms::Preview)

    expect(html).to have_css("form .c-forms--field-root", count: 6)
    expect(html).to have_css("form .c-forms--field-root input[type='text']")
    expect(html).to have_css("form .c-forms--field-root textarea")
    expect(html).to have_css("form .c-forms--field-root select")
    expect(html).to have_css("form .c-forms--field-root input[type='checkbox'].checkbox")
    expect(html).to have_css("form .c-forms--field-root input[type='radio']")
    expect(html).to have_css("form .c-forms--field-root input[type='checkbox'].toggle")
    expect(html).to have_css("form button[type='submit']")
  end
end
