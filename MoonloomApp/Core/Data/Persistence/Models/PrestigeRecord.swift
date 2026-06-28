import Foundation
import SwiftData

/// SwiftData persistence record for prestige + run progress.
///
/// Extends the `TECHNICAL_PRD.md` §3 definition with two foundation fields:
/// `currentMoonRestoration` (the in-progress run's restoration, 0...1) and
/// `purchasedUpgradeIDs` (run-scoped upgrade flags). A single row exists per
/// save.
@Model
final class PrestigeRecord {
    var resetCount: Int
    var totalLucidShardsEarned: Double
    var permanentUpgrades: [String]
    var bestRunMoonlightRestored: Double
    var lastResetDate: Date?
    var currentMoonRestoration: Double
    var purchasedUpgradeIDs: [String]
    var schemaVersion: Int

    init(
        resetCount: Int,
        totalLucidShardsEarned: Double,
        permanentUpgrades: [String],
        bestRunMoonlightRestored: Double,
        lastResetDate: Date?,
        currentMoonRestoration: Double,
        purchasedUpgradeIDs: [String],
        schemaVersion: Int
    ) {
        self.resetCount = resetCount
        self.totalLucidShardsEarned = totalLucidShardsEarned
        self.permanentUpgrades = permanentUpgrades
        self.bestRunMoonlightRestored = bestRunMoonlightRestored
        self.lastResetDate = lastResetDate
        self.currentMoonRestoration = currentMoonRestoration
        self.purchasedUpgradeIDs = purchasedUpgradeIDs
        self.schemaVersion = schemaVersion
    }
}
