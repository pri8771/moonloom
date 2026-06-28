import Foundation
import SwiftData

/// SwiftData persistence for a building's upgrade level (MOONLOOM-PROMPT-004).
/// Each building (tier) has one record holding its current upgrade level
/// (0...`maxUpgradeLevel`). Upgrade definitions (cost curve, ×1.5 multiplier)
/// live in `EconomyConfig`.
@Model
final class UpgradeRecord {
    /// `ProductionTier.id`, unique per save.
    @Attribute(.unique) var buildingID: String
    var level: Int

    init(buildingID: String, level: Int) {
        self.buildingID = buildingID
        self.level = level
    }
}
