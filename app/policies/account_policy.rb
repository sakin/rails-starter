# frozen_string_literal: true

# Authorization policy for the account surface. Reference usage of the policy
# layer: `show?` branches on whether the acting user owns the record being
# viewed, giving the application an allowed/denied branch to demonstrate.
class AccountPolicy < ApplicationPolicy
  def show?
    record == user
  end
end
