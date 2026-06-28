import Foundation

/// Drives the idle simulation forward on a fixed cadence.
///
/// The engine is an `actor` so its timer state is isolated from the rest of the
/// app. Each tick it computes the elapsed wall-clock time since the previous
/// tick (using an injected `TimeProvider`, never a cumulative counter — this
/// avoids the timer-drift risk RISK-001 and the resume double-tick RISK-002 in
/// `BUG_TRACKER.md`) and hands that delta to a main-actor sink that applies
/// production to `GameState`.
///
/// Simulation math itself lives in `GameState`/use cases; the engine only owns
/// scheduling.
actor ProductionEngine {

    private let tickInterval: TimeInterval
    private let timeProvider: TimeProvider
    /// Main-actor sink that advances the simulation by `delta` seconds.
    private let apply: @MainActor @Sendable (TimeInterval) -> Void

    private var task: Task<Void, Never>?
    private var lastTick: Date?

    init(
        tickInterval: TimeInterval,
        timeProvider: TimeProvider,
        apply: @escaping @MainActor @Sendable (TimeInterval) -> Void
    ) {
        self.tickInterval = max(0.01, tickInterval)
        self.timeProvider = timeProvider
        self.apply = apply
    }

    /// Begin ticking. Safe to call repeatedly; a running loop is reused.
    func start() {
        guard task == nil else { return }
        lastTick = timeProvider.now()
        let nanos = UInt64(tickInterval * 1_000_000_000)
        task = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: nanos)
                await self?.tick()
            }
        }
    }

    /// Stop ticking and forget the timing baseline. Call before mutating state
    /// in ways that must not race the loop (e.g. prestige reset — RISK-008).
    func stop() {
        task?.cancel()
        task = nil
        lastTick = nil
    }

    /// Reset the timing baseline to "now" without producing a delta. Use after
    /// the app returns from the background once offline earnings are credited,
    /// so the next tick doesn't double-count the gap.
    func resetBaseline() {
        lastTick = timeProvider.now()
    }

    private func tick() async {
        let now = timeProvider.now()
        let previous = lastTick ?? now
        let delta = now.timeIntervalSince(previous)
        lastTick = now
        // Ignore non-positive or absurd deltas (clock changes, backgrounding);
        // large gaps are handled by the offline-earnings path, not the tick.
        guard delta > 0, delta < 5 else { return }
        await apply(delta)
    }
}
