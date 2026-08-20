# frozen_string_literal: true

UserRecord = Struct.new(:email, :message, :status, keyword_init: true)

RSpec.describe(FormBuilder, type: :view) do
  subject(:builder) { described_class.new(:user, user, self, {}) }

  let(:user) { UserRecord.new(email: "you@example.com") }

  it "composes a labeled field + text control for text_field" do
    html = builder.text_field(:email, label: "Email address")

    expect(html).to have_css(".c-forms--field-root label.c-forms--field-label", text: "Email address")
    expect(html).to have_css("input[type='text'][name='user[email]'][value='you@example.com']")
  end

  it "skips the field wrapper when label is false" do
    html = builder.text_field(:email, label: false)

    expect(html).not_to have_css(".c-forms--field-root")
    expect(html).to have_css("input[type='text'][name='user[email]']")
  end

  it "renders an error message inside the field wrapper" do
    html = builder.text_field(:email, label: "Email", error_message: "can't be blank")

    expect(html).to have_css(".c-forms--field-error", text: "can't be blank")
  end

  it "maps text_area to a textarea control" do
    html = builder.text_area(:message, label: "Message")

    expect(html).to have_css(".c-forms--field-root textarea[name='user[message]']")
  end

  it "maps select with options" do
    html = builder.select(:status, [ %w[Active active], %w[Archived archived] ], { label: "Status" })

    expect(html).to have_css(".c-forms--field-root select[name='user[status]']")
    expect(html).to have_css("option[value='active']", text: "Active")
  end

  it "maps check_box to a checkbox control" do
    html = builder.check_box(:email, { label: false })

    expect(html).to have_css("input[type='checkbox'][name='user[email]'].checkbox")
  end

  it "maps radio_button to a radio control" do
    html = builder.radio_button(:status, "pro", { label: false })

    expect(html).to have_css("input[type='radio'][name='user[status]'][value='pro'].radio")
  end

  it "maps toggle to a toggle control" do
    html = builder.toggle(:enabled, { label: false })

    expect(html).to have_css("input[type='checkbox'][name='user[enabled]'].toggle")
  end

  it "maps submit to the submit component" do
    html = builder.submit("Sign in")

    expect(html).to have_button("Sign in", type: "submit")
  end
end
