# frozen_string_literal: true

require "rails/generators"

# Generators live under `lib/generators`, which the app deliberately excludes
# from autoloading, so load this one explicitly.
require Rails.root.join("lib/generators/view_component/view_component_generator")

RSpec.describe(ViewComponentGenerator, type: :generator) do
  let(:tmpdir) { Dir.mktmpdir }
  after { FileUtils.remove_entry(tmpdir) }

  def generate(*args)
    generator = ViewComponentGenerator.new(args, behavior: :invoke)
    generator.destination_root = tmpdir
    generator.invoke_all
  end

  def file(relative_path)
    Pathname.new(tmpdir).join(relative_path)
  end

  it "generates a sidecar component under app/views/components with its companion files" do
    generate("PostCard")

    component = file("app/views/components/post_card/component.rb")
    template = file("app/views/components/post_card/component.html.erb")
    preview = file("app/views/components/post_card/preview.rb")
    styles = file("app/views/components/post_card/styles.css")
    spec = file("spec/views/components/post_card_component_spec.rb")

    expect(component).to be_exist
    expect(template).to be_exist
    expect(preview).to be_exist
    expect(styles).to be_exist
    expect(spec).to be_exist
    # No per-component JS shim: styles are bundled by an entrypoint glob.
    expect(file("app/views/components/post_card/index.js")).not_to be_exist
  end

  it "stamps the component into the sidecar convention" do
    generate("PostCard")

    component = file("app/views/components/post_card/component.rb").read
    expect(component).to include("class PostCard::Component < ApplicationViewComponent")
    expect(component).to include("with_collection_parameter :post_card")

    preview = file("app/views/components/post_card/preview.rb").read
    expect(preview).to include("class PostCard::Preview < ApplicationViewComponentPreview")
    expect(preview).to include("render_component PostCard::Component.new")

    styles = file("app/views/components/post_card/styles.css").read
    expect(styles).to include(".c-post_card-root")
  end

  it "turns argument attributes into Dry::Initializer options" do
    generate("PostCard", "title", "age")

    component = file("app/views/components/post_card/component.rb").read
    expect(component).to include("option :title")
    expect(component).to include("option :age")
  end

  it "scopes nested component names and class tokens correctly" do
    generate("admin/sidebar")

    component = file("app/views/components/admin/sidebar/component.rb").read
    expect(component).to include("class Admin::Sidebar::Component < ApplicationViewComponent")

    # The CSS token must match what ApplicationViewComponent#class_for derives at
    # render time: namespaced components use a `--` separator.
    styles = file("app/views/components/admin/sidebar/styles.css").read
    expect(styles).to include(".c-admin--sidebar-root")
  end
end
