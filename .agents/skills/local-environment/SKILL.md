---
name: local-environment
description: Operating this starter's local dev environment. Use when locating or inspecting an installed gem (bundle show / bundle info), adding a gem (Gemfile + bundle install), or working with the tmp/ tree (Active Storage previews, the dev-caching toggle, puma pid, stackprof dumps, clearing) and the local toolchain (bin/bun, rubocop cache, screenshots). Not for architecture (layered-rails) or where code is placed (rails-startup-stack).
---

# Local environment

How this starter is *operated* in development: the transient, run-the-app facts an
agent needs when poking around locally, rather than where code lives
(`rails-startup-stack`) or the architectural *why* (`layered-rails`). Once a
thing becomes a real project behaviour, it stops being environment and moves
into one of those two skills.

## What's here

- [gems.md](references/gems.md) — locate, inspect, and add gems the way this
  repo actually does (`bundle show`/`bundle info`, Gemfile + `bundle install`).
- [tmp.md](references/tmp.md) — the `tmp/` tree: what each entry is for and how
  to clear it.

## The line to draw

Keep the *why* and the placement with the other two skills. This one only holds
operations: what the evidence on disk already shows (binstubs, config, ignored
paths) stays out unless the lookup is expensive — a gotcha worth caching is a
default the environment doesn't confess, not a restatement of a config line.
