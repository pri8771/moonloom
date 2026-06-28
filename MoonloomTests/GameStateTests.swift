import XCTest
@testable import MoonloomApp

@MainActor
final class GameStateTests: XCTestCase {

    private func makeState() -> GameState {
        let config = EconomyConfig()
        return GameState(config: config, snapshot: .newGame(config: config, now: Date(timeIntervalSince1970: 0)))
    }

    func testNewGameStartsWithSeedMoonlight() {
        let state = makeState()
        XCTAssertEqual(state.amount(of: .moonlight), EconomyConfig().startingMoonlight, accuracy: 0.001)
    }

    func testFirstTierUnlockedByDefault() throws {
        let state = makeState()
        let first = try XCTUnwrap(state.config.tiers.first)
        XCTAssertTrue(state.isUnlocked(first))
        let second = try XCTUnwrap(state.config.tier(id: "lullaby_well"))
        XCTAssertFalse(state.isUnlocked(second))
    }

    func testPurchaseDeductsCostAndIncrementsCount() throws {
        let state = makeState()
        let tier = try XCTUnwrap(state.config.tier(id: "whisper_net"))
        let cost = state.nextCost(for: tier)
        XCTAssertTrue(state.purchaseBuilding(tier))
        XCTAssertEqual(state.count(of: tier.id), 1)
        XCTAssertEqual(state.amount(of: .moonlight), EconomyConfig().startingMoonlight - cost, accuracy: 0.001)
    }

    func testCannotPurchaseLockedTier() throws {
        let state = makeState()
        let tier = try XCTUnwrap(state.config.tier(id: "moonheart_engine"))
        state.credit(.moonlight, 1e20) // plenty of Moonlight, but it's locked
        XCTAssertFalse(state.purchaseBuilding(tier))
        XCTAssertEqual(state.count(of: tier.id), 0)
    }

    func testApplyProductionCreditsOutput() throws {
        let state = makeState()
        let tier = try XCTUnwrap(state.config.tier(id: "whisper_net"))
        XCTAssertTrue(state.purchaseBuilding(tier))
        let before = state.amount(of: .moonlight)
        state.applyProduction(delta: 10)
        // 1 net × 0.1/s × 10s = 1.0 Moonlight added.
        XCTAssertEqual(state.amount(of: .moonlight), before + 1.0, accuracy: 0.0001)
    }

    func testSecondPurchaseCostsMore() throws {
        let state = makeState()
        let tier = try XCTUnwrap(state.config.tier(id: "whisper_net"))
        let firstCost = state.nextCost(for: tier)
        XCTAssertTrue(state.purchaseBuilding(tier))
        XCTAssertGreaterThan(state.nextCost(for: tier), firstCost)
    }

    func testSequentialTierUnlock() throws {
        let state = makeState()
        let well = try XCTUnwrap(state.config.tier(id: "lullaby_well"))
        let spindle = try XCTUnwrap(state.config.tier(id: "dreamthread_spindle"))

        // Spindle can't be unlocked before the well (no skipping).
        state.credit(.moonlight, 1e12)
        XCTAssertFalse(state.canUnlockTier(spindle))
        XCTAssertTrue(state.canUnlockTier(well))
        XCTAssertTrue(state.unlockTier(well))
        XCTAssertTrue(state.isUnlocked(well))
        // Now the spindle becomes unlockable.
        XCTAssertTrue(state.canUnlockTier(spindle))
    }

    func testUnlockSpendsMoonlight() throws {
        let state = makeState()
        let well = try XCTUnwrap(state.config.tier(id: "lullaby_well"))
        state.credit(.moonlight, well.unlockCost)
        let before = state.amount(of: .moonlight)
        XCTAssertTrue(state.unlockTier(well))
        XCTAssertEqual(state.amount(of: .moonlight), before - well.unlockCost, accuracy: 0.001)
    }

    func testPrestigeResetsRunButKeepsPremiumAndShards() {
        let state = makeState()
        state.credit(.moonlight, 5_000)
        state.credit(.stardust, 42)
        state.applyPrestige(shardsEarned: 50)

        XCTAssertEqual(state.amount(of: .moonlight), EconomyConfig().startingMoonlight, accuracy: 0.001)
        XCTAssertEqual(state.amount(of: .stardust), 42, accuracy: 0.001) // premium kept
        XCTAssertEqual(state.amount(of: .lucidShards), 50, accuracy: 0.001)
        XCTAssertEqual(state.totalLucidShardsEarned, 50, accuracy: 0.001)
        XCTAssertEqual(state.resetCount, 1)
        // Only the first tier remains unlocked.
        XCTAssertEqual(state.unlockedTierIDs, Set([state.config.tiers.first?.id].compactMap { $0 }))
    }

    func testSnapshotRoundTrip() throws {
        let state = makeState()
        state.credit(.moonlight, 1_234)
        let well = try XCTUnwrap(state.config.tier(id: "lullaby_well"))
        state.credit(.moonlight, well.unlockCost)
        XCTAssertTrue(state.unlockTier(well))

        let snapshot = state.snapshot(now: Date(timeIntervalSince1970: 100))
        let restored = GameState(config: EconomyConfig(), snapshot: snapshot)
        XCTAssertEqual(restored.amount(of: .moonlight), state.amount(of: .moonlight), accuracy: 0.001)
        XCTAssertTrue(restored.isUnlocked(well))
    }
}
