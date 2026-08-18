# frozen_string_literal: true

# Proves the factory harness is initialized: definition files load (spec/factories/*.rb
# is auto-required by factory_bot_rails), FactoryBot's syntax is available to specs,
# and Faker supplies demo data.
RSpec.describe "FactoryBot wiring" do
  it "builds objects through a factory definition" do
    contact = build(:contact)

    expect(contact).to be_a(Contact)
    expect(contact.name).to be_present
    expect(contact.email).to match(URI::MailTo::EMAIL_REGEXP)
  end

  it "builds many objects at once" do
    contacts = build_list(:contact, 3)

    expect(contacts.length).to eq(3)
    expect(contacts).to all(be_a(Contact))
    expect(contacts.map(&:email).uniq.size).to eq(3) # Faker::Internet.unique
  end
end
