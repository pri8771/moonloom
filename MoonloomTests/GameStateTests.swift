import XCTest
@testable import MoonloomApp

@MainActor
final class GameStateTests: XCTestCase {

    private func makeState() -> GameState {
        let config = EconomyConfig()
        return GameState(config: config, snapshot: .newGame(config: config, now: Date(timeIntervalSince1970: 0)))
    }

    func testNewGameStartsWithSeedWhispers() {
        let state = makeState()
        XCTAssertEqual(state.amount(of: .whispers), EconomyConfig().startingWhispers, accuracy: 0.001)
    }

    func testPurchaseDeductsCostAndIncrementsCount() throws {
        let state = makeState()
        let tier = try XCTUnwrap(state.config.tier(id: "whisper_net"))
        let cost = state.nextCost(for: tier)
        XCTAssertTrue(state.purchaseBuilding(tier))
        XCTAssertEqual(state.count(of: tier.id), 1)
        XCTAssertEqual(state.amount(of: .whispers), EconomyConfig().startingWhispers - cost, accuracy: 0.001)
    }

    func testCannotPurchaseWhenUnaffordable() throws {
        let state = makeState()
        let tier = try XCTUnwrap(state.config.tier(id: "moonheart_engine"))
        XCTAssertFalse(state.purchaseBuilding(tier))
        XCTAssertEqual(state.count(of: tier.id), 0)
    }

    func testApplyProductionCreditsOutput() throws {
        let state = makeState()
        let tier = try XCTUnwrap(state.config.tier(id: "whisper_net"))
        XCTAssertTrue(state.purchaseBuilding(tier))
        let before = state.amount(of: .whispers)
        state.applyProduction(delta: 10)
        // 1 net * 0.1/s * 10s = 1.0 whispers added.
        XCTAssertEqual(state.amount(of: .whispers), before + 1.0, accuracy: 0.0001)
    }

    func testSecondPurchaseCostsMore() throws {
        let state = makeState()
        let tier = try XCTUnwrap(state.config.tier(id: "whisper_net"))
        let firstCost = state.nextCost(for: tier)
        XCTAssertTrue(state.purchaseBuilding(tier))
        let secondCost = state.nextCost(for: tier)
        XCTAssertGreaterThan(secondCost, firstCost)
    }

    func testPrestigeResetsSoftCurrenciesButKeepsShards() {
        let state = makeState()
        state.credit(.dreamthread, 5_000)
        state.credit(.stardust, 42)
        state.applyPrestige(shardsEarned: 50)

        XCTAssertEqual(state.amount(of: .dreamthread), 0, accuracy: 0.001)
        XCTAssertEqual(state.amount(of: .whispers), EconomyConfig().startingWhispers, accuracy: 0.001)
        XCTAssertEqual(state.amount(of: .stardust), 42, accuracy: 0.001) // premium kept
        XCTAssertEqual(state.amount(of: .lucidShards), 50, accuracy: 0.001)
        XCTAssertEqual(state.totalLucidShardsEarned, 50, accuracy: 0.001)
        XCTAssertEqual(state.resetCount, 1)
        XCTAssertEqual(state.moonRestoration, 0, accuracy: 0.001)
    }

    func testSnapshotRoundTrip() {
        let state = makeState()
        state.credit(.moonlight, 1_234)
        let snapshot = state.snapshot(now: Date(timeIntervalSince1970: 100))

        let restored = GameState(config: EconomyConfig(), snapshot: snapshot)
        XCTAssertEqual(restored.amount(of: .moonlight), 1_234, accuracy: 0.001)
    }

    func testTierUnlockProgression() throws {
        let state = makeState()
        let tier2 = try XCTUnwrap(state.config.tier(id: "lullaby_well"))
        XCTAssertFalse(state.isUnlocked(tier2)) // needs 1 whisper_net
        let tier1 = try XCTUnwrap(state.config.tier(id: "whisper_net"))
        XCTAssertTrue(state.purchaseBuilding(tier1))
        XCTAssertTrue(state.isUnlocked(tier2))
    }
}
