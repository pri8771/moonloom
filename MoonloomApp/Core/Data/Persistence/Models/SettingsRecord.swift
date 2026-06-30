import Foundation
import SwiftData

/// SwiftData persistence record for player settings + last-active time.
/// See `TECHNICAL_PRD.md` §3. A single row exists per save.
@Model
final class SettingsRecord {
    var isMusicEnabled: Bool
    var isSFXEnabled: Bool
    var isNotificationsEnabled: Bool
    var offlineEarningCapHours: Int
    var theme: String
    var lastActiveTimestamp: Date

    init(
        isMusicEnabled: Bool,
        isSFXEnabled: Bool,
        isNotificationsEnabled: Bool,
        offlineEarningCapHours: Int,
        theme: String,
        lastActiveTimestamp: Date
    ) {
        self.isMusicEnabled = isMusicEnabled
        self.isSFXEnabled = isSFXEnabled
        self.isNotificationsEnabled = isNotificationsEnabled
        self.offlineEarningCapHours = offlineEarningCapHours
        self.theme = theme
        self.lastActiveTimestamp = lastActiveTimestamp
    }
}
