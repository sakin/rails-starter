# frozen_string_literal: true

# Base class for the application's authorization policies, the dedicated
# policy layer. A subclass implements one `?` predicate per controller action
# and is instantiated with the acting user and the record being acted upon.
# Naught is fat here: the controller's `authorize` hook dispatches to the
# predicate matching the current action and raises on denial.
class ApplicationPolicy
  # Raised when authorization is denied; ApplicationController rescues it and
  # answers 403 Forbidden.
  NotAuthorizedError = Class.new(StandardError)

  def initialize(user:, record:)
    @user = user
    @record = record
  end

  private

  attr_reader :user, :record
end
