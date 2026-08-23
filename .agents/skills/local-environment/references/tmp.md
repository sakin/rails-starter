# The tmp/ tree

Transient, regenerable files this app writes while running. Cleared safely at
any time; the directory is git-ignored apart from a `.keep` in each kept
subfolder (`.gitignore` keeps `/tmp/*`, `/tmp/pids/*`, and `/tmp/storage/*`,
each with a `.keep` exception).

Clear the whole tree when you suspect stale artifacts:

```
bin/rails tmp:clear
```

(`bin/setup` already runs `bin/rails log:clear tmp:clear` as part of setup.)

## Map

| Entry | Role | Where it's wired |
|-------|------|------------------|
| `tmp/storage` | Active Storage blob/preview files in development (SQLite `storage:` root) | `config/storage.yml` |
| `tmp/caching-dev.txt` | Dev caching toggle: its *presence* turns development caching on | `config/environments/development.rb` |
| `tmp/pids/server.pid` | Puma PID file; the `:tmp_restart` plugin watches the tmp tree to hot-restart on boot-file changes | `config/puma.rb` |
| `tmp/profile_<label>.dump` | `stackprof` CPU profile dumps from the suite | `spec/support/profiler.rb` |
| `tmp/rubocop` | RuboCop cache root | CI (`RUBOCOP_CACHE_ROOT`) |
| `tmp/screenshots` | System-test screenshot artifacts | CI job |

## Reading a profile dump

A `stackprof` dump written to `tmp/profile_<label>.dump` is read back with:

```
stackprof tmp/profile_<label>.dump
```
