import Foundation

/// Pure, deterministic prestige (New Moon Reset) math.
///
/// Implements `TECHNICAL_PRD.md` §6: eligibility threshold scaling and the
/// Lucid Shard reward formula. Kept free of state for testability.
struct PrestigeCalculator: Sendable {

    let config: EconomyConfig

    init(config: EconomyConfig = EconomyConfig()) {
        self.config = config
    }

    /// Whether the player may perform a New Moon Reset right now.
    func canPrestige(moonRestoration: Double, resetCount: Int) -> Bool {
        moonRestoration >= threshold(resetCount: resetCount)
    }

    /// Restoration fraction required for the next reset.
    func threshold(resetCount: Int) -> Double {
        config.prestigeThreshold(forResetCount: resetCount)
    }

    /// Lucid Shards awarded for resetting at the given restoration level.
    ///
    /// `floor(restorationPercent × shardMultiplier × resetCountBonus)` where
    /// `resetCountBonus = 1 + resetCount × bonusPerReset`.
    func lucidShardsEarned(moonRestoration: Double, resetCount: Int) -> Double {
        guard canPrestige(moonRestoration: moonRestoration, resetCount: resetCount) else { return 0 }
        let percent = min(max(moonRestoration, 0), 1) * 100
        let resetBonus = 1 + Double(max(resetCount, 0)) * config.prestigeResetBonusPerReset
        let raw = percent / 100 * config.prestigeShardMultiplier * resetBonus
        return floor(raw)
    }
}
