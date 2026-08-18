# frozen_string_literal: true

require "rails/generators"

# Generators live under `lib/generators`, which the app deliberately excludes
# from autoloading, so load this one explicitly.
require Rails.root.join("lib/generators/view_component/view_component_generator")

RSpec.describe(ViewComponentGenerator, type: :generator) do
  let(:tmpdir) { Dir.mktmpdir }
  after { FileUtils.remove_entry(tmpdir) }

  def generate(name)
    generator = ViewComponentGenerator.new([ name ], behavior: :invoke)
    generator.destination_root = tmpdir
    generator.invoke_all
  end

  def file(relative_path)
    Pathname.new(tmpdir).join(relative_path)
  end

  it "generates a sidecar component with its companion template" do
    generate("PostCard")

    component = file("app/frontend/components/post_card/component.rb")
    template = file("app/frontend/components/post_card/component.html.erb")
    preview = file("app/frontend/components/post_card/preview.rb")
    styles = file("app/frontend/components/post_card/index.css")
    assets = file("app/frontend/components/post_card/index.js")

    expect(component).to be_exist
    expect(template).to be_exist
    expect(preview).to be_exist
    expect(styles).to be_exist
    expect(assets).to be_exist
  end

  it "stamps the component into the sidecar convention" do
    generate("PostCard")

    component = file("app/frontend/components/post_card/component.rb").read
    expect(component).to include("class PostCard::Component < ApplicationViewComponent")
    expect(component).to include("def initialize(title:)")

    preview = file("app/frontend/components/post_card/preview.rb").read
    expect(preview).to include("class PostCard::Preview < ApplicationViewComponentPreview")
    expect(preview).to include("render_component PostCard::Component.new")

    styles = file("app/frontend/components/post_card/index.css").read
    expect(styles).to include(".c-post_card")
  end

  it "scopes nested component names and class tokens correctly" do
    generate("admin/sidebar")

    component = file("app/frontend/components/admin/sidebar/component.rb").read
    expect(component).to include("class Admin::Sidebar::Component < ApplicationViewComponent")

    # The CSS token must match what ApplicationViewComponent#class_for derives at
    # render time: namespaced components use a `--` separator.
    styles = file("app/frontend/components/admin/sidebar/index.css").read
    expect(styles).to include(".c-admin--sidebar-root")
  end
end
