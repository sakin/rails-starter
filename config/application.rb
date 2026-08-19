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

    # Load the app's generator overrides (namespaced-view paths) when generating.
    require "rails_startup_stack/view_overrides"

    # View components live under `app/views/components` as sidecar folders — one
    # folder per component holding `component.rb`, `component.html.erb`,
    # `preview.rb` and `styles.css` (styles are bundled by an entrypoint glob over
    # `**/styles.css`; no per-component JS). `app/views` is a Rails view autoload
    # root, so register the components subdirectory explicitly as a Ruby autoload
    # root.
    config.autoload_paths << Rails.root.join("app", "views", "components")

    # ViewComponent wiring (see issue 03).
    config.view_component.generate.path = "app/views/components"
    config.view_component.generate.sidecar = true
    config.view_component.generate.preview = true
    config.view_component.generate.parent_class = "ApplicationViewComponent"
    # Previews and components live in the same sidecar folders, so the two
    # directories are one and the same.
    config.view_component.previews.paths << Rails.root.join("app", "views", "components")

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
