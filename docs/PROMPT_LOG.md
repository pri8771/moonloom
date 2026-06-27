# Prompt Log — Moonloom: Idle Dream Factory (codex_app_3)

**Game:** Moonloom: Idle Dream Factory
**Platform:** iOS 17.0+
**Purpose:** Complete record of all prompts used to plan, design, and implement Moonloom
**Last Updated:** 2026-06-27

---

## Legend

| Field | Description |
|-------|-------------|
| PROMPT-ID | Sequential identifier |
| Phase | Planning / Architecture / Implementation / Testing |
| Tool | ChatGPT / Claude Code / Claude (Browser) |
| Epic | Related epic from PROJECT_TRACKER.md |
| Status | ✅ Used / 🔄 Active / 📅 Queued |

---

## Phase 0: Ideation (ChatGPT Collaboration)

### PROMPT-001
**Date:** 2026-06-27 | **Phase:** Ideation | **Tool:** ChatGPT | **Epic:** E001 | **Status:** ✅ Used

**Prompt:**
> "I need an idle/incremental iOS game concept that: runs offline (no cloud), is written in Swift, is monetizable via microtransactions, is fairly complex with progression, has near-infinite replayability via prestige, has beautiful modern design, and feels like it was made by a large studio. Can you help develop a full concept?"

**Outcome:** Moonloom: Idle Dream Factory concept developed — dream factory with 12 tiers, New Moon Reset prestige, offline earnings, moth couriers, moon restoration narrative.

---

### PROMPT-002
**Date:** 2026-06-27 | **Phase:** Ideation | **Tool:** ChatGPT | **Epic:** E001 | **Status:** ✅ Used

**Prompt:**
> "For Moonloom: Idle Dream Factory, develop the complete game specification: all 12 production tiers, all currencies (soft and hard), the prestige system, offline mechanics, monetization catalog, and technical requirements."

**Outcome:** Complete Moonloom game specification defined (see TECHNICAL_PRD.md).

---

## Phase 1: Architecture (Claude Code)

### PROMPT-003
**Date:** 2026-07-01 (Planned) | **Phase:** Architecture | **Tool:** Claude Code | **Epic:** E002 | **Status:** 📅 Queued

**Prompt:**
> "You are the lead iOS architect for Moonloom: Idle Dream Factory — an idle/incremental game for iOS 17+. Tech stack: Swift 5.9, SwiftUI, SwiftData, StoreKit 2. No SpriteKit needed (pure SwiftUI).
>
> The game has:
> - 12 production tiers (buildings), each producing resources the next tier needs
> - 5 currencies: Whispers, Dreamthread, Moonlight, Stardust, Lucid Shards
> - Offline earnings: factory produces when app is closed (2h cap, upgradeable to 48h)
> - Prestige system: New Moon Reset — reset for Lucid Shards + permanent upgrades
> - IAP: cosmetics + convenience (StoreKit 2, no pay-to-win)
>
> Create a complete architecture plan:
> 1. Full folder structure (Clean Architecture + MVVM)
> 2. All Swift files needed with responsibilities
> 3. SwiftData models
> 4. Key protocols and interfaces
> 5. ProductionEngine design (how tick loop works, how offline is calculated)
>
> Format as a detailed architectural specification."

**Expected Output:** Complete Xcode architecture plan
**Planned For:** Sprint 1, Week 1

---

### PROMPT-004
**Date:** 2026-07-01 (Planned) | **Phase:** Architecture | **Tool:** ChatGPT | **Epic:** E002 | **Status:** 📅 Queued

**Prompt:**
> "Here is the architecture plan for Moonloom from our iOS architect: [PASTE CLAUDE CODE OUTPUT]. Review for: completeness, idle game best practices, potential performance issues, any missing components for offline earnings or prestige systems, and SwiftData usage patterns. Suggest improvements."

**Expected Output:** Architecture review
**Planned For:** Sprint 1, Week 1

---

## Phase 2: Implementation Prompts (Claude Code)

### PROMPT-005
**Date:** 2026-07-01 (Planned) | **Phase:** Implementation | **Tool:** Claude Code | **Epic:** E002 | **Status:** 📅 Queued

**Prompt:**
> "Create the Xcode project for Moonloom with:
> - App name: Moonloom
> - Bundle ID: com.[team].moonloom
> - Deployment target: iOS 17.0
> - Architecture: Clean Architecture + MVVM
> - Folder structure: [full structure from TECHNICAL_PRD.md]
>
> Create all stub files with boilerplate, imports, and TODO comments. Do not implement logic yet."

**Expected Output:** Complete Xcode project scaffold
**Planned For:** Sprint 1, Day 1

---

### PROMPT-006
**Date:** 2026-07-03 (Planned) | **Phase:** Implementation | **Tool:** Claude Code | **Epic:** E003 | **Status:** 📅 Queued

**Prompt:**
> "Implement all SwiftData @Model types for Moonloom:
>
> 1. BuildingRecord: id, tier (1-12), count, baseCPS, multiplier, isUnlocked, totalProduced, lastTickTimestamp
> 2. CurrencyRecord: type (enum: whispers/dreamthread/moonlight/stardust/lucidShards), amount, lifetimeEarned
> 3. PrestigeRecord: resetCount, totalLucidShardsEarned, permanentUpgrades, bestRun, lastResetDate
> 4. AchievementRecord: id, isUnlocked, progress, unlockedDate
> 5. SettingsRecord: music, sfx, notifications, offlineCapHours, theme, lastActiveTimestamp
> 6. UpgradeRecord: id, buildingID, cost, multiplierBoost, isPurchased
>
> Requirements: Sendable conformance, no force unwraps, full DocC comments, unit tests."

**Expected Output:** All @Model types + tests
**Planned For:** Sprint 1, Days 3-5

---

### PROMPT-007
**Date:** 2026-07-08 (Planned) | **Phase:** Implementation | **Tool:** Claude Code | **Epic:** E004 | **Status:** 📅 Queued

**Prompt:**
> "Implement the ProductionEngine for Moonloom:
>
> - ProductionEngine actor (thread-safe)
> - 0.1 second tick loop using Task.sleep
> - For each building: amount += count × baseCPS × multiplier × globalMultiplier × prestigeMultiplier × deltaTime
> - Building cost formula: baseCost × 1.15^count (exponential scaling)
> - Upgrade detection: unlock milestone upgrades when building count reaches threshold
> - Stop/resume for prestige reset
>
> Performance requirement: tick must complete in < 1ms
> Include: unit tests, performance tests"

**Expected Output:** ProductionEngine.swift + tests
**Planned For:** Sprint 2

---

### PROMPT-008
**Date:** 2026-07-17 (Planned) | **Phase:** Implementation | **Tool:** Claude Code | **Epic:** E005 | **Status:** 📅 Queued

**Prompt:**
> "Implement the offline earnings system for Moonloom:
>
> - On app launch: check SettingsRecord.lastActiveTimestamp
> - Calculate elapsed time (capped at offlineCapHours)
> - Apply 50% efficiency multiplier
> - For each building: offlineEarned = count × baseCPS × multiplier × elapsedTime × 0.5
> - Show 'Welcome back!' modal with breakdown
> - Schedule local notifications at 2h, 8h, 24h with custom messages
>
> Requirements: async/await, no race conditions with active tick, testable"

**Expected Output:** OfflineCalculator.swift + NotificationManager.swift + tests
**Planned For:** Sprint 3

---

### PROMPT-009
**Date:** 2026-07-22 (Planned) | **Phase:** Implementation | **Tool:** Claude Code | **Epic:** E006 | **Status:** 📅 Queued

**Prompt:**
> "Implement the prestige system (New Moon Reset) for Moonloom:
>
> - Trigger condition: moonRestoration >= prestigeThreshold (25% first reset, ×1.5 each subsequent)
> - Lucid Shards = floor(moonRestorationPercent × prestigeMultiplier × resetCountBonus)
> - On reset: all buildings → 0, all soft currencies → 0, keep Stardust + Lucid Shards + permanentUpgrades
> - Lunar Codex: upgrade tree unlocked with Lucid Shards (define 10 permanent upgrades)
> - New Moon Reset confirmation flow with: preview of shards earned, current stats, 'Are you sure?' gate
>
> Requirements: Atomic reset (no partial state), full unit tests"

**Expected Output:** PrestigeUseCase.swift + LunarCodexUpgrade.swift + PrestigeView.swift + tests
**Planned For:** Sprint 4

---

### PROMPT-010
**Date:** 2026-08-24 (Planned) | **Phase:** Implementation | **Tool:** Claude Code | **Epic:** E008 | **Status:** 📅 Queued

**Prompt:**
> "Implement StoreKit 2 monetization for Moonloom with these products:
>
> | ID | Type | Price |
> |----|------|-------|
> | com.moonloom.dream_pack_celestial | Non-consumable | $2.99 |
> | com.moonloom.dream_pack_ember | Non-consumable | $2.99 |
> | com.moonloom.moth_skin_golden | Non-consumable | $1.99 |
> | com.moonloom.moth_skin_shadow | Non-consumable | $1.99 |
> | com.moonloom.stardust_small | Consumable | $0.99 |
> | com.moonloom.stardust_medium | Consumable | $2.99 |
> | com.moonloom.stardust_large | Consumable | $7.99 |
> | com.moonloom.pass_monthly | Auto-renewable | $4.99/mo |
> | com.moonloom.offline_expansion | Non-consumable | $3.99 |
>
> Implement PurchaseManager (ObservableObject):
> - Fetch + cache products on launch
> - purchase(_ product: Product) async throws
> - restorePurchases() async
> - checkEntitlement(for id: String) async -> Bool
> - subscriptionStatus() async -> Status?
> - Persist entitlements in SwiftData
> - Process unfinished transactions on launch
>
> Include StoreKit configuration file + sandbox tests"

**Expected Output:** PurchaseManager.swift + Moonloom.storekit + tests
**Planned For:** Sprint 8

---

## Prompt Statistics

| Phase | Total | Used | Queued |
|-------|-------|------|--------|
| Ideation | 2 | 2 | 0 |
| Architecture | 2 | 0 | 2 |
| Implementation | 6 | 0 | 6 |
| Testing | 0 | 0 | 0 |
| **Total** | **10** | **2** | **8** |

---

*This log is the single source of truth for all AI prompts used in this project.*
*Last Updated: 2026-06-27*
