# 04 — Auth core

**What to build:** people can sign in, sign out, and reset a forgotten password. Sessions are stored server-side (so they can be revoked), and unauthenticated visitors are steered to sign-in. This is the starter's reference implementation of the layered architecture, not a product feature.

**Blocked by:** 01 — Test harness (RSpec + full test stack)

**Status:** ready-for-agent

- [ ] Sign in/out works with database-backed sessions; reset sends and consumes a token.
- [ ] Guests are redirected to sign-in for protected pages; signed-in people are recognized.
- [ ] The flow is expressed as linked model + controller-concern pieces consistent with the architecture, with specs green.
- [ ] The chosen generator was run, then its output carved to fit the layering (no catch-all services entry).
