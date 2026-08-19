# frozen_string_literal: true

require "spec_helper"

RSpec.describe "bin/dev + Procfile.dev" do
  def root
    File.expand_path("../..", __dir__)
  end

  def read(rel)
    File.read(File.join(root, rel))
  end

  it "runs the Rails server and the Vite watcher together via Foreman" do
    expect(read("bin/dev")).to include('exec "foreman", "start", "-f", "Procfile.dev"')
  end

  it "declares a web process for the Rails server" do
    expect(read("Procfile.dev")).to match(/^web:\s+bin\/rails server/)
  end

  it "declares a vite process running under the bundle's Bun" do
    expect(read("Procfile.dev")).to match(/^vite:\s+bin\/bun-vite dev/)
  end

  it "keeps a no-manual-JS-runtime setup (Bun shipped in the bundle)" do
    expect(read("config/vite.json")).to include('"viteBinPath": "bin/bun-vite"')
    expect(File).to be_executable(File.join(root, "bin/bun-vite"))
  end
end
