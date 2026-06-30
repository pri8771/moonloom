import Foundation

/// Persistence boundary for the whole game state. Implementations map between
/// `GameSnapshot` (a `Sendable` value) and the underlying store, so callers
/// never touch `@Model` objects across actor boundaries.
protocol GameStateRepository: Sendable {
    /// Load the saved snapshot, or `nil` if there is no save yet.
    func load() async -> GameSnapshot?
    /// Persist the given snapshot (upsert).
    func save(_ snapshot: GameSnapshot) async
    /// Delete all saved data (used by "reset progress").
    func deleteAll() async
}
