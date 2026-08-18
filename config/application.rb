require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsStarter
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks generators])

    # View components live under `app/frontend/components` as sidecar folders —
    # one folder per component holding `component.rb`, `component.html.erb`,
    # `preview.rb` and `index.css`. Register that directory as a Ruby autoload
    # root (it sits under `app/frontend` which Rails would otherwise treat as a
    # namespace, not a plain load path).
    config.autoload_paths << Rails.root.join("app", "frontend", "components")

    # ViewComponent wiring (see issue 03).
    config.view_component.generate.path = "app/frontend/components"
    config.view_component.generate.sidecar = true
    config.view_component.generate.preview = true
    config.view_component.generate.parent_class = "ApplicationViewComponent"
    # Previews and components live in the same sidecar folders, so the two
    # directories are one and the same.
    config.view_component.previews.paths << Rails.root.join("app", "frontend", "components")

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
