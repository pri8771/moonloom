import XCTest
@testable import MoonloomApp

@MainActor
final class UpgradeLevelTests: XCTestCase {

    private let config = EconomyConfig()

    /// A state with the first tier unlocked and a generous Moonlight balance.
    private func makeState(moonlight: Double) -> GameState {
        var snapshot = GameSnapshot.newGame(config: config, now: Date(timeIntervalSince1970: 0))
        snapshot.currencyAmounts = [ResourceType.moonlight.rawValue: moonlight]
        snapshot.buildingCounts = ["whisper_net": 1]
        return GameState(config: config, snapshot: snapshot)
    }

    func testUpgradeCostFollowsCurve() throws {
        let tier = try XCTUnwrap(config.tier(id: "whisper_net"))
        let state = makeState(moonlight: 1_000_000)
        // Level 0 → 1 costs baseUpgradeCost (50).
        XCTAssertEqual(state.upgradeCost(for: tier), tier.baseUpgradeCost, accuracy: 0.001)
        XCTAssertTrue(state.upgradeBuilding(tier))
        // Level 1 → 2 costs baseUpgradeCost × 1.8.
        XCTAssertEqual(state.upgradeCost(for: tier), tier.baseUpgradeCost * 1.8, accuracy: 0.001)
    }

    func testUpgradeMultipliesOutputBy1Point5PerLevel() throws {
        let tier = try XCTUnwrap(config.tier(id: "whisper_net"))
        let state = makeState(moonlight: 1_000_000)
        let base = state.outputPerSecond(forTier: tier)   // level 0
        XCTAssertTrue(state.upgradeBuilding(tier))         // level 1
        XCTAssertEqual(state.buildingMultiplier(for: "whisper_net"), 1.5, accuracy: 0.0001)
        XCTAssertEqual(state.outputPerSecond(forTier: tier), base * 1.5, accuracy: 0.0001)
        XCTAssertTrue(state.upgradeBuilding(tier))         // level 2
        XCTAssertEqual(state.outputPerSecond(forTier: tier), base * 1.5 * 1.5, accuracy: 0.0001)
    }

    func testCannotUpgradeBeyondMaxLevel() throws {
        let tier = try XCTUnwrap(config.tier(id: "whisper_net"))
        let state = makeState(moonlight: 1e18)
        for _ in 0..<config.maxUpgradeLevel { XCTAssertTrue(state.upgradeBuilding(tier)) }
        XCTAssertEqual(state.upgradeLevel(of: "whisper_net"), config.maxUpgradeLevel)
        XCTAssertTrue(state.isMaxLevel(tier))
        XCTAssertFalse(state.canUpgrade(tier))
        XCTAssertFalse(state.upgradeBuilding(tier))
    }

    func testCannotUpgradeLockedTier() throws {
        let tier = try XCTUnwrap(config.tier(id: "lullaby_well"))
        let state = makeState(moonlight: 1e18) // well is locked
        XCTAssertFalse(state.canUpgrade(tier))
        XCTAssertFalse(state.upgradeBuilding(tier))
    }
}

final class MilestoneCalculatorTests: XCTestCase {

    private let calculator = MilestoneCalculator()
    private let config = EconomyConfig()

    func testNoMilestonesAtZeroMoonlight() {
        XCTAssertEqual(calculator.reachedCount(lifetimeMoonlight: 0), 0)
        XCTAssertEqual(calculator.multiplier(lifetimeMoonlight: 0), 1.0, accuracy: 0.0001)
    }

    func testThresholdsReached() {
        XCTAssertEqual(calculator.reachedCount(lifetimeMoonlight: 999), 0)
        XCTAssertEqual(calculator.reachedCount(lifetimeMoonlight: 1_000), 1)
        XCTAssertEqual(calculator.reachedCount(lifetimeMoonlight: 50_000), 2) // ≥1K, ≥10K
        XCTAssertEqual(calculator.reachedCount(lifetimeMoonlight: 1_000_000), 4)
    }

    func testMultiplierIsTenPercentPerMilestone() {
        XCTAssertEqual(calculator.multiplier(reachedCount: 1), 1.10, accuracy: 0.0001)
        XCTAssertEqual(calculator.multiplier(reachedCount: 3), 1.30, accuracy: 0.0001)
    }

    func testMultiplierClampedToSafetyCap() {
        // 100 milestones would be ×11 without the cap.
        XCTAssertEqual(calculator.multiplier(reachedCount: 100), config.maxGlobalMultiplier, accuracy: 0.0001)
        XCTAssertLessThanOrEqual(calculator.multiplier(lifetimeMoonlight: 1e30), 5.0)
    }
}
