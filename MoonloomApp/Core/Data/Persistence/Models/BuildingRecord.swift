import Foundation
import SwiftData

/// SwiftData persistence record for an owned production building.
/// See `TECHNICAL_PRD.md` §3. Tunable fields (`baseCPS`, `multiplier`,
/// `isUnlocked`) are persisted for fidelity but are authoritative in
/// `EconomyConfig` / `GameState`; `count` is the primary persisted state.
@Model
final class BuildingRecord {
    /// Tier identifier, e.g. `"whisper_net"`, unique per save.
    @Attribute(.unique) var id: String
    var tier: Int
    var count: Int
    var baseCPS: Double
    var multiplier: Double
    var isUnlocked: Bool
    var totalProduced: Double
    var lastTickTimestamp: Date

    init(
        id: String,
        tier: Int,
        count: Int,
        baseCPS: Double,
        multiplier: Double,
        isUnlocked: Bool,
        totalProduced: Double,
        lastTickTimestamp: Date
    ) {
        self.id = id
        self.tier = tier
        self.count = count
        self.baseCPS = baseCPS
        self.multiplier = multiplier
        self.isUnlocked = isUnlocked
        self.totalProduced = totalProduced
        self.lastTickTimestamp = lastTickTimestamp
    }
}
