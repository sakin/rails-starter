# frozen_string_literal: true

# Renames the starter's baked-in name across the config/debug surfaces. The
# logic is a pure text transform over an injectable file list so it can be
# tested against scratch copies; the rake task (lib/tasks/rename_to.rake) and
# bin/rename_to drive it against the real files.
#
# By design this only touches the config/debug surfaces named in the ticket —
# the application module, the Kamal deploy service/image, the PWA manifest, and
# the Docker image references. User-facing display strings and the specs that
# assert them intentionally keep reading "Rails Starter", so a renamed app still
# boots and passes the suite. See `.help` for the manual fallback checklist.
module RenameTo
  OLD = {
    slug: "rails_starter",
    module: "RailsStarter",
    display: "Rails Starter"
  }.freeze

  # The four config/debug surfaces that get renamed.
  TARGET_FILES = %w[
    config/application.rb
    config/deploy.yml
    app/views/pwa/manifest.json.erb
    Dockerfile
  ].freeze

  class << self
    # Derives the three naming forms from a user-supplied <app-name>.
    #   "my_app"  -> { slug: "my_app",  module: "MyApp",   display: "My App" }
    #   "MyApp"   -> { slug: "my_app",  module: "MyApp",   display: "My App" }
    #   "my-app"  -> { slug: "my_app",  module: "MyApp",   display: "My App" }
    def names(app_name)
      words = camel_words(app_name).map(&:capitalize)
      {
        slug: words.join("_").downcase,
        module: words.join,
        display: words.join(" ")
      }
    end

    # Split an app name into its component words on underscore/dash and camel
    # boundaries: "my_app", "my-app", "MyApp" and "myApp" all -> %w[my app].
    def camel_words(app_name)
      app_name.to_s.strip
              .gsub(/([a-z\d])([A-Z])/, '\1 \2')
              .gsub(/[_-]/, " ")
              .split
    end

    # Replaces the old starter tokens in the given files with the new tokens
    # derived from app_name. Returns a report (per-file list of changed tokens).
    # Idempotent: running again with the same name is a no-op.
    def apply!(files:, app_name:)
      new_names = names(app_name)
      mapping = {
        OLD[:slug] => new_names[:slug],
        OLD[:module] => new_names[:module],
        OLD[:display] => new_names[:display]
      }

      files.map do |path|
        changed = rewrite(path, mapping)
        File.exist?(path) ? [ path, changed ] : [ path, :missing ]
      end
    end

    def help
      <<~TXT
        bin/rename_to <app-name>

        Renames the starter's baked-in name across the config/debug surfaces:
          * application module        config/application.rb
          * Kamal deploy              config/deploy.yml (service, image, volume)
          * PWA manifest              app/views/pwa/manifest.json.erb
          * Docker image references   Dockerfile

        Display strings and specs are deliberately left as "Rails Starter", so
        the renamed app still boots and passes the test suite.

        Manual fallback checklist (for a full, app-wide rename):
          * Copy/layout that still reads "Rails Starter":
              app/views/layouts/application.html.erb
              app/views/pages/home.html.erb
              app/views/components/layout/component.rb
              app/views/components/layout/preview.rb
              app/views/components/nav/component.rb
              app/views/components/banner/preview.rb
          * config/locales/en.yml  (the banner eyebrow)
          * Specs asserting "Rails Starter":
              spec/requests/layout_spec.rb
              spec/views/components/banner_component_spec.rb
              spec/views/components/nav_component_spec.rb
          * config/credentials.yml.enc — rotate RAILS_MASTER_KEY for a real project
          * PWA icons and any copied branding

        The repo's default branch must be `main` (verify: git branch --show-current).
      TXT
    end

    private

    def rewrite(path, mapping)
      return :missing unless File.exist?(path)

      content = File.read(path)
      changed = mapping.keys.select { |token| content.include?(token) }
      return [] if changed.empty?

      new_content = mapping.each_with_object(content) { |(old, new), text| text.gsub!(old, new) }
      File.write(path, new_content)
      changed
    end
  end
end
