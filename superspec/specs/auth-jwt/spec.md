# User Authentication (JWT) — Specification

> **Example spec** — shows SuperSpecs format in practice.

## Purpose

Allow users to authenticate with email and password. Issue JWT tokens for API access. Support session expiration and refresh.

## Requirements

### Requirement: Login

The system SHALL authenticate users with valid email and password credentials.

#### Scenario: Successful login
- GIVEN a registered user with email `user@example.com` and password `correct123`
- WHEN they POST to `/api/auth/login` with those credentials
- THEN return a 200 response with an access token and refresh token
- AND the access token SHALL expire after 15 minutes
- AND the refresh token SHALL expire after 7 days

#### Scenario: Invalid credentials
- GIVEN a registered user
- WHEN they POST to `/api/auth/login` with an incorrect password
- THEN return a 401 response
- AND do NOT reveal whether the email exists

#### Scenario: Non-existent user
- GIVEN an email that is not registered
- WHEN they POST to `/api/auth/login`
- THEN return a 401 response with the same error as invalid credentials

### Requirement: Token Refresh

The system SHALL issue a new access token when a valid refresh token is provided.

#### Scenario: Valid refresh
- GIVEN a user with a non-expired refresh token
- WHEN they POST to `/api/auth/refresh` with the token
- THEN return a new access token

#### Scenario: Expired refresh token
- GIVEN a user with an expired refresh token
- WHEN they POST to `/api/auth/refresh`
- THEN return a 401 response
- AND the user must log in again

### Requirement: Logout

The system SHALL invalidate a user's refresh token on logout.

#### Scenario: Successful logout
- GIVEN an authenticated user
- WHEN they POST to `/api/auth/logout`
- THEN the refresh token SHALL be invalidated
- AND subsequent refresh requests with that token SHALL return 401

## Out of Scope

- OAuth / social login (separate spec)
- Password reset flow (separate spec)
- Multi-factor authentication (future)
- Admin impersonation (future)

## Dependencies

- User accounts must exist (see `user-registration` spec)
- JWT secret managed via environment variable `JWT_SECRET`

## Open Questions

- [ ] Should we support multiple active sessions per user?
- [ ] Refresh token rotation: issue new refresh on each use?
