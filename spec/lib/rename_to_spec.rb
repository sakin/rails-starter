# frozen_string_literal: true

require "rails_helper"
require "tmpdir"

RSpec.describe RenameTo do
  def fixture(files)
    Dir.mktmpdir do |dir|
      paths = files.map do |rel, content|
        path = File.join(dir, rel)
        FileUtils.mkdir_p(File.dirname(path))
        File.write(path, content)
        path
      end
      yield paths
    end
  end

  describe ".names" do
    it "derives slug, module, and display forms from a snake_case name" do
      expect(described_class.names("my_app")).to eq(
        slug: "my_app", module: "MyApp", display: "My App"
      )
    end

    it "normalises dashed and TitleCase input" do
      expect(described_class.names("my-app")).to eq(
        slug: "my_app", module: "MyApp", display: "My App"
      )
      expect(described_class.names("SimpleTaxes")).to eq(
        slug: "simple_taxes", module: "SimpleTaxes", display: "Simple Taxes"
      )
    end
  end

  describe ".apply!" do
    it "rewrites the module, deploy, manifest, and image surfaces" do
      fixture(
        "config/application.rb" => "module RailsStarter\n",
        "config/deploy.yml" => "service: rails_starter\nimage: rails_starter\nvolume rails_starter_storage\n",
        "app/views/pwa/manifest.json.erb" => "{\n  \"name\": \"RailsStarter\",\n  \"description\": \"RailsStarter.\",\n}\n",
        "Dockerfile" => "# docker build -t rails_starter .\n"
      ) do |paths|
        described_class.apply!(files: paths, app_name: "my_app")

        expect(File.read(paths[0])).to eq("module MyApp\n")
        expect(File.read(paths[1])).to eq(
          "service: my_app\nimage: my_app\nvolume my_app_storage\n"
        )
        expect(File.read(paths[2])).to include('"name": "MyApp"')
        expect(File.read(paths[2])).to include('"description": "MyApp."')
        expect(File.read(paths[3])).to include("-t my_app .")
      end
    end

    it "is idempotent" do
      fixture(
        "Dockerfile" => "# -t rails_starter .\n"
      ) do |paths|
        described_class.apply!(files: paths, app_name: "my_app")
        described_class.apply!(files: paths, app_name: "my_app")
        expect(File.read(paths[0])).to include("-t my_app .")
        expect(File.read(paths[0])).not_to include("rails_starter")
      end
    end

    it "reports missing files without crashing" do
      report = described_class.apply!(
        files: [ "/nonexistent/path/application.rb" ], app_name: "my_app"
      )
      expect(report).to eq([ [ "/nonexistent/path/application.rb", :missing ] ])
    end
  end

  describe ".help" do
    it "documents the manual fallback checklist and the main default branch" do
      expect(described_class.help).to include("Manual fallback checklist")
      expect(described_class.help).to include("config/credentials.yml.enc")
      expect(described_class.help).to include("default branch must be `main`")
    end
  end
end
