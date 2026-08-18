# 01 — Test harness (RSpec + full test stack)

**What to build:** the project's test suite runs on RSpec instead of the stock harness, with headless browser system tests and tooling to keep specs fast and safe. From a fresh checkout, running the test command installs its needs from the bundle and goes green.

**Blocked by:** None — can start immediately.

**Status:** resolved

- [x] Running the test command from a fresh checkout goes green with no system Node required.
- [x] The previous harness is gone; specs and factories live under the new convention.
- [x] A system test drives a real page through a headless browser and passes.
- [x] HTTP is stub-friendly, an N+1 guard is wired, and the profiler is in place and usable.
- [x] The full test stack (browser driver swap, HTTP stub, N+1 guard, profiler, factories) is added and initialized.

## Comments

Implemented as initial commit `b58230e`. RSpec replaces Minitest (`test/` removed), with `bin/rspec` and the default rake task both green (8 specs). Stack: FactoryBot + Faker, WebMock (stub-friendly HTTP), n_plus_one_control (N+1 guard), stackprof profiler helper, and Cuprite-driven headless Chromium system tests (no Node, no driver binary).
