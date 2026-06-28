import XCTest
@testable import MoonloomApp

final class OfflineEarningsCalculatorTests: XCTestCase {

    private let calculator = OfflineEarningsCalculator()

    func testEarningsAppliesEfficiencyPenalty() {
        let start = Date(timeIntervalSince1970: 0)
        let oneHourLater = start.addingTimeInterval(3_600)
        let result = calculator.calculate(
            perSecond: [.whispers: 10],
            capHours: 2,
            lastActive: start,
            now: oneHourLater
        )
        // 10/s * 3600s * 0.5 efficiency = 18_000.
        XCTAssertEqual(result.earnings[.whispers] ?? 0, 18_000, accuracy: 0.001)
        XCTAssertEqual(result.creditedSeconds, 3_600, accuracy: 0.001)
    }

    func testCapEnforced() {
        let start = Date(timeIntervalSince1970: 0)
        let tenHoursLater = start.addingTimeInterval(10 * 3_600)
        let result = calculator.calculate(
            perSecond: [.whispers: 1],
            capHours: 2,
            lastActive: start,
            now: tenHoursLater
        )
        // Capped at 2h: 1/s * 7200s * 0.5 = 3_600.
        XCTAssertEqual(result.creditedSeconds, 7_200, accuracy: 0.001)
        XCTAssertEqual(result.earnings[.whispers] ?? 0, 3_600, accuracy: 0.001)
        XCTAssertEqual(result.elapsedSeconds, 36_000, accuracy: 0.001)
    }

    func testNoTimeElapsedYieldsNoEarnings() {
        let now = Date(timeIntervalSince1970: 1_000)
        let result = calculator.calculate(
            perSecond: [.whispers: 100],
            capHours: 2,
            lastActive: now,
            now: now
        )
        XCTAssertFalse(result.hasEarnings)
    }

    func testNegativeElapsedClampedToZero() {
        let now = Date(timeIntervalSince1970: 1_000)
        let earlier = now.addingTimeInterval(-500) // clock went backwards
        let result = calculator.calculate(
            perSecond: [.whispers: 100],
            capHours: 2,
            lastActive: now,
            now: earlier
        )
        XCTAssertEqual(result.elapsedSeconds, 0, accuracy: 0.001)
        XCTAssertFalse(result.hasEarnings)
    }
}
