import Foundation

/// Abstraction over "the current time" so offline-earnings and engine logic can
/// be driven deterministically in tests. Production uses `SystemTimeProvider`.
protocol TimeProvider: Sendable {
    func now() -> Date
}

/// Real wall-clock time provider.
struct SystemTimeProvider: TimeProvider {
    func now() -> Date { Date() }
}

/// Test/preview provider that returns a fixed, externally-advanceable time.
/// Marked `final` + lock-guarded so it is `Sendable` across actors in tests.
final class MutableTimeProvider: TimeProvider, @unchecked Sendable {
    private let lock = NSLock()
    private var current: Date

    init(_ start: Date) { self.current = start }

    func now() -> Date {
        lock.lock(); defer { lock.unlock() }
        return current
    }

    func advance(by interval: TimeInterval) {
        lock.lock(); defer { lock.unlock() }
        current = current.addingTimeInterval(interval)
    }

    func set(_ date: Date) {
        lock.lock(); defer { lock.unlock() }
        current = date
    }
}
