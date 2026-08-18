# frozen_string_literal: true

# Factory for the auth reference model. Sessions belong to a person and record
# the device context used to sign in.
FactoryBot.define do
  factory :session do
    user
    ip_address { "127.0.0.1" }
    user_agent { "RSpec" }
  end
end
