import XCTest
@testable import MoonloomApp

/// Verifies the economy is internally consistent and safe from overflow
/// (MOONLOOM-PROMPT-004 "Economy Balance Pass").
final class EconomyBalanceTests: XCTestCase {

    private let config = EconomyConfig()

    func testTwelveTiersInOrder() {
        XCTAssertEqual(config.tiers.count, 12)
        XCTAssertEqual(config.tiers.map(\.tier), Array(1...12))
    }

    func testNoBuildingHasZeroBaseProduction() {
        for tier in config.tiers {
            XCTAssertGreaterThan(tier.baseOutputPerSecond, 0, "\(tier.id) has 0 base production")
        }
    }

    func testEveryBuildingProducesMoonlight() {
        for tier in config.tiers {
            XCTAssertEqual(tier.produces, .moonlight, "\(tier.id) does not produce Moonlight")
        }
    }

    func testBaseRatesAreStrictlyIncreasing() {
        let rates = config.tiers.map(\.baseOutputPerSecond)
        for (a, b) in zip(rates, rates.dropFirst()) {
            XCTAssertLessThan(a, b, "base rates must increase by tier")
        }
    }

    func testFirstTierIsFreeAndOthersCostMoonlight() throws {
        let first = try XCTUnwrap(config.tiers.first)
        XCTAssertEqual(first.unlockCost, 0)
        for tier in config.tiers.dropFirst() {
            XCTAssertGreaterThan(tier.unlockCost, 0, "\(tier.id) should have a positive unlock cost")
            XCTAssertEqual(tier.costCurrency, .moonlight)
        }
    }

    func testUnlockAndBuyCostsAreIncreasing() {
        let unlock = config.tiers.map(\.unlockCost)
        for (a, b) in zip(unlock, unlock.dropFirst()) { XCTAssertLessThan(a, b) }
        let buy = config.tiers.map(\.baseCost)
        for (a, b) in zip(buy, buy.dropFirst()) { XCTAssertLessThan(a, b) }
    }

    func testUpgradeCostsDoNotOverflowAtMaxLevel() {
        for tier in config.tiers {
            // Cost to reach (and one beyond) the max level must stay finite and sane.
            let cost = tier.upgradeCost(forLevel: config.maxUpgradeLevel, growth: config.upgradeCostGrowth)
            XCTAssertTrue(cost.isFinite, "\(tier.id) upgrade cost overflowed")
            XCTAssertLessThan(cost, 1e18, "\(tier.id) upgrade cost unreasonably large")
            XCTAssertGreaterThan(cost, 0)
        }
    }

    func testMaxUpgradeMultiplierIsFinite() {
        let maxMultiplier = config.upgradeMultiplier(forLevel: config.maxUpgradeLevel)
        XCTAssertTrue(maxMultiplier.isFinite)
        // 1.5^10 ≈ 57.665.
        XCTAssertEqual(maxMultiplier, pow(1.5, 10), accuracy: 0.001)
    }

    func testMilestoneMultiplierNeverExceedsCap() {
        let calculator = MilestoneCalculator(config: config)
        for reached in [0, 1, 5, 10, 100, 10_000] {
            XCTAssertLessThanOrEqual(calculator.multiplier(reachedCount: reached), config.maxGlobalMultiplier)
        }
        XCTAssertEqual(config.maxGlobalMultiplier, 5.0, accuracy: 0.0001)
    }

    func testTierIDsAreUnique() {
        XCTAssertEqual(Set(config.tiers.map(\.id)).count, config.tiers.count)
    }
}
