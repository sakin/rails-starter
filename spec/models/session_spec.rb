# frozen_string_literal: true

require "rails_helper"

RSpec.describe Session, type: :model do
  subject(:session) { build(:session) }

  it "is valid with a user" do
    expect(session).to be_valid
  end

  it "belongs to a user" do
    expect(session.user).to be_a(User)
  end

  it "records the sign-in device context" do
    session.save!
    expect(session.reload).to have_attributes(
      ip_address: "127.0.0.1",
      user_agent: "RSpec"
    )
  end
end
