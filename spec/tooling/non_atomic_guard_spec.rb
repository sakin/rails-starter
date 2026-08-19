# frozen_string_literal: true

require "rails_helper"

# The non-atomic-IO guard (Isolator) must be wired into the suite and trip on
# real violations. These examples prove that a side effect inside a transaction
# raises, and that the identical side effect is fine outside one.
RSpec.describe "Non-atomic IO guard (Isolator)" do
  class IsolatorProbeJob < ApplicationJob
    def perform(*)
      # Intentionally a no-op: we only care whether enqueueing is flagged.
    end
  end

  it "raises when a background job is enqueued inside a transaction" do
    expect do
      # A real, independently-transacted boundary (a savepoint) beyond the
      # rails_helper fixture baseline. Rails 8.1 only emits a new transaction
      # event once the block actually materializes on the DB — so we force a
      # write here. (Ordinary joinable `transaction do` blocks merge into the
      # existing transaction and Isolator correctly treats that as the
      # baseline, not a distinct transaction.)
      ActiveRecord::Base.transaction(requires_new: true) do
        create(:user)
        IsolatorProbeJob.perform_later
      end
    end.to raise_error(Isolator::BackgroundJobError)
  end

  it "does not raise for the same enqueue outside a transaction" do
    expect do
      IsolatorProbeJob.perform_later
    end.not_to raise_error
  end
end
