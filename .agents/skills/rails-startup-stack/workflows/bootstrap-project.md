# Bootstrap-project workflow

The executable form of the README's "Template-use checklist" (and PRD §8).
Run this when a clone of this starter is turned into a real project. It is an
ordered sequence of steps, each with a **Done when** check so you know the step
is genuinely complete before moving on.

Assumes you're inside the freshly-cloned (or just-created-from-template) repo.
Some steps a human must perform (creating the GitHub repo, editing
credentials/secrets) — for those, either hand the human the exact command or
drive them through it with a `wizard`; don't silently skip them.

## 0. Preconditions

- The clone is a clean copy of the starter (checked out from the template, no
  upstream tie).
- `git remote -v` points at the new project's repo, not the starter's.
- Ruby is available (`.ruby-version`).

**Done when** the working tree is clean and the remote is the new project.

## 1. Rename the app

```sh
bin/rename_to <app-name>          # or: bin/rails rename_to[<app-name>]
```

Renames the application module, Kamal deploy service/image/volume, PWA
manifest, and Docker image references. Re-runs are safe (idempotent).

Display strings and specs intentionally keep "Rails Starter" so a renamed app
still boots and passes the suite. For a **full** app-wide rename, `bin/rename_to
--help` prints the manual fallback checklist (layout views, components, nav,
locale eyebrow).

**Done when** `bin/rename_to --help` shows your app name in the baked-in
surfaces, or you've deliberately chosen to keep the display name.

## 2. Set your own credentials

```sh
bin/rails credentials:edit
```

The template's `config/master.key` is for development only — never commit it.
Replace the secrets with the new project's. Confirm no real key is committed:

```sh
git check-ignore config/master.key    # should print the file if ignored
```

**Done when** credentials are yours and the dev key is ignored, not committed.

## 3. Configure deploy and CI

- `config/deploy.yml` — service/image/volume already renamed; update the server
  hosts (`servers.web`) and the registry if deploying.
- `.github` CI — update if you deploy (secrets: `RAILS_MASTER_KEY`,
  `KAMAL_REGISTRY_PASSWORD`, etc.).
- **Kamal is optional** — its presence or absence never breaks the Docker
  build. Litestream is optional and off by default (supply `LITESTREAM_*` env
  vars to enable).

**Done when** a deploy config either matches your infra or you've consciously
skipped it.

## 4. Set up and verify green

```sh
bin/setup      # bundle install, db:prepare, install pre-commit hook (starts bin/dev unless --skip-server)
bin/rspec      # the suite
bin/rubocop    # lint
bin/ci         # CI job alias
```

`bin/setup` is idempotent. The pre-commit hook (`.githooks/pre-commit`) installs
automatically when a `.git` dir is present.

**Done when** `bin/rspec` is green and `bin/rubocop` is clean.

## 5. Run integration check (optional but recommended)

```sh
bin/dev        # Rails server + Vite watcher together (Foreman), hot-reloading
```

Load the home page and confirm the shared `Layout::Component` renders with the
Vite bundle (`vite_client_tag`/`vite_stylesheet_tag`). The frontend runs on Bun
via `bundlebun` — no Node needed.

**Done when** the app boots and the page serves styled and scripted.

## 6. First commit

```sh
git add -A
git commit -m "Initial commit from rails-startup-stack"
```

A single clean initial commit makes it easy to `git log`/diff back over time and
see exactly what has diverged from the template.

**Done when** there's one clean initial commit on `main`.

## Completion

All of the following are true:

- App renamed via `bin/rename_to` (or a deliberate choice to keep the name).
- Credentials are the project's own; dev key not committed.
- Deploy/CI configured or consciously skipped.
- `bin/rspec` green, `bin/rubocop` clean.
- One clean initial commit on `main`.
