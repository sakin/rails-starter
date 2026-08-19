# frozen_string_literal: true

require "rails_helper"

RSpec.describe AccountPolicy, type: :policy do
  subject(:policy) { described_class.new(user: user, record: account) }

  let(:user) { create(:user) }

  describe "#show?" do
    context "when the viewer owns the account" do
      let(:account) { user }

      it "authorizes viewing" do
        expect(policy.show?).to be(true)
      end
    end

    context "when the viewer does not own the account" do
      let(:account) { create(:user) }

      it "denies viewing" do
        expect(policy.show?).to be(false)
      end
    end
  end
end
