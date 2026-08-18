# 07 — Authorize & notify on auth

**What to build:** the auth reference extends through two more architecture layers: an example policy gates a protected action, and signing up triggers a welcome notification sent through the app's unified notification layer.

**Blocked by:** 05 — Registration via the forms layer

**Status:** ready-for-agent

- [ ] A protected action is authorized by an example policy (allowed/denied visibly branch).
- [ ] Sign-up triggers a welcome notification through the unified delivery layer (email by default).
- [ ] Both behaviors have specs; the policy and notification pieces are wired as their own layers, not a services catch-all.
