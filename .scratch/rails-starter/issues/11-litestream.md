# 11 — Litestream (optional, default-off)

**What to build:** in production the primary SQLite database can continuously replicate to an S3-compatible bucket only when a replica is configured; local development never attempts replication and never fails without it. Only the primary app database is backed up, not the transient Solid databases.

**Blocked by:** 09 — Docker build + optional Kamal config

**Status:** ready-for-agent

- [ ] Replication activates only when the replica env vars are present; absent, the app runs fine and nothing replicates.
- [ ] Development never runs replication.
- [ ] The configuration targets only the primary app database.
