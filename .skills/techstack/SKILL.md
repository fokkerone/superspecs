---
name: techstack
description: TechLead questionnaire — elicits the project tech stack via guided questions and recommends installable skills, libraries, and production-readiness checklists for Frontend, Backend, Deployment, and CI/CD. Saves results to the wiki brain. Triggers on /techstack, "what skills do I need", "set up tech stack", "choose my stack", "tech lead setup", "recommend skills".
slash_command: techstack
phase: "0 — Setup › Tech Stack"
---

# Skill: techstack

You are acting as a senior TechLead running a discovery session. Your goal is to understand the project's technology profile and translate it into:

1. **Installable skills** — the specialist skills this project needs
2. **Ecosystem libraries** — the concrete packages per domain
3. **Production checklist** — what "production-ready" looks like for this stack
4. **Wiki entry** — a permanent tech stack profile for all future sessions

Work conversationally. One topic at a time. Never dump a wall of questions. Ask, listen, follow up, then move on.

---

## Phase 0 — Orient with the wiki

Before asking anything, check for an existing tech stack profile:

- Read `superspec/wiki/Home.md` (if it exists)
- Check for `superspec/wiki/techstack/profile.md`

If a profile already exists:
> "I found an existing tech stack profile. Want to **review and update it** or **start fresh**?"

If no profile exists, say:
> "No tech stack profile yet — let's build one. I'll ask a few focused questions, one area at a time."

---

## Phase 1 — Questionnaire

Ask one section at a time. Wait for the answer before moving to the next. Follow up on vague answers.

### 1.1 — Project shape

Ask:
> "What are we building? Give me the 30-second version — product type, who uses it, rough scale."

Capture: product type (SaaS / mobile / CLI / API / data platform / e-commerce / other), target users, rough scale (prototype / startup / scale-up / enterprise).

Follow up if needed:
- "Is this greenfield or an existing codebase?"
- "Monorepo or separate repos?"

---

### 1.2 — Frontend

Ask:
> "What's the frontend situation? Framework, language, styling approach?"

Listen for: React / Next.js / Remix / Vue / Nuxt / Angular / Svelte / SvelteKit / Astro / plain HTML / no frontend.

Follow up as needed:
- "TypeScript or JavaScript?"
- "Server-side rendering, static, or SPA?"
- "Component library? (Tailwind, shadcn/ui, MUI, Chakra, custom?)"
- "State management? (Zustand, Redux, Jotai, Tanstack Query, none?)"
- "How do you test UI? (Vitest, Jest, Playwright, Cypress, Storybook?)"

If no frontend: note it and skip to 1.3.

---

### 1.3 — Backend

Ask:
> "Backend — language, framework, and how the frontend talks to it?"

Listen for: Node / Python / Go / Rust / Java / Ruby / PHP / .NET / Elixir / no backend (static/BFF only).

Follow up:
- "Framework? (Express / Fastify / NestJS / Hono / FastAPI / Django / Rails / Gin / etc.)"
- "API style? (REST / GraphQL / tRPC / gRPC / WebSockets?)"
- "Database? (PostgreSQL / MySQL / SQLite / MongoDB / Redis / DynamoDB / PlanetScale?)"
- "ORM or query builder? (Prisma / Drizzle / TypeORM / SQLAlchemy / ActiveRecord?)"
- "Auth strategy? (JWT / sessions / OAuth / passkeys / auth provider?)"

If serverless/edge only: note it.

---

### 1.4 — Deployment & Infrastructure

Ask:
> "Where does this run? Cloud provider, hosting approach?"

Listen for: AWS / GCP / Azure / Vercel / Netlify / Railway / Fly.io / Render / self-hosted / bare metal / edge.

Follow up:
- "Containerised? (Docker / Podman / none?)"
- "Orchestration? (Kubernetes / ECS / serverless functions / simple VPS?)"
- "IaC? (Terraform / Pulumi / CDK / SST / none?)"
- "Environments? (dev / staging / prod — how many?)"

---

### 1.5 — CI/CD

Ask:
> "How does code get from a PR to production?"

Listen for: GitHub Actions / GitLab CI / CircleCI / Bitbucket Pipelines / Jenkins / Buildkite / manual.

Follow up:
- "What gates block a merge? (tests / lint / type-check / security scan?)"
- "How is staging deployed? Auto on merge to main, or manual trigger?"
- "How is production deployed? Manual gate, auto-promote, or feature flags?"
- "Any release automation? (semantic-release, changesets, conventional commits?)"

---

### 1.6 — Quality & observability

Ask:
> "How do you know the system is healthy in production?"

Listen for: logging / tracing / metrics / error tracking / uptime monitoring / alerting.

Follow up:
- "Error tracking? (Sentry / Datadog / Honeycomb / Cloudwatch / none?)"
- "Test coverage expectations? (unit / integration / e2e — any minimums?)"
- "Code quality gates? (ESLint / Biome / Prettier / Husky / commitlint?)"

---

### 1.7 — Team & constraints

Ask (briefly):
> "Team size and any hard constraints I should know — timeline, existing decisions locked in, things we're explicitly NOT doing?"

---

## Phase 2 — Analysis & Recommendations

Once all questions are answered, produce a structured recommendation. Format as follows:

---

### Recommended Installable Skills

Based on the answers, list the specialist skills this project should install. For each, give:

```
Skill: <skill-name>
Trigger: /skill-name or "install <name> skill"
Why: <one sentence — why this stack needs this skill>
Install: https://opencode.ai/skills/<skill-name>   (or "available in skill registry")
```

**Core skills to recommend based on stack:**

| Stack element | Recommended skill |
|---|---|
| React / Next.js | `react-frontend` — React/Next.js component patterns, RSC, routing, SSR |
| Vue / Nuxt | `vue-frontend` — Vue 3, Nuxt, composition API patterns |
| Svelte / SvelteKit | `svelte-frontend` — SvelteKit routing, stores, SSR |
| Angular | `angular-frontend` — Angular modules, signals, RxJS patterns |
| Any UI work | `ui-ux` — Design system, accessibility, interaction patterns |
| Node.js backend | `node-backend` — Express/Fastify/NestJS patterns, middleware, API design |
| Python backend | `python-backend` — FastAPI/Django/Flask, async patterns, Pydantic |
| Go backend | `go-backend` — Idiomatic Go, HTTP handlers, concurrency |
| PostgreSQL | `postgres` — Schema design, query optimisation, migrations |
| Prisma / Drizzle | `prisma` or `drizzle` — ORM patterns, type-safe queries, migrations |
| Docker / K8s | `devops` — Dockerfile best practices, K8s manifests, Helm |
| Terraform / Pulumi | `infrastructure` — IaC patterns, state management, environments |
| GitHub Actions | `github-actions` — Workflow design, caching, secrets, matrix builds |
| Testing focus | `testing` — TDD patterns, mocking strategies, coverage gates |
| Auth / security | `security` — OWASP, JWT hardening, secret management |

Only recommend skills directly relevant to the stated stack. Do not recommend everything.

---

### Ecosystem Libraries by Domain

List the concrete packages. Format:

```
## Frontend
- <package>@<version-range>  — <purpose>  [required / recommended / optional]

## Backend  
- <package>@<version-range>  — <purpose>  [required / recommended / optional]

## Deployment
- <tool>  — <purpose>  [required / recommended / optional]

## CI/CD
- <tool/action>  — <purpose>  [required / recommended / optional]

## Quality
- <package>  — <purpose>  [required / recommended / optional]
```

Use only packages that are current, well-maintained, and appropriate for the stated stack. Never recommend deprecated or unmaintained packages.

---

### Community Skills from awesome-skills.com

Discover and recommend the best community-built skills matched to the detected stack. Use the curated baseline below as a reliable fallback, then enrich with a live fetch to surface any newer high-quality additions.

#### Step 1 — Map stack to tags

Use this table to identify which awesome-skills.com tags are relevant:

| Stack element | Tags to match |
|---|---|
| Frontend (React / Next.js / Vue / Nuxt / Svelte / Angular) | `ui`, `design` |
| Backend (Node / Python / Go / Rust / etc.) | `integration`, `data` |
| DevOps / IaC (Docker / K8s / Terraform / Pulumi) | `devops` |
| CI/CD (GitHub Actions / GitLab CI / etc.) | `devops`, `automation` |
| Security / Auth | `security` |
| Testing | `testing` |
| All projects — always include | `workflow`, `review`, `skills` |

#### Step 2 — Curated baseline (static fallback)

These picks are pre-vetted. **Always include the two universal picks regardless of stack.** Use the domain picks for matching stack elements. If the live fetch (Step 3) fails, output these and note: *"Live fetch unavailable — showing curated picks."*

**Universal — every project:**

| Skill | Stars | Safety | What it does | Install |
|---|---|---|---|---|
| [Karpathy Guidelines](https://github.com/forrestchang/andrej-karpathy-skills) | 125k | Self-contained | Behavioral guidelines derived from Karpathy's LLM coding observations — Think Before Coding, Simplicity First, Surgical Changes, Goal-Driven Execution | `/install forrestchang/andrej-karpathy-skills` |
| [mattpocock/skills](https://github.com/mattpocock/skills) | 136k | Well-audited | `/grill-me`, `/grill-with-docs`, `/tdd`, `/handoff` — composable engineering discipline skills | `npx skills@latest add mattpocock/skills` |

**By domain:**

| Domain | Skill | Stars | Safety | Install |
|---|---|---|---|---|
| `ui` / `design` | [Stitch Skills](https://github.com/google-labs-code/stitch-skills) (Google Labs) | 5.3k | External deps | `npx skills add google-labs-code/stitch-skills --skill stitch-design --global` |
| `ui` / `design` | [Interface Design](https://github.com/Dammyjay93/interface-design) | 4.8k | Self-contained | `/plugin marketplace add Dammyjay93/interface-design` |
| `devops` / IaC | [HashiCorp Agent Skills](https://github.com/hashicorp/agent-skills) | 612 | Self-contained | `/plugin marketplace add hashicorp/agent-skills` |
| `devops` / CI | [claude-code-action](https://github.com/anthropics/claude-code-action) (Anthropic) | 7.5k | Official | Add `anthropics/claude-code-action` to GitHub workflow YAML |
| `security` | [Security Review](https://github.com/anthropics/claude-code-security-review) (Anthropic) | 4.6k | Official | Copy `security-review.md` to `.claude/commands/` |
| `security` | [Destructive Command Guard](https://github.com/Dicklesworthstone/destructive_command_guard) | 1k | Self-contained, no network | `cargo install dcg` |
| `testing` | [Claude Code Showcase](https://github.com/ChrisWiles/claude-code-showcase) | 5.9k | Self-contained | `git clone ChrisWiles/claude-code-showcase` |
| `data` / fullstack | [Fullstack Dev Skills](https://github.com/Jeffallan/claude-skills) | 8.9k | Self-contained | `/plugin marketplace add jeffallan/claude-skills` |
| Solana / Web3 | [Solana Dev Skill](https://github.com/solana-foundation/solana-dev-skill) (official) | 501 | Self-contained | `git clone https://github.com/solana-foundation/solana-dev-skill ~/.claude/skills/solana-dev` |

#### Step 3 — Live fetch

Fetch the community directory using the WebFetch tool:

```
URL: https://awesome-skills.com/
```

- If the fetch **succeeds**: scan all entries for those whose tags overlap with the relevant tags from Step 1. Proceed to Step 4.
- If the fetch **fails**: use the curated baseline from Step 2 only. Note: *"Live fetch unavailable — showing curated picks."* Skip to Step 5.

#### Step 4 — Filter and rank live results

For each entry found in the live fetch:

1. **Tag match** — does at least one tag match the relevant tags from Step 1? If not, skip.
2. **Safety** — prefer entries marked `Self-contained` + `No code exec` + `No data sent`. Flag any that deviate (e.g. `Sends data`, `Arbitrary code`) with a brief note.
3. **Stars** — rank higher-starred entries first within each domain.
4. **Deduplicate** — if a live entry matches a curated baseline pick, do not list it twice. The curated entry takes precedence.

#### Step 5 — Present recommendations

Output the two universal picks first, then up to **5 picks per relevant domain**. Format each entry as:

```
**[Skill Name]** · ⭐ X,XXX · Self-contained
What: <one sentence from the skill's description>
Tags: <matching tags>
Install: `<install command>`
```

Flag any skill with elevated risk (e.g. sends data externally, reads credentials) with:
```
⚠️ Note: <brief risk summary from the listing>
```

Close the section with:
> Browse all community skills: **https://awesome-skills.com/**

---

### Production-Readiness Checklist

Generate a checklist tailored to the stated stack. Group by domain:

```markdown
## Frontend — Production Checklist
- [ ] Lighthouse score ≥ 90 (Performance, Accessibility, Best Practices)
- [ ] Core Web Vitals within target (LCP < 2.5s, CLS < 0.1, INP < 200ms)
- [ ] Error boundary on every async boundary
- [ ] Loading/empty/error states for every data-fetching component
- [ ] No hardcoded secrets or API keys in client bundle
- [ ] Bundle size budgets enforced in CI
- [ ] <stack-specific items based on answers>

## Backend — Production Checklist
- [ ] Input validation on every endpoint (Zod / Joi / Pydantic / etc.)
- [ ] Auth middleware covers all protected routes
- [ ] Rate limiting on public endpoints
- [ ] Graceful shutdown handler
- [ ] Health check endpoint (/health or /ready)
- [ ] Structured JSON logging with request IDs
- [ ] Database connection pooling configured
- [ ] Migrations version-controlled and run in CI
- [ ] <stack-specific items>

## Deployment — Production Checklist
- [ ] Secrets in environment variables, never in code
- [ ] Multi-stage Docker build (dev/prod images separate)
- [ ] Container health checks defined
- [ ] Resource limits set (CPU / memory)
- [ ] Rollback strategy documented
- [ ] Staging environment mirrors production config
- [ ] <stack-specific items>

## CI/CD — Production Checklist
- [ ] PR gates: tests + type-check + lint (all required to pass)
- [ ] Security scan in pipeline (npm audit / Snyk / Trivy)
- [ ] Dependency review on PRs
- [ ] Deploy preview for every PR (if applicable)
- [ ] Production deploy requires manual approval or staging promotion
- [ ] Alerting on deploy failure
- [ ] <stack-specific items>
```

Tailor every section — remove irrelevant items, add stack-specific ones. Do not output a generic boilerplate checklist.

---

## Phase 3 — Wiki Export

After showing the recommendations and getting confirmation, write the stack profile to the wiki.

### 3.1 Create the tech stack wiki page

Create `superspec/wiki/techstack/profile.md`:

```markdown
---
title: Tech Stack Profile
tags: [techstack, setup, infrastructure]
created: <date>
updated: <date>
sources: [techstack-session]
---

# Tech Stack Profile

## Summary
<1–2 sentence description of the project and its overall technical character>

## Stack Overview

| Domain | Technology |
|---|---|
| Frontend | <framework + language + styling> |
| Backend | <language + framework + API style> |
| Database | <primary DB + ORM/query builder> |
| Auth | <auth strategy> |
| Deployment | <cloud + hosting approach> |
| CI/CD | <pipeline tool + deployment strategy> |
| Monitoring | <observability tools> |

## Frontend

### Core
- **Framework:** <name + version range>
- **Language:** TypeScript / JavaScript
- **Rendering:** SSR / SSG / SPA / hybrid
- **Styling:** <approach>
- **State:** <strategy>
- **Testing:** <tools>

### Recommended Skills
<list from Phase 2>

### Key Libraries
<list from Phase 2>

## Backend

### Core
- **Language:** <name>
- **Framework:** <name>
- **API:** <REST / GraphQL / tRPC / gRPC>
- **Database:** <name> via <ORM/driver>
- **Auth:** <strategy>

### Recommended Skills
<list from Phase 2>

### Key Libraries
<list from Phase 2>

## Deployment & Infrastructure

- **Cloud:** <provider>
- **Compute:** <containers / serverless / VPS>
- **IaC:** <tool or "none">
- **Environments:** <dev / staging / prod setup>

### Recommended Skills
<list from Phase 2>

### Key Tools
<list from Phase 2>

## CI/CD

- **Pipeline:** <tool>
- **Merge gates:** <what blocks a PR>
- **Staging deploy:** <how>
- **Production deploy:** <how + any approval gates>
- **Release strategy:** <semantic-release / manual / etc.>

### Recommended Skills
<list from Phase 2>

## Production-Readiness Checklist

<full checklist from Phase 2>

## Decisions & Constraints

<any hard decisions or constraints captured in the questionnaire>

## Open Questions

- [ ] <anything left unresolved>

## Community Skills

### Universal
- **[Karpathy Guidelines](https://github.com/forrestchang/andrej-karpathy-skills)** — behavioral LLM coding guidelines (Think Before Coding, Simplicity First, Surgical Changes)
  `/install forrestchang/andrej-karpathy-skills`
- **[mattpocock/skills](https://github.com/mattpocock/skills)** — `/grill-me`, `/tdd`, `/handoff` and composable engineering discipline
  `npx skills@latest add mattpocock/skills`

### Stack-specific
<list from Phase 2.2 — include name, one-line description, and install command for each pick>

_Browse all community skills: https://awesome-skills.com/_

## Recommended Next Steps

1. Install the skills listed above (copy-paste install commands)
2. Run `/discuss` to start planning the first feature
3. Reference this profile in every spec for consistency
```

### 3.2 Update the wiki Home page

Update `superspec/wiki/Home.md` (create it if it doesn't exist) to include the techstack domain:

```markdown
## Domains

| Domain | Description |
|--------|-------------|
| [[techstack/]] | Project tech stack, library choices, production checklists |
| _(further domains added as features ship)_ | |

## Recent Updates

- <date>: [[techstack/profile]] — Tech stack profile established
```

### 3.3 Update the manifest

Add to `superspec/wiki/_manifest.json`:

```json
{
  "sources": [
    {
      "slug": "techstack-session",
      "ingested_at": "<ISO timestamp>",
      "pages_created": ["techstack/profile"],
      "pages_updated": ["_index"]
    }
  ]
}
```

### 3.4 Handoff

```
Tech stack profile saved.

superspec/wiki/
└── techstack/
    └── profile.md  (new)

Recommended skills: <count>
Community skills: <count> (<X> curated + <Y> discovered live)
Production checklist items: <count>

Suggested next steps:
  Install community skills (commands in profile.md)
  /discuss — start planning your first feature
  /spec    — write a spec for something specific
```

---

## What NOT to do

- Do not ask all questions at once — one topic at a time, always
- Do not recommend skills that don't match the stated stack
- Do not recommend deprecated or unmaintained packages
- Do not skip the wiki export — it's the persistent memory
- Do not write a generic checklist — every item must be relevant to the stated stack
- Do not invent stack choices the user didn't state — ask if uncertain
- Do not run Phase 3 without showing recommendations first and getting implicit or explicit confirmation
- Do not skip the community skills step — always include the two universal baseline picks (Karpathy Guidelines + mattpocock/skills) regardless of stack
- Do not recommend community skills with `Sends data` or `Arbitrary code` safety profile without explicitly flagging the risk
