import XCTest
@testable import MoonloomApp

@MainActor
final class SettingsPersistenceTests: XCTestCase {

    private let config = EconomyConfig()

    private func newGame() -> GameState {
        GameState(config: config, snapshot: .newGame(config: config, now: Date(timeIntervalSince1970: 0)))
    }

    func testDefaultSettings() {
        let state = newGame()
        XCTAssertTrue(state.isMusicEnabled)
        XCTAssertTrue(state.isSFXEnabled)
        XCTAssertTrue(state.isNotificationsEnabled)
        XCTAssertEqual(state.offlineEarningCapHours, config.defaultOfflineCapHours)
        XCTAssertEqual(state.theme, "default")
    }

    func testSettingsSurviveSnapshotRoundTrip() {
        let state = newGame()
        state.isMusicEnabled = false
        state.isSFXEnabled = false
        state.isNotificationsEnabled = false
        state.theme = "ember"

        let snapshot = state.snapshot(now: Date(timeIntervalSince1970: 10))
        let restored = GameState(config: config, snapshot: snapshot)

        XCTAssertFalse(restored.isMusicEnabled)
        XCTAssertFalse(restored.isSFXEnabled)
        XCTAssertFalse(restored.isNotificationsEnabled)
        XCTAssertEqual(restored.theme, "ember")
    }

    func testOfflineCapClampedToValidRange() {
        let state = newGame()
        state.setOfflineCapHours(1)          // below default
        XCTAssertEqual(state.offlineEarningCapHours, config.defaultOfflineCapHours)
        state.setOfflineCapHours(999)        // above max
        XCTAssertEqual(state.offlineEarningCapHours, config.maxOfflineCapHours)
        state.setOfflineCapHours(config.expandedOfflineCapHours)
        XCTAssertEqual(state.offlineEarningCapHours, config.expandedOfflineCapHours)
    }
}

@MainActor
final class ProductionRateAccuracyTests: XCTestCase {

    private let config = EconomyConfig()

    private func makeState(buildings: [String: Int], moonlight: Double = 1e18, levels: [String: Int] = [:]) -> GameState {
        var snapshot = GameSnapshot.newGame(config: config, now: Date(timeIntervalSince1970: 0))
        snapshot.buildingCounts = buildings
        snapshot.upgradeLevels = levels
        snapshot.currencyAmounts = [ResourceType.moonlight.rawValue: moonlight]
        return GameState(config: config, snapshot: snapshot)
    }

    func testRateScalesLinearlyWithCount() throws {
        let tier = try XCTUnwrap(config.tier(id: "whisper_net"))
        XCTAssertEqual(makeState(buildings: ["whisper_net": 1]).outputPerSecond(forTier: tier), 0.1, accuracy: 0.0001)
        XCTAssertEqual(makeState(buildings: ["whisper_net": 5]).outputPerSecond(forTier: tier), 0.5, accuracy: 0.0001)
    }

    func testUpgradeLevelMultipliesRate() throws {
        let tier = try XCTUnwrap(config.tier(id: "whisper_net"))
        // 10 nets at level 2: 10 × 0.1 × 1.5^2 = 2.25.
        let state = makeState(buildings: ["whisper_net": 10], levels: ["whisper_net": 2])
        XCTAssertEqual(state.outputPerSecond(forTier: tier), 10 * 0.1 * 1.5 * 1.5, accuracy: 0.0001)
    }

    func testGlobalMultiplierAppliesToRate() throws {
        let tier = try XCTUnwrap(config.tier(id: "whisper_net"))
        let state = makeState(buildings: ["whisper_net": 10])
        let base = state.outputPerSecond(forTier: tier)
        state.setGlobalMultiplier(2.0)
        XCTAssertEqual(state.outputPerSecond(forTier: tier), base * 2.0, accuracy: 0.0001)
    }

    func testAggregateMoonlightRate() {
        let state = makeState(buildings: ["whisper_net": 5])
        XCTAssertEqual(state.outputPerSecond(of: .moonlight), 0.5, accuracy: 0.0001)
    }
}
