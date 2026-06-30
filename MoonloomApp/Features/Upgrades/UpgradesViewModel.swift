import Foundation

/// Presentation logic for the Upgrades panel. For each unlocked building it
/// computes the current upgrade level, the current/next output multiplier, the
/// cost to the next level, and the before/after production rate so the player
/// gets clear upgrade feedback (MOONLOOM-PROMPT-004). Keeps math out of the view.
@MainActor
struct UpgradesViewModel {
    private let gameState: GameState
    private let formatter = NumberAbbreviator()

    init(gameState: GameState) {
        self.gameState = gameState
    }

    struct Row: Identifiable {
        let tier: ProductionTier
        let level: Int
        let maxLevel: Int
        let isMaxed: Bool
        let canAfford: Bool
        let nextCost: Double
        let currentMultiplier: Double
        let nextMultiplier: Double
        let beforeRatePerSecond: Double
        let afterRatePerSecond: Double
        var id: String { tier.id }
    }

    /// One row per unlocked building, in tier order.
    var rows: [Row] {
        gameState.unlockedTiers.map { tier in
            let level = gameState.upgradeLevel(of: tier.id)
            let maxed = gameState.isMaxLevel(tier)
            let nextCost = gameState.upgradeCost(for: tier)
            let before = gameState.outputPerSecond(forTier: tier)
            let currentMult = gameState.config.upgradeMultiplier(forLevel: level)
            let nextMult = gameState.config.upgradeMultiplier(forLevel: level + 1)
            // after = before with one extra level (before already includes `level`).
            let after = maxed ? before : before / currentMult * nextMult
            return Row(
                tier: tier,
                level: level,
                maxLevel: gameState.config.maxUpgradeLevel,
                isMaxed: maxed,
                canAfford: gameState.canUpgrade(tier),
                nextCost: nextCost,
                currentMultiplier: currentMult,
                nextMultiplier: nextMult,
                beforeRatePerSecond: before,
                afterRatePerSecond: after
            )
        }
    }

    var hasRows: Bool { !gameState.unlockedTiers.isEmpty }

    func format(_ value: Double) -> String { formatter.string(from: value) }
}
