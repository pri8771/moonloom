# Bug Tracker — Moonloom: Idle Dream Factory (codex_app_3)

**Game:** Moonloom: Idle Dream Factory
**Platform:** iOS 17.0+
**Last Updated:** 2026-06-29

---

## Legend

| Field | Values |
|-------|--------|
| **Status** | 🔴 Open / 🟡 In Progress / 🟢 Closed / ⚫ Deferred / 🔵 Cannot Reproduce |
| **Severity** | P0 (Crash) / P1 (Major) / P2 (Minor) / P3 (Cosmetic) |
| **Type** | Crash / Logic / UI / Performance / IAP / Data / Audio |

---

## Active Bugs

### BUG-002: GitHub Actions CI not yet verified on remote

**Severity:** P2
**Type:** Performance (process / CI)
**Status:** 🔴 Open
**Date:** 2026-06-29
**Device:** GitHub Actions
**App Version:** 1.0 / Build 1

#### Steps to Reproduce
1. Open GitHub PR #1 / the production-readiness branch.
2. Inspect status checks.

#### Expected
GitHub Actions runs `xcodebuild build` and `xcodebuild test` for every PR.

#### Actual
CI workflow has been added on `codex/production-readiness`, but has not yet been
verified by a remote push.

#### Notes
Next action: push `codex/production-readiness` and verify the workflow runs
green on GitHub.

---

## Closed Bugs

| Bug ID | Title | Severity | Type | Status | Date | Device | Steps | Expected | Actual | Root Cause | Fix | Fixed Date |
|--------|-------|----------|------|--------|------|--------|-------|----------|--------|-----------|-----|-----------|
| BUG-001 | Foundation build/tests not executed in authoring environment | P2 | Process / CI | 🟢 | 2026-06-28 | N/A | Inspect foundation commits | Build/test should run on macOS | Authoring environment lacked Xcode | No macOS toolchain in original authoring session | Verified local Xcode build/test on 2026-06-29; added CI workflow on `codex/production-readiness` | 2026-06-29 |
| BUG-003 | Number formatter renders 999,999 as 1000K | P2 | UI / Logic | 🟢 | 2026-06-29 | iPhone 17 simulator | Run `NumberAbbreviatorTests.testRolloverDoesNotProduce1000K` | `999_999` renders as `1M` | Formatter returned `1000K` | Rollover guard checked unrounded scaled value before display rounding | Roll up suffix when rounded scaled value reaches 1000 | 2026-06-29 |
| BUG-004 | SwiftData save/load/delete failures are silently ignored | P1 | Data | 🟢 | 2026-06-29 | iPhone 17 simulator | Inspect repository and milestone persistence paths | Persistence errors should propagate and be visible | `try?` discarded fetch/save/delete errors | Repository and milestone service APIs swallowed thrown SwiftData failures | Converted persistence APIs to throw, added root data warning, and covered save/load/delete with SwiftData tests | 2026-06-29 |

---

## Pre-Development Risk Register

| Risk ID | Area | Description | Likelihood | Mitigation |
|---------|------|-------------|-----------|-----------|
| RISK-001 | Production Engine | Timer drift causing incorrect CPS over time | Medium | Use precise Date comparison, not cumulative timer |
| RISK-002 | Production Engine | Double-tick on app resume from background | Medium | Track lastTickTimestamp precisely, resume from exact point |
| RISK-003 | SwiftData | Performance degradation with 100+ building records | Low | Use @Transient for computed values, minimize @Model mutations |
| RISK-004 | Offline Calc | Earnings calculation overflow (Double precision) | Low | Use BigDecimal or Decimal for large numbers |
| RISK-005 | StoreKit 2 | Subscription status stale (not refreshed) | Medium | Refresh on every app launch, not just purchase |
| RISK-006 | StoreKit 2 | Offline entitlement check fails | Low | Cache last known entitlement state locally |
| RISK-007 | Notifications | Notification fires while app is open | Medium | Check app state before scheduling |
| RISK-008 | Prestige | Race condition between reset and active production tick | Low | Use actor isolation, stop tick before reset |
| RISK-009 | Performance | Expensive re-renders on every production tick | High | Use @Observable + fine-grained updates, not full view refresh |
| RISK-010 | Audio | Background audio interrupted by calls/media | Medium | Use AVAudioSession .ambient category, duck properly |

---

## Bug Filing Template

```markdown
### BUG-[XXX]: [Short Title]

**Severity:** P0/P1/P2/P3
**Type:** Crash/Logic/UI/Performance/IAP/Data/Audio
**Status:** 🔴 Open
**Date:** YYYY-MM-DD
**Device:** [Model] / iOS [version]
**App Version:** [version] / Build [number]

#### Steps to Reproduce
1. 
2. 
3. 

#### Expected


#### Actual


#### Frequency
[ ] Always [ ] Sometimes (__%) [ ] Rare [ ] Cannot Reproduce

#### Attachments
- Screenshots:
- Crash log:
- Console:

#### Notes

```

---

## Statistics

| Metric | Count |
|--------|-------|
| Total Filed | 4 |
| Open 🔴 | 1 |
| In Progress 🟡 | 0 |
| Closed 🟢 | 3 |
| Deferred ⚫ | 0 |
| P0 Crashes | 0 |
| P1 Major | 0 |

---

*Bugs must be filed immediately when discovered. Never ship with P0 or P1 bugs.*
*Last Updated: 2026-06-29*
