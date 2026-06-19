# Discussion: User Authentication (JWT)

> **Example** — shows the DISCUSS.md format after a /discuss session.

Date: 2026-06-19

## What We're Building

JWT-based authentication: users log in with email + password, receive a short-lived access token and a long-lived refresh token. The access token authorizes API calls. The refresh token issues new access tokens without re-login.

## Goals

- Users can log in and receive API tokens
- Access tokens expire quickly (minimize exposure on leak)
- Users can stay logged in across sessions via refresh
- Logout actually works (invalidates tokens server-side)

## Non-Goals

- OAuth / social login (separate spec)
- Password reset flow (separate spec)
- MFA (future)
- Admin impersonation (future)

## Constraints

- **Technical:** Existing Express + PostgreSQL stack
- **Scope:** Login, refresh, logout only
- **Security:** Must prevent user enumeration via error messages

## Key Decisions Made

### Decision: Refresh token storage
**We will:** Store refresh tokens server-side (hashed in DB)
**Because:** Enables real logout/revocation
**We won't:** Use stateless refresh JWTs (logout wouldn't work)

### Decision: Access token lifetime
**We will:** 15-minute access tokens
**Because:** Short window limits damage if leaked
**We won't:** 1-hour tokens (too long for security) or 5-minute (too much friction)

### Decision: Error messages
**We will:** Return identical 401 for wrong password and unknown email
**Because:** Prevents user enumeration
**We won't:** Say "email not found" vs "wrong password"

## Open Questions

- [ ] Should refresh tokens rotate on each use?
- [ ] Max concurrent sessions per user?

## Success Criteria

- [ ] User can log in and receive tokens
- [ ] Access token expires after 15 minutes
- [ ] Refresh issues new access token
- [ ] Logout invalidates refresh token
- [ ] All scenarios from spec have passing tests

## Risks

- **Clock skew:** Client and server clocks differ → token appears expired. Mitigation: 30s grace window in JWT verification.
