import XCTest
@testable import MoonloomApp

@MainActor
final class EconomySimulationTests: XCTestCase {

    private let config = EconomyConfig()

    private func newGame() -> GameState {
        GameState(config: config, snapshot: .newGame(config: config, now: Date(timeIntervalSince1970: 0)))
    }

    func testInitialStateIsCorrect() {
        let state = newGame()
        XCTAssertEqual(state.amount(of: .moonlight), config.startingMoonlight, accuracy: 0.001)
        XCTAssertEqual(state.totalBuildingCount, 0)
        XCTAssertEqual(state.ordersFulfilled, 0)
        XCTAssertEqual(state.globalMultiplier, 1.0, accuracy: 0.0001)
    }

    func testSingleTickGeneratesMoonlight() throws {
        let state = newGame()
        let tier = try XCTUnwrap(config.tier(id: "whisper_net"))
        XCTAssertTrue(state.purchaseBuilding(tier))
        let before = state.amount(of: .moonlight)
        state.applyProduction(delta: 1.0)
        XCTAssertEqual(state.amount(of: .moonlight), before + 0.1, accuracy: 0.0001)
    }

    func testDeterministicTickSameInputSameOutput() {
        let a = newGame(); let b = newGame()
        for _ in 0..<100 { a.applyProduction(delta: 0.1) }
        for _ in 0..<100 { b.applyProduction(delta: 0.1) }
        XCTAssertEqual(a.amount(of: .moonlight), b.amount(of: .moonlight), accuracy: 0.0000001)
    }

    func testNoNaNOrInfinityDuringSimulation() throws {
        let state = newGame()
        let net = try XCTUnwrap(config.tier(id: "whisper_net"))
        state.credit(.moonlight, 10_000)
        for _ in 0..<5 { state.purchaseBuilding(net) }
        for _ in 0..<1_000 { state.applyProduction(delta: 0.1) }
        for resource in ResourceType.allCases {
            let value = state.amount(of: resource)
            XCTAssertTrue(value.isFinite, "\(resource) is not finite")
            XCTAssertGreaterThanOrEqual(value, 0)
        }
    }

    /// Acceptance: a simulated new game progresses through the first 3 tiers,
    /// unlocking each sequentially with Moonlight.
    func testProgressThroughFirstThreeTiers() throws {
        let state = newGame()
        let net = try XCTUnwrap(config.tier(id: "whisper_net"))
        let well = try XCTUnwrap(config.tier(id: "lullaby_well"))
        let spindle = try XCTUnwrap(config.tier(id: "dreamthread_spindle"))

        // Tier 1: already unlocked, affordable from the starting balance.
        XCTAssertTrue(state.purchaseBuilding(net))

        // Tier 2: unlock then buy (simulate accumulated Moonlight).
        state.credit(.moonlight, well.unlockCost + state.nextCost(for: well))
        XCTAssertTrue(state.unlockTier(well))
        XCTAssertTrue(state.purchaseBuilding(well))

        // Tier 3: unlock then buy.
        state.credit(.moonlight, spindle.unlockCost + state.nextCost(for: spindle))
        XCTAssertTrue(state.unlockTier(spindle))
        XCTAssertTrue(state.purchaseBuilding(spindle))

        XCTAssertGreaterThanOrEqual(state.count(of: "whisper_net"), 1)
        XCTAssertGreaterThanOrEqual(state.count(of: "lullaby_well"), 1)
        XCTAssertGreaterThanOrEqual(state.count(of: "dreamthread_spindle"), 1)

        let before = state.amount(of: .moonlight)
        state.applyProduction(delta: 1.0)
        XCTAssertGreaterThan(state.amount(of: .moonlight), before)
    }

    func testSnapshotRoundTripPreservesState() throws {
        let state = newGame()
        let net = try XCTUnwrap(config.tier(id: "whisper_net"))
        state.credit(.moonlight, 1_000_000)
        for _ in 0..<3 { state.purchaseBuilding(net) }
        XCTAssertTrue(state.upgradeBuilding(net))
        let order = try XCTUnwrap(state.activeOrder)
        XCTAssertTrue(state.fulfillOrder(order))

        let snapshot = state.snapshot(now: Date(timeIntervalSince1970: 50))
        let restored = GameState(config: config, snapshot: snapshot)

        XCTAssertEqual(restored.count(of: "whisper_net"), 3)
        XCTAssertEqual(restored.upgradeLevel(of: "whisper_net"), 1)
        XCTAssertEqual(restored.ordersFulfilled, 1)
    }
}
