import Foundation
import SwiftData

/// SwiftData persistence for milestone progress. A single row records how many
/// cumulative-Moonlight milestones have been reached, so the global multiplier
/// survives relaunches (MOONLOOM-PROMPT-004). Milestones are permanent — once
/// reached they never un-reach (the stored count is monotonic).
@Model
final class MilestoneRecord {
    var reachedCount: Int

    init(reachedCount: Int) {
        self.reachedCount = reachedCount
    }
}
