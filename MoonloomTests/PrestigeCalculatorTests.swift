import XCTest
@testable import MoonloomApp

final class PrestigeCalculatorTests: XCTestCase {

    private let calculator = PrestigeCalculator()
    private let config = EconomyConfig()

    func testFirstThresholdIs25Percent() {
        XCTAssertEqual(calculator.threshold(resetCount: 0), 0.25, accuracy: 0.0001)
    }

    func testThresholdScalesByGrowthAndCaps() {
        // 0.25 * 1.5 = 0.375 for the second reset.
        XCTAssertEqual(calculator.threshold(resetCount: 1), 0.375, accuracy: 0.0001)
        // Eventually caps at 1.0.
        XCTAssertEqual(calculator.threshold(resetCount: 20), 1.0, accuracy: 0.0001)
    }

    func testCannotPrestigeBelowThreshold() {
        XCTAssertFalse(calculator.canPrestige(moonRestoration: 0.2, resetCount: 0))
        XCTAssertTrue(calculator.canPrestige(moonRestoration: 0.25, resetCount: 0))
    }

    func testShardsZeroWhenIneligible() {
        XCTAssertEqual(calculator.lucidShardsEarned(moonRestoration: 0.1, resetCount: 0), 0)
    }

    func testShardFormula() {
        // restoration 0.5, resetCount 0: 0.5 * 100 * (1 + 0) = 50.
        XCTAssertEqual(calculator.lucidShardsEarned(moonRestoration: 0.5, resetCount: 0), 50)
        // restoration 1.0, resetCount 0: 1.0 * 100 * 1 = 100.
        XCTAssertEqual(calculator.lucidShardsEarned(moonRestoration: 1.0, resetCount: 0), 100)
    }

    func testResetCountBonusApplied() {
        // resetCount 2 threshold = 0.25 * 1.5^2 = 0.5625, so use 0.6 restoration.
        // 0.6 * 100 * (1 + 2 * 0.1) = 72.
        XCTAssertTrue(calculator.canPrestige(moonRestoration: 0.6, resetCount: 2))
        XCTAssertEqual(calculator.lucidShardsEarned(moonRestoration: 0.6, resetCount: 2), 72)
    }
}
