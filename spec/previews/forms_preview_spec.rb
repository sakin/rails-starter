# frozen_string_literal: true

# The Forms::Preview documents the whole family in two Lookbook scenes — `default`
# and `builder` — assembled into one `<form>`. Both scenes have a `show_errors`
# toggle (a Lookbook param) that flips every field into its error state, so the
# field-inclusive error path is documented too.
RSpec.describe("Forms::Preview", type: :view_component) do
  %i[default builder].each do |scene|
    describe "the #{scene} scene" do
      it "renders all six typed inputs plus submit" do
        html = render_preview(scene, from: Forms::Preview)

        expect(html).to have_css("form .c-forms--field-root", count: 6)
        expect(html).to have_css("form .c-forms--field-root input[type='text']")
        expect(html).to have_css("form .c-forms--field-root textarea")
        expect(html).to have_css("form .c-forms--field-root select")
        expect(html).to have_css("form .c-forms--field-root input[type='checkbox'].checkbox")
        expect(html).to have_css("form .c-forms--field-root input[type='radio']")
        expect(html).to have_css("form .c-forms--field-root input[type='checkbox'].toggle")
        expect(html).to have_css("form button[type='submit']")
      end

      it "shows no field errors by default" do
        html = render_preview(scene, from: Forms::Preview)
        expect(html).to have_css("form .c-forms--field-error", count: 0)
      end

      it "shows an error on each field when show_errors is on" do
        html = render_preview(scene, from: Forms::Preview, params: { show_errors: true })

        expect(html).to have_css("form .c-forms--field-error", count: 6)
        expect(html).to have_css("form .c-forms--field-error", text: "can't be blank")
        expect(html).to have_css("form .c-forms--field-error", text: "must be accepted")
      end
    end
  end
end
