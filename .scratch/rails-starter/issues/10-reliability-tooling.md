# 10 — Reliability & style tooling

**What to build:** guardrail and style tooling is wired so the repo stays clean automatically — catching N+1s, non-atomic transaction side-effects, and thread-safety issues in the suite, plus linting/formatting and git hooks on commit.

**Blocked by:** 01 — Test harness (RSpec + full test stack), 03 — ViewComponent foundation + contrib + Lookbook

**Status:** ready-for-agent

- [ ] The non-atomic-IO guard, transactional side-effect handling, and the N+1 guard are invoked by the test run and trip on violations.
- [ ] The style/formatting tooling is runnable from a commit hook.
- [ ] Frozen-string behavior and typed-config formwork are in place; hooks are installed/installable.
- [ ] (Stretch) a mailer preview is surfaced in Lookbook.
