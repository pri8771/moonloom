import Foundation

/// Produces the single most useful "what to do next" hint for the player, so the
/// first five minutes are understandable without a tutorial (Phase 2 brief:
/// "first 5 minutes of guided progression").
///
/// Pure presentation logic over a read-only view of game state; `@MainActor`
/// only because it reads the main-actor `GameState`. Returns `nil` once the
/// player is clearly self-directed (deep into the game).
@MainActor
struct ProgressionGuide {

    private let state: GameState

    init(state: GameState) {
        self.state = state
    }

    /// A short, imperative next step, or `nil` if no nudge is needed.
    func nextObjective() -> String? {
        let formatter = NumberAbbreviator()
        let tiers = state.config.tiers

        // 1. Bootstrap: build the very first production station.
        if state.totalBuildingCount == 0, let first = tiers.first {
            return "Tap Buy on \(first.name) to start producing Moonlight."
        }

        // 2. A ready order is the highest-value action (free Stardust).
        if let order = state.activeOrder, state.canFulfill(order) {
            return "A Dream Order is ready — open Orders to claim \(formatter.string(from: order.rewardAmount)) Stardust."
        }

        // 3. A tier ready to unlock is a major progress beat.
        if let tier = tiers.first(where: { state.canUnlockTier($0) }) {
            return "Unlock \(tier.name) for \(formatter.string(from: tier.unlockCost)) Moonlight."
        }

        // 4. A restorable biome brightens the moon.
        if let node = state.nextRestorationNode, state.canRestore(node) {
            return "Restore \(node.name) on the Moon screen to brighten the moon."
        }

        // 5. Nudge toward an affordable upgrade (clear power spike).
        if let tier = state.upgradeableTiers().first {
            let level = state.upgradeLevel(of: tier.id) + 1
            return "Upgrade \(tier.name) to level \(level) to boost its output ×1.5."
        }

        // 6. Point toward the next locked tier's unlock cost.
        if let tier = tiers.first(where: { !state.isUnlocked($0) && state.isPreviousTierUnlocked($0) }) {
            return "Save \(formatter.string(from: tier.unlockCost)) Moonlight to unlock \(tier.name)."
        }

        // 7. Otherwise, point toward the next biome's cost.
        if let node = state.nextRestorationNode, state.amount(of: .moonlight) < node.cost {
            return "Save \(formatter.string(from: node.cost)) Moonlight to restore \(node.name)."
        }

        return nil
    }
}
