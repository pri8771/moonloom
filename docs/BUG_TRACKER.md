# Bug Tracker — Moonloom: Idle Dream Factory (codex_app_3)

**Game:** Moonloom: Idle Dream Factory
**Platform:** iOS 17.0+
**Last Updated:** 2026-06-27

---

## Legend

| Field | Values |
|-------|--------|
| **Status** | 🔴 Open / 🟡 In Progress / 🟢 Closed / ⚫ Deferred / 🔵 Cannot Reproduce |
| **Severity** | P0 (Crash) / P1 (Major) / P2 (Minor) / P3 (Cosmetic) |
| **Type** | Crash / Logic / UI / Performance / IAP / Data / Audio |

---

## Active Bugs

*No active bugs — development not started.*

---

## Closed Bugs

| Bug ID | Title | Severity | Type | Status | Date | Device | Steps | Expected | Actual | Root Cause | Fix | Fixed Date |
|--------|-------|----------|------|--------|------|--------|-------|----------|--------|-----------|-----|-----------|
| BUG-000 | Template | P2 | Logic | 🟢 | 2026-06-27 | iPhone 15 | 1. Open app 2. Do X | Expected | Actual | Cause | Fix | 2026-06-27 |

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
| Total Filed | 0 |
| Open 🔴 | 0 |
| In Progress 🟡 | 0 |
| Closed 🟢 | 0 |
| Deferred ⚫ | 0 |
| P0 Crashes | 0 |
| P1 Major | 0 |

---

*Bugs must be filed immediately when discovered. Never ship with P0 or P1 bugs.*
*Last Updated: 2026-06-27*
