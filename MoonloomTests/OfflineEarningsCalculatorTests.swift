import XCTest
@testable import MoonloomApp

final class OfflineEarningsCalculatorTests: XCTestCase {

    private let calculator = OfflineEarningsCalculator()
    private let config = EconomyConfig()

    /// MOONLOOM-PROMPT-004: 1-hour offline simulation produces a correct
    /// per-building breakdown (and identifies the top earner).
    func testPerBuildingBreakdownOverOneHour() throws {
        let start = Date(timeIntervalSince1970: 0)
        let oneHourLater = start.addingTimeInterval(3_600)
        let net = try XCTUnwrap(config.tier(id: "whisper_net"))
        let well = try XCTUnwrap(config.tier(id: "lullaby_well"))

        let result = calculator.calculate(
            perTier: [(net, 2.0), (well, 5.0)],
            capHours: 2,
            lastActive: start,
            now: oneHourLater
        )

        // Each: rate × 3600s × 0.5 efficiency.
        let netExpected = 2.0 * 3_600 * 0.5
        let wellExpected = 5.0 * 3_600 * 0.5
        XCTAssertEqual(result.perTier.count, 2)
        let netEarning = result.perTier.first { $0.tierID == "whisper_net" }
        let wellEarning = result.perTier.first { $0.tierID == "lullaby_well" }
        XCTAssertEqual(netEarning?.amount ?? -1, netExpected, accuracy: 0.001)
        XCTAssertEqual(wellEarning?.amount ?? -1, wellExpected, accuracy: 0.001)
        // Aggregate Moonlight = sum of both.
        XCTAssertEqual(result.earnings[.moonlight] ?? 0, netExpected + wellExpected, accuracy: 0.001)
        // Lullaby Wells earned more, so it's the top earner.
        XCTAssertEqual(result.mostProductiveTier?.tierID, "lullaby_well")
        XCTAssertFalse(result.capApplied)
    }

    func testBreakdownRespectsCap() throws {
        let start = Date(timeIntervalSince1970: 0)
        let tenHoursLater = start.addingTimeInterval(10 * 3_600)
        let net = try XCTUnwrap(config.tier(id: "whisper_net"))
        let result = calculator.calculate(
            perTier: [(net, 1.0)],
            capHours: 2,
            lastActive: start,
            now: tenHoursLater
        )
        XCTAssertEqual(result.creditedSeconds, 7_200, accuracy: 0.001)
        XCTAssertTrue(result.capApplied)
        XCTAssertEqual(result.perTier.first?.amount ?? 0, 1.0 * 7_200 * 0.5, accuracy: 0.001)
    }

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
