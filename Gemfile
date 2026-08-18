source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.1.3", ">= 8.1.3.1"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"
# Use sqlite3 as the database for Active Record
gem "sqlite3", ">= 2.1"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

# Frontend built by Vite, run by a Bun runtime bundled into the gem bundle.
# No Node/npm/yarn anywhere — the Bun binary comes from bundlebun, versioned in
# the lockfile. [https://vite-ruby.netlify.app/]
gem "vite_rails"
gem "bundlebun"

# View components: author the view layer as testable, object-oriented components
# under a sidecar convention. [https://viewcomponent.org/]
gem "view_component"
# Extension on top of ViewComponent: typed initializer args, wrapped helper,
# preview base classes, and a project-owned component generator.
gem "view_component-contrib"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Behavior-driven test framework replacing the stock Minitest harness
  gem "rspec-rails"

  # Audits gems for known security defects (use config/bundler-audit.yml to ignore issues)
  gem "bundler-audit", require: false

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Live component/UI preview environment. Development-only so preview URLs are
  # never exposed in production. [https://lookbook.build/]
  gem "lookbook"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  # Headless Chromium driver for Capybara, talking CDP via Ferrum. No driver
  # binary to version-match, and no Node required. The system-test driver.
  gem "cuprite"
  # Test factories
  gem "factory_bot_rails"
  gem "faker"
  # Stub-friendly HTTP: disallow live outbound connections in the suite
  gem "webmock"
  # N+1 query guard usable as an RSpec matcher
  gem "n_plus_one_control"
  # Test-suite profiling
  gem "stackprof"
end
