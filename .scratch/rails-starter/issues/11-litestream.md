# 11 — Litestream (optional, default-off)

**What to build:** in production the primary SQLite database can continuously replicate to an S3-compatible bucket only when a replica is configured; local development never attempts replication and never fails without it. Only the primary app database is backed up, not the transient Solid databases.

**Blocked by:** 09 — Docker build + optional Kamal config

**Status:** resolved

- [x] Replication activates only when the replica env vars are present; absent, the app runs fine and nothing replicates.
- [x] Development never runs replication.
- [x] The configuration targets only the primary app database.

## Comments

Implemented optional, default-off continuous replication of the primary SQLite
DB to S3 via Litestream v0.5.16 (globally-pinned).

- `lib/litestream.rb` — pure, testable module: `Litestream.enabled?` gates on the
  replica env vars (must all be present + non-blank) AND `RAILS_ENV=production`;
  `Litestream.yaml` renders a config targeting only `storage/production.sqlite3`
  (the Solid cache/queue/cable DBs are never replicated); a single
  `ENV_TO_OPTION` mapping + `options_from_env` keep drivers in sync with the env
  var list. Specs: `spec/lib/litestream_spec.rb` (11 examples).
- `bin/litestream_config` — driver that writes the config when enabled (to a
  container-local tmp path by default, so the S3 secret is never persisted to the
  mounted /rails/storage volume) and exits non-zero when off, so the entrypoint
  can gate on it.
- `bin/docker-entrypoint` — after `db:prepare`, wraps the server command with
  `litestream replicate -config ... -exec ...` only when the config renders;
  otherwise runs the app exactly as before (development never replicates).
- `Dockerfile` — adds a `litestream/litestream:$LITESTREAM_VERSION` build stage
  declared FIRST (so the final, default-target stage stays the app's base stage)
  and copies `/usr/local/bin/litestream` into the image. Binary stays inert
  unless the env vars are set at run time.
- Docs: notes in `config/deploy.yml` and `README.md` pointing at
  `bin/litestream_config` / `lib/litestream.rb`. (An initial
  `config/litestream.yml.erb` example was dropped after review: it was dead code
  not consumed by the renderer, and its YAML shape had drifted.)

Verified: unit specs green, full suite (123 examples) green, `docker build` +
the entrypoint gate exercised in the built image (default-off passes through
plainly; enabled writes to a transient path).

Post-review notes: automatic restore-from-replica on cold start (Litestream's
`restore` behaviour) is out of scope for this ticket, which covers continuous
*replication* only; a manual `litestream restore -config ...` remains the way to
recover a fresh container from S3.
