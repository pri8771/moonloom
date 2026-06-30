import Foundation

/// A cumulative-Moonlight milestone. Crossing its threshold grants a permanent
/// global production-multiplier bonus (MOONLOOM-PROMPT-004).
struct Milestone: Identifiable, Sendable, Hashable {
    /// 1-based index of the milestone.
    let index: Int
    /// Lifetime Moonlight required to reach this milestone.
    let threshold: Double
    /// Global multiplier bonus granted (e.g. 0.10 = +10%).
    let bonus: Double

    var id: Int { index }
}

/// Pure, deterministic milestone math, shared by `MilestoneService` and tests.
struct MilestoneCalculator: Sendable {
    let config: EconomyConfig

    init(config: EconomyConfig = EconomyConfig()) {
        self.config = config
    }

    /// All milestones defined by the config thresholds.
    var milestones: [Milestone] {
        config.milestoneMoonlightThresholds.enumerated().map { offset, threshold in
            Milestone(index: offset + 1, threshold: threshold, bonus: config.milestoneBonusPerMilestone)
        }
    }

    /// How many milestones the given lifetime Moonlight has reached.
    func reachedCount(lifetimeMoonlight: Double) -> Int {
        guard lifetimeMoonlight > 0 else { return 0 }
        return config.milestoneMoonlightThresholds.reduce(0) { count, threshold in
            lifetimeMoonlight >= threshold ? count + 1 : count
        }
    }

    /// Global production multiplier for a given number of reached milestones,
    /// clamped to the configured safety cap.
    func multiplier(reachedCount: Int) -> Double {
        let raw = 1.0 + Double(max(0, reachedCount)) * config.milestoneBonusPerMilestone
        return min(raw, config.maxGlobalMultiplier)
    }

    /// Global multiplier for the given lifetime Moonlight.
    func multiplier(lifetimeMoonlight: Double) -> Double {
        multiplier(reachedCount: reachedCount(lifetimeMoonlight: lifetimeMoonlight))
    }
}
