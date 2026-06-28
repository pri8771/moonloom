import Foundation

/// Static definition of one of the 12 production tiers (see README "Production
/// Tiers" table and `TECHNICAL_PRD.md` §4). These values are immutable game
/// configuration; mutable per-player state lives in `GameState`.
struct ProductionTier: Identifiable, Sendable, Hashable {
    /// Stable identifier, e.g. `"whisper_net"`. Used as the persistence key.
    let id: String
    /// Tier number, 1...12.
    let tier: Int
    /// Display name, e.g. "Whisper Nets".
    let name: String
    /// Short flavor description shown on the building row.
    let summary: String
    /// SF Symbol used as the building glyph.
    let systemImage: String
    /// Currency this building produces per second (per unit owned).
    let produces: ResourceType
    /// Base output per second for a single building before multipliers.
    let baseOutputPerSecond: Double
    /// Currency spent to purchase this building.
    let costCurrency: ResourceType
    /// Cost of the first building of this tier.
    let baseCost: Double
    /// Exponential cost growth factor: `cost(n) = baseCost * growth^n`.
    let costGrowth: Double
    /// Number of the *previous* tier's buildings required before this tier
    /// unlocks. Tier 1 is always unlocked (`unlockRequirement == 0`).
    let unlockRequirement: Int

    /// Cost to purchase the `ownedCount + 1`-th building of this tier.
    /// Uses the standard idle exponential `baseCost * growth^ownedCount`.
    func cost(forOwnedCount ownedCount: Int) -> Double {
        guard ownedCount >= 0 else { return baseCost }
        return baseCost * pow(costGrowth, Double(ownedCount))
    }
}
