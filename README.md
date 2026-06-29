# Moonloom: Idle Dream Factory

> *"While the world sleeps, your factory dreams."*

## Overview

**Moonloom: Idle Dream Factory** is a premium iOS idle/incremental game where you build and manage an ever-growing factory that harvests whispers from sleeping towns, spins them into dreamthread, weaves dreams, and ships them to the moon via moth couriers — gradually restoring the moon's faded light.

**Genre:** Idle / Incremental
**Platform:** iOS 17.0+
**Engine:** SwiftUI + SwiftData + StoreKit 2
**Status:** 🟡 Active Development — playable early iOS prototype lives on PR #1

---

## 🌙 The Story

The moon has gone dark. Sleeping towns have lost their dreams. As the keeper of the last Moonloom, you must rebuild the Dream Factory — harvesting whispers, spinning dreamthread, and weaving the dreams that power moonlight itself.

---

## 🏭 Core Loop

```
Sleeping Towns → Whispers → Dreamthread → Dreams → Moth Couriers → Moonlight → Upgrades → Moon Restoration → New Moon Reset (Prestige)
```

---

## 🏗️ Production Tiers (12+)

| Tier | Building | Produces |
|------|----------|---------|
| 1 | Whisper Nets | Whispers |
| 2 | Lullaby Wells | Amplified Whispers |
| 3 | Dreamthread Spindles | Dreamthread |
| 4 | Memory Looms | Dream Fabric |
| 5 | Nightmare Filters | Purified Dreams |
| 6 | Star Dye Vats | Starlit Dreams |
| 7 | Moth Courier Nests | Dream Deliveries |
| 8 | Cloud Packaging Line | Packaged Shipments |
| 9 | Dream Atlas | Delivery Routes |
| 10 | Comet Shipping Dock | Express Deliveries |
| 11 | Lucid Observatory | Moonlight Amplification |
| 12 | Moonheart Engine | Moon Restoration |

---

## 💎 Currencies

| Currency | Type | Source |
|----------|------|--------|
| Whispers | Soft (primary) | Whisper Nets, town sleeping cycles |
| Dreamthread | Soft (secondary) | Dreamthread Spindles |
| Moonlight | Soft (progression) | Moth Couriers delivering dreams |
| Stardust | Premium soft | Daily login, achievements, events |
| Lucid Shards | Prestige | Earned on New Moon Reset |

---

## 🌑 Prestige: New Moon Reset

When you restore enough of the moon, you can trigger a **New Moon Reset**:
- Factory resets to beginning
- Earn Lucid Shards based on restoration progress
- Lucid Shards → permanent upgrades (Lunar Codex)
- Each reset is faster and deeper than the last

---

## 📱 Tech Stack

- **Language:** Swift 5.9
- **UI Framework:** SwiftUI (iOS 17+)
- **Data:** SwiftData
- **Monetization:** StoreKit 2 (IAP)
- **Architecture:** Clean Architecture + MVVM
- **No Third-Party Dependencies** — 100% Apple frameworks
- **Offline-First:** Full gameplay without network connection

---

## 💰 Monetization

All monetization is cosmetic or convenience. No pay-to-win.

- **Dream Packs** — cosmetic factory themes
- **Moth Skins** — visual courier variants
- **Moonloom Pass** — monthly subscription (2x offline earnings)
- **Stardust Bundles** — premium currency for cosmetics
- **Lucid Accelerator** — skip reset wait (one-time event)

---

## 📍 Current Repository Status

`main` began as the documentation phase. The first app implementation lives in
GitHub PR #1:

https://github.com/pri8771/codex_app_3/pull/1

That implementation includes the SwiftUI app shell, SwiftData persistence, core
idle loop, 12 production tiers, building unlocks/upgrades, Dream Orders, Moon
Restoration, offline earnings, prestige math, and XCTest coverage.

The application is not yet production ready. StoreKit purchasing, local
notifications, achievements, Lunar Codex permanent upgrades, final art/audio,
full QA, accessibility polish, and App Store launch assets remain.

Product note: the PRDs describe a multi-currency production chain, while the
current prototype uses Moonlight as the single produced/spendable progression
currency. Resolve that economy decision before balancing or beta.

Notion build hub:
https://app.notion.com/p/38eab1f2276581959e1ecc46b07557de

See `docs/CURRENT_STATUS.md` for the latest engineering status.

---

## 📂 Repository Structure

```
codex_app_3/
├── MoonloomApp.xcodeproj
├── MoonloomApp/
│   ├── App/
│   ├── Core/
│   ├── Features/
│   ├── Presentation/
│   ├── Resources/
│   └── Services/
├── MoonloomTests/
├── README.md
├── project.yml
└── docs/
    ├── prd/
    │   ├── TECHNICAL_PRD.md
    │   ├── NON_TECHNICAL_PRD.md
    │   ├── BUSINESS_PLAN_PRD.md
    │   ├── MONETIZATION_PRD.md
    │   ├── PRIVATE_BETA_PRD.md
    │   ├── PUBLIC_BETA_PRD.md
    │   ├── GO_TO_MARKET_PRD.md
    │   ├── MARKETING_PLAN_PRD.md
    │   └── INVESTOR_DECK_PRD.md
    ├── PROJECT_TRACKER.md
    ├── BUG_TRACKER.md
    ├── CURRENT_STATUS.md
    └── PROMPT_LOG.md
```

---

## 🗓️ Timeline

| Milestone | Target Date |
|-----------|-------------|
| Documentation Complete | Q2 2026 |
| MVP Development | Q3 2026 |
| Private Beta | Q4 2026 |
| Public Beta | Q1 2027 |
| App Store Launch | Q1 2027 |

---

*Built with 🌙 by the Moonloom team*
