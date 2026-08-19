# frozen_string_literal: true

# Loads the app's generator overrides so they win over Railties' generators
# during `bin/rails generate`.
#
# Why this is needed: `bin/rails generate X` resolves generators through a
# targeted `lookup` that `require`s the FIRST matching `*_generator.rb` on the
# load path and returns. For namespaced generators like `erb:controller`,
# Railties' copy is found first, so a sibling under `lib/generators/erb/...`
# would never load. Each file below is therefore required explicitly (so its
# class reopening lands), matching the Railtie `generators do ... end` hook
# documented in `Rails::Railtie`.
module RailsStartupStack
  # A Railtie (not an Engine) so we only register the generator loads without
  # adding route-mounting behavior.
  class ViewOverrides < Rails::Railtie
    generators do
      require "generators/erb/controller/controller_generator"
      require "generators/erb/scaffold/scaffold_generator"
      require "generators/erb/mailer/mailer_generator"
      require "generators/erb/authentication/authentication_generator"
      require "generators/rails/authentication/authentication_generator"
    end
  end
end
