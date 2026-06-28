import Foundation
import SwiftData

/// SwiftData persistence record for a single currency balance.
/// See `TECHNICAL_PRD.md` §3.
@Model
final class CurrencyRecord {
    /// `ResourceType.rawValue`, unique per save.
    @Attribute(.unique) var type: String
    var amount: Double
    var lifetimeEarned: Double
    var lastUpdated: Date

    init(type: String, amount: Double, lifetimeEarned: Double, lastUpdated: Date) {
        self.type = type
        self.amount = amount
        self.lifetimeEarned = lifetimeEarned
        self.lastUpdated = lastUpdated
    }
}
