import XCTest
@testable import MoonloomApp

final class SwiftDataGameStateRepositoryTests: XCTestCase {

    func testSaveLoadRoundTripPersistsSnapshot() async throws {
        let config = EconomyConfig()
        let repository = SwiftDataGameStateRepository(
            modelContainer: AppDatabase.makeContainer(inMemory: true)
        )
        var snapshot = GameSnapshot.newGame(
            config: config,
            now: Date(timeIntervalSince1970: 100)
        )
        snapshot.currencyAmounts[ResourceType.moonlight.rawValue] = 321
        snapshot.currencyLifetimeEarned[ResourceType.moonlight.rawValue] = 999
        snapshot.buildingCounts["whisper_net"] = 3
        snapshot.upgradeLevels["whisper_net"] = 2
        snapshot.ordersFulfilled = 4
        snapshot.restoredNodeIDs = ["crater_gardens"]
        snapshot.resetCount = 1
        snapshot.totalLucidShardsEarned = 12
        snapshot.theme = "ember"

        try await repository.save(snapshot)

        let loadedSnapshot = try await repository.load()
        let loaded = try XCTUnwrap(loadedSnapshot)
        XCTAssertEqual(loaded.currencyAmounts[ResourceType.moonlight.rawValue], 321)
        XCTAssertEqual(loaded.currencyLifetimeEarned[ResourceType.moonlight.rawValue], 999)
        XCTAssertEqual(loaded.buildingCounts["whisper_net"], 3)
        XCTAssertEqual(loaded.upgradeLevels["whisper_net"], 2)
        XCTAssertEqual(loaded.ordersFulfilled, 4)
        XCTAssertEqual(loaded.restoredNodeIDs, ["crater_gardens"])
        XCTAssertEqual(loaded.resetCount, 1)
        XCTAssertEqual(loaded.totalLucidShardsEarned, 12)
        XCTAssertEqual(loaded.theme, "ember")
    }

    func testDeleteAllRemovesSavedSnapshot() async throws {
        let config = EconomyConfig()
        let repository = SwiftDataGameStateRepository(
            modelContainer: AppDatabase.makeContainer(inMemory: true)
        )
        let snapshot = GameSnapshot.newGame(
            config: config,
            now: Date(timeIntervalSince1970: 100)
        )

        try await repository.save(snapshot)
        let savedSnapshot = try await repository.load()
        XCTAssertNotNil(savedSnapshot)

        try await repository.deleteAll()

        let loaded = try await repository.load()
        XCTAssertNil(loaded)
    }
}
