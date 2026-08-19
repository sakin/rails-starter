# frozen_string_literal: true

require "spec_helper"

RSpec.describe "pre-commit style hook" do
  def root
    File.expand_path("../..", __dir__)
  end

  let(:hook_path) { File.join(root, ".githooks", "pre-commit") }

  it "ships a runnable pre-commit hook" do
    expect(File).to exist(hook_path)
    expect(File).to be_executable(hook_path)
  end

  it "lints the staged Ruby files with RuboCop" do
    contents = File.read(hook_path)
    expect(contents).to include("bin/rubocop")
    expect(contents).to include("git diff --cached")
  end

  it "is installed into .git/hooks by bin/setup, idempotently" do
    setup = File.read(File.join(root, "bin/setup"))
    expect(setup).to include('".githooks", "pre-commit"')
    expect(setup).to include('".git", "hooks"')
  end
end
