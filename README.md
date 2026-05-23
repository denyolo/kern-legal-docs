# KERN — Legal & Privacy Documentation

This repository contains the **publicly auditable legal documentation** for [KERN](https://www.getkern.app/), an iOS app for inner work (reflection, meditation, manifestation).

## What's here

- **[privacy-policy.de.md](privacy-policy.de.md)** — Datenschutz-Erklärung (deutsch)
- **[privacy-policy.en.md](privacy-policy.en.md)** — Privacy Policy (English)
- **[analytics-events.md](analytics-events.md)** — Schema documentation for anonymous usage metrics
- **[admin-conduct.md](admin-conduct.md)** — Owner Code of Conduct: how data access by Dennis (KERN's owner) is constrained
- **[migrations/](migrations/)** — Database schema (PostgreSQL/Supabase migrations) — what tables exist, what columns, what constraints

## Why this exists

KERN is an app for **personal, inner content**. Trust is non-negotiable. The KERN [Privacy Policy](privacy-policy.de.md) makes specific claims about what we track (numbers, no content) and what we don't (third-party analytics, ad SDKs, cookies). It also documents [Dennis Lisk's owner-level data access constraints](admin-conduct.md).

This repository makes those claims **verifiable** — anyone can:

- Read the actual SQL schema for [`usage_events`](migrations/0005_usage_events.sql) and verify it has **no text columns for content**, only numbers and controlled enums
- Read the [admin-conduct.md](admin-conduct.md) self-binding rules (committed, dated, with full history)
- See the full version history of these documents — if anything changes, the commit log shows what, when, and why

The **application code** itself stays in a [private repository](https://github.com/denyolo/kern-app) — competitive strategy, marketing material, and code architecture are not part of the privacy promise.

## Single source of truth

The master copies of these files live in the private `kern-app` repository under `docs/legal/` and `supabase/migrations/`. They are mirrored here automatically when changed. The two copies should always be identical.

If you ever spot a discrepancy: please write to [datenschutz@getkern.app](mailto:datenschutz@getkern.app) — we treat that as a serious issue.

## License

The documentation in this repository is licensed under **[CC-BY-4.0](LICENSE)** — feel free to reuse, reference, or build on.

## Contact

- **General questions:** [hello@getkern.app](mailto:hello@getkern.app)
- **Privacy / data protection:** [datenschutz@getkern.app](mailto:datenschutz@getkern.app)

---

*KERN — Reflektieren · Meditieren · Manifestieren.*
*Deine inneren Bewegungen gehören dir.*
