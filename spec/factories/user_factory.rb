# frozen_string_literal: true

require "faker"

# Factory for the auth reference model. Passwords keep a fixed known value so
# features can sign in with `password: "password"`.
FactoryBot.define do
  factory :user do
    email_address { Faker::Internet.unique.email }
    password { "password" }
  end
end
