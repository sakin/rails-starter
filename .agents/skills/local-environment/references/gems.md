# Working with gems

How gems are added and located in this repo. Gems come from the Gemfile and are
resolved by Bundler; there is no separate version-management layer between the
shell and Bundler (Ruby is pinned by `.ruby-version`).

Companion to `rails-startup-stack/references/gems.md`, which is the *role* table
(what each installed gem is *for*). This file is the *procedure* (how to add one,
how to find one on disk).

## Locate an installed gem

Resolve the path through Bundler rather than guessing a directory:

```
bundle show <gem>      # absolute path to the installed gem
bundle info <gem>      # path plus metadata (homepage, version, description)
gem which <gem>        # load path Bundler puts on the $LOAD_PATH
```

To read a gem's source, follow `bundle show`'s path; don't blind-scan
`vendor/` or the gem tree to reverse-engineer where Bundler put it.

## Add a gem

1. Add the gem to the `Gemfile` (correct group: default, `group :development`,
   `group :test`, etc.).
2. Resolve and install with the repo's normal flow:

   ```
   bundle install
   ```

   A full environment setup that also installs gems (and preps the DB) is
   `bin/setup`.

## Notes

- Bundler's own config lives in `.bundle/config`, which is git-ignored; it is
  local-only and should not be committed.
- To read the resolved dependency set as a whole, the lockfile (`Gemfile.lock`)
  is the single source of truth for what's actually installed and at which
  version.
