import Foundation

/// Pure, deterministic calculation of offline earnings.
///
/// Implements `TECHNICAL_PRD.md` §5: cap elapsed time at the player's offline
/// cap, apply the offline efficiency penalty, and award `cps × cappedTime ×
/// efficiency` per resource. Kept free of UI/state so it is trivially testable.
struct OfflineEarningsCalculator: Sendable {

    let config: EconomyConfig

    init(config: EconomyConfig = EconomyConfig()) {
        self.config = config
    }

    /// Result of an offline calculation.
    struct Result: Sendable, Equatable {
        /// Raw seconds elapsed since the player was last active.
        var elapsedSeconds: TimeInterval
        /// Seconds actually credited after applying the offline cap.
        var creditedSeconds: TimeInterval
        /// Earnings per resource (already penalised and capped).
        var earnings: [ResourceType: Double]

        /// Whether anything meaningful was earned (used to decide whether to
        /// show the "Welcome back!" modal).
        var hasEarnings: Bool {
            earnings.values.contains { $0 > 0 }
        }
    }

    /// Calculate offline earnings.
    /// - Parameters:
    ///   - perSecond: active production-per-second per resource.
    ///   - capHours: the player's current offline cap, in hours.
    ///   - lastActive: timestamp the player was last active.
    ///   - now: current time (injected for testability).
    func calculate(
        perSecond: [ResourceType: Double],
        capHours: Int,
        lastActive: Date,
        now: Date
    ) -> Result {
        let elapsed = max(0, now.timeIntervalSince(lastActive))
        let capSeconds = TimeInterval(max(0, capHours)) * 3_600
        let credited = min(elapsed, capSeconds)

        var earnings: [ResourceType: Double] = [:]
        if credited > 0 {
            for (resource, rate) in perSecond where rate > 0 {
                earnings[resource] = rate * credited * config.offlineEfficiency
            }
        }
        return Result(elapsedSeconds: elapsed, creditedSeconds: credited, earnings: earnings)
    }
}
