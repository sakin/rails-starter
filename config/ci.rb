# Run using bin/ci
#
# Local runs use the full suite. On CI the browser (RSpec system) specs are split
# into their own job because the GitHub-hosted runner gets resource-constrained
# running them alongside the app-heavy generator specs; select with CI_SUITE:
#   CI_SUITE=fast   bin/ci   # everything except system specs
#   CI_SUITE=system bin/ci   # system specs only
# See .github/workflows/ci.yml (test / system-test jobs).

suite = ENV.fetch("CI_SUITE", "all")

CI.run do
  step "Setup", "bin/setup --skip-server"

  step "Style: Ruby", "bin/rubocop"

  step "Security: Gem audit", "bin/bundler-audit"
  step "Security: JavaScript vulnerability audit", "bin/bun audit"
  step "Security: Brakeman code analysis", "bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error"

  case suite
  when "fast"
    step "Tests: Rails", "bin/rspec", "--tag", "~type:system"
  when "system"
    step "Tests: System", "bin/rspec", "spec/system"
  else
    step "Tests: Rails", "bin/rspec"
  end

  step "Tests: Seeds", "env RAILS_ENV=test bin/rails db:seed:replant" unless suite == "system"

  # Optional: set a green GitHub commit status to unblock PR merge.
  # Requires the `gh` CLI and `gh extension install basecamp/gh-signoff`.
  # if success?
  #   step "Signoff: All systems go. Ready for merge and deploy.", "gh signoff"
  # else
  #   failure "Signoff: CI failed. Do not merge or deploy.", "Fix the issues and try again."
  # end
end
