# Current Status — Moonloom: Idle Dream Factory

**Last updated:** 2026-06-29
**Repository:** `pri8771/codex_app_3`
**Active development branch:** `codex/production-readiness`
**Base implementation branch:** `claude/moonloom-idle-game-9l8e5p`
**Open implementation PR:** https://github.com/pri8771/codex_app_3/pull/1
**Notion build hub:** https://app.notion.com/p/38eab1f2276581959e1ecc46b07557de

## Summary

`main` is documentation-only. The working iOS app implementation exists on the
implementation PR branch and is now being stabilized on
`codex/production-readiness`.

The app is a playable early SwiftUI/SwiftData idle-game prototype, not yet a
production-ready App Store build. It has the core idle loop, 12 production tiers,
building unlocks and upgrades, Dream Orders, Moon Restoration nodes, offline
earnings, New Moon Reset prestige math, SwiftData persistence, and XCTest
coverage.

## Verified Locally

- Xcode 26.6 was available locally.
- `xcodebuild build` succeeded against an available iPhone 17 simulator.
- Simulator launch succeeded and rendered the Factory screen.
- `xcodebuild test` initially ran 87 tests with 1 failure:
  `NumberAbbreviatorTests.testRolloverDoesNotProduce1000K`.
- The formatter rollover bug has been fixed on `codex/production-readiness`.
- Full local test suite now passes: 89 tests, 0 failures on an iPhone 17
  simulator.

## Implemented

- SwiftUI app shell and `MoonloomApp.xcodeproj`.
- Four-tab app navigation: Factory, Moon, Shop, Settings.
- `AppContainer` lifecycle coordinator and `GameState` source of truth.
- `ProductionEngine` actor.
- 12 production tiers in `EconomyConfig`.
- Building purchase, tier unlock, and leveled building upgrade systems.
- Milestone global multiplier.
- Dream Orders with Stardust rewards.
- Moon Restoration biome nodes and story beats.
- Offline earnings calculator and welcome-back modal.
- Prestige calculator and New Moon Reset flow.
- SwiftData persistence records/repository.
- Persistence failures now surface through throwing repository/service APIs and
  a root-level data warning instead of being silently ignored.
- Haptics hooks.
- Audio and analytics interfaces, currently inert stubs.
- Unit tests for economy, orders, restoration, prestige, settings, formatting,
  and SwiftData repository round-trips.

## Not Yet Production Ready

- PR #1 is not merged into `main`.
- GitHub Actions CI was missing; `ios-ci.yml` has now been added on this branch.
- StoreKit 2 purchase flow is not implemented.
- Local notifications are not implemented.
- Lunar Codex permanent upgrades are not implemented.
- Achievements are not implemented.
- Cosmetic ownership/theme application is not implemented.
- Final art, app icon, animations, music, and SFX are not present.
- SwiftData migration/recovery policy needs product review beyond the current
  visible error handling.
- Economy model decision remains open: all-Moonlight implementation vs. PRD
  multi-currency production chain.
- Full device matrix, accessibility, performance, and TestFlight QA remain.

## Immediate Next Steps

1. Push `codex/production-readiness` and verify the remote GitHub Actions run.
2. Open/stack a PR against the
   implementation branch or `main`.
3. Decide and document the canonical economy model.
4. Define SwiftData migration, backup, and corrupted-store recovery behavior.
5. Implement Lunar Codex and StoreKit before calling the app production-ready.
