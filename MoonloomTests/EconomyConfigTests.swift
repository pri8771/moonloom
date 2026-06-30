import XCTest
@testable import MoonloomApp

final class EconomyConfigTests: XCTestCase {

    private let config = EconomyConfig()

    func testHasTwelveTiers() {
        XCTAssertEqual(config.tiers.count, 12)
    }

    func testTierNumbersAreSequential() {
        XCTAssertEqual(config.tiers.map(\.tier), Array(1...12))
    }

    func testTierIDsAreUnique() {
        let ids = Set(config.tiers.map(\.id))
        XCTAssertEqual(ids.count, config.tiers.count)
    }

    func testFirstTierIsAlwaysUnlocked() {
        let first = config.tiers[0]
        XCTAssertEqual(first.unlockRequirement, 0)
    }

    func testExponentialCostFormula() {
        guard let tier = config.tier(id: "whisper_net") else {
            return XCTFail("whisper_net tier missing")
        }
        XCTAssertEqual(tier.cost(forOwnedCount: 0), tier.baseCost, accuracy: 0.0001)
        // cost(1) = baseCost * 1.15.
        XCTAssertEqual(tier.cost(forOwnedCount: 1), tier.baseCost * 1.15, accuracy: 0.0001)
        // cost(10) = baseCost * 1.15^10.
        XCTAssertEqual(tier.cost(forOwnedCount: 10), tier.baseCost * pow(1.15, 10), accuracy: 0.001)
    }

    func testTierLookupMissingReturnsNil() {
        XCTAssertNil(config.tier(id: "does_not_exist"))
    }

    func testPrestigeThresholdCaps() {
        XCTAssertLessThanOrEqual(config.prestigeThreshold(forResetCount: 100), 1.0)
    }
}
