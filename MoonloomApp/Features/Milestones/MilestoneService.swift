import Foundation
import SwiftData

/// Result of evaluating milestone progress against lifetime Moonlight.
struct MilestoneEvaluation: Sendable, Equatable {
    /// Total milestones reached (monotonic).
    let reachedCount: Int
    /// Current global production multiplier (capped).
    let multiplier: Double
    /// How many milestones were newly reached in this evaluation (for celebration).
    let newlyReached: Int
}

/// Owns milestone progression and its SwiftData persistence.
///
/// Implemented as a `@ModelActor` so its `ModelContext` access is serialised off
/// the main thread (MOONLOOM-PROMPT-004: "MilestoneService actor with SwiftData
/// persistence"). The actual multiplier math lives in the pure
/// `MilestoneCalculator`; this actor evaluates against lifetime Moonlight,
/// persists the monotonic reached-count, and reports newly-reached milestones so
/// the app can celebrate them. The reached-count is monotonic, so milestones are
/// permanent even across a New Moon Reset.
@ModelActor
actor MilestoneService {

    private var calculator: MilestoneCalculator { MilestoneCalculator(config: EconomyConfig()) }

    /// Current persisted reached-count (0 if no row yet).
    func currentReachedCount() throws -> Int {
        (try record())?.reachedCount ?? 0
    }

    /// Current persisted global multiplier.
    func currentMultiplier() throws -> Double {
        calculator.multiplier(reachedCount: try currentReachedCount())
    }

    /// Evaluate against lifetime Moonlight, persist any new progress, and report
    /// the result. Reached-count only ever increases.
    func evaluate(lifetimeMoonlight: Double) throws -> MilestoneEvaluation {
        let stored = try record()
        let previous = stored?.reachedCount ?? 0
        let computed = calculator.reachedCount(lifetimeMoonlight: lifetimeMoonlight)
        let reached = max(previous, computed)

        if let stored {
            if stored.reachedCount != reached {
                stored.reachedCount = reached
                try modelContext.save()
            }
        } else {
            modelContext.insert(MilestoneRecord(reachedCount: reached))
            try modelContext.save()
        }

        return MilestoneEvaluation(
            reachedCount: reached,
            multiplier: calculator.multiplier(reachedCount: reached),
            newlyReached: max(0, reached - previous)
        )
    }

    /// Reset milestone progress to zero (used by a full save wipe).
    func reset() throws {
        if let stored = try record() {
            stored.reachedCount = 0
        } else {
            modelContext.insert(MilestoneRecord(reachedCount: 0))
        }
        try modelContext.save()
    }

    private func record() throws -> MilestoneRecord? {
        try modelContext.fetch(FetchDescriptor<MilestoneRecord>()).first
    }
}
