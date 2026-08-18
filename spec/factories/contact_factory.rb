# frozen_string_literal: true

require "faker"

# Minimal factory reference proving the FactoryBot harness is wired, without
# depending on a product model (those arrive with the auth ticket). `Contact` is
# a plain Ruby object so `build` needs no database; Faker supplies demo data.
Contact = Struct.new(:name, :email, keyword_init: true) unless defined?(Contact)

FactoryBot.define do
  factory :contact, class: "Contact" do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
  end
end
