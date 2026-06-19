---
title: JWT Authentication Pattern
tags: [auth, jwt, pattern]
spec: superspec/specs/auth-jwt/spec.md
created: 2026-06-19
updated: 2026-06-19
sources: [auth-jwt-initial]
---

# JWT Authentication Pattern

> **Example wiki page** — shows how `/spec:wiki` distills a feature into living docs.

## Summary

Short-lived access tokens (15min) paired with long-lived refresh tokens (7 days). Refresh tokens stored server-side for revocation support.

## Key Decisions

### Access token lifetime: 15 minutes
We chose 15 minutes over 1 hour because it limits exposure if a token leaks. The refresh flow handles seamless re-issue without UX friction.
Trade-off: slightly more refresh calls to the server.

### Refresh tokens are server-side, not stateless
We store refresh tokens in the database (hashed) to enable explicit logout and revocation. Pure stateless refresh would be simpler but makes logout unreliable.
Trade-off: extra DB lookup on refresh, but logout actually works.

### Same error for bad password vs. unknown email
We return identical 401 messages regardless of whether the email exists. Prevents user enumeration attacks.
Trade-off: slightly less helpful error messages for users who mistype their email.

## Patterns

### Token pair issuance
```typescript
// Always issue both tokens together on login
const { accessToken, refreshToken } = await issueTokenPair(userId);
// accessToken: short-lived JWT, refreshToken: opaque stored reference
```

### Refresh rotation (optional)
On each refresh, optionally issue a new refresh token and invalidate the old one. Detects token theft if old token is replayed.

## Gotchas

- Clock skew: if server and client clocks differ by >15min, tokens appear expired immediately. Use `nbf` (not before) claim with a 30s grace window.
- Concurrent refresh: two tabs refreshing simultaneously can race. Use a short DB-level lock or accept that both succeed (idempotent refresh).

## Related

- `src/auth/jwt.ts` — Token generation and verification
- `src/auth/refresh.ts` — Refresh token storage and lookup
- [[auth/session-decisions]] — Full session design rationale
