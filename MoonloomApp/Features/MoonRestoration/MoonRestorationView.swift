import SwiftUI

/// Moon Restoration / Story screen. Shows restoration progress, a short story
/// beat, and the New Moon Reset (prestige) entry point.
///
/// The narrative copy here is an intentional, clearly-scoped placeholder: a
/// single rotating story beat keyed to restoration progress. The full
/// biome-by-biome story sequence is a later phase (PROJECT_TRACKER E007 /
/// asset work E009); this screen is functional and safe in the meantime.
struct MoonRestorationView: View {
    @EnvironmentObject private var gameState: GameState
    @EnvironmentObject private var container: AppContainer

    @State private var showPrestigeConfirm = false
    private let formatter = NumberAbbreviator()

    private var threshold: Double {
        container.prestigeCalculator.threshold(resetCount: gameState.resetCount)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.backgroundGradient.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 24) {
                        MoonProgressView(progress: gameState.moonRestoration)
                            .padding(.top, 12)

                        storyBeat
                        prestigePanel
                    }
                    .padding()
                }
            }
            .navigationTitle("Moon Restoration")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .confirmationDialog(
                "Trigger a New Moon Reset?",
                isPresented: $showPrestigeConfirm,
                titleVisibility: .visible
            ) {
                Button("Reset for \(formatter.string(from: container.projectedShards)) Lucid Shards", role: .destructive) {
                    Task { await container.performPrestige() }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Your factory and soft currencies reset. You keep Stardust, Lucid Shards, and permanent upgrades.")
            }
        }
    }

    private var storyBeat: some View {
        Text(storyText(for: gameState.moonRestoration))
            .font(.callout)
            .italic()
            .multilineTextAlignment(.center)
            .foregroundStyle(Theme.textSecondary)
            .padding()
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 16).fill(Theme.deepBlue.opacity(0.35)))
    }

    private var prestigePanel: some View {
        VStack(spacing: 12) {
            Label("New Moon Reset", systemImage: "moonphase.new.moon")
                .font(.headline)
                .foregroundStyle(Theme.textPrimary)

            statRow("Lucid Shards earned so far",
                    value: formatter.string(from: gameState.totalLucidShardsEarned))
            statRow("Resets completed", value: "\(gameState.resetCount)")
            statRow("Restoration needed", value: "\(Int((threshold * 100).rounded()))%")

            if container.canPrestige {
                Text("Reset now to gain \(formatter.string(from: container.projectedShards)) Lucid Shards.")
                    .font(.caption)
                    .foregroundStyle(Theme.moonGold)
                    .multilineTextAlignment(.center)
            } else {
                Text("Restore the moon to \(Int((threshold * 100).rounded()))% to unlock your next reset.")
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)
                    .multilineTextAlignment(.center)
            }

            Button {
                showPrestigeConfirm = true
            } label: {
                Text("New Moon Reset")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(container.canPrestige ? Theme.moonGold : Theme.deepBlue.opacity(0.5))
                    )
                    .foregroundStyle(container.canPrestige ? Theme.midnight : Theme.textSecondary)
            }
            .buttonStyle(.plain)
            .disabled(!container.canPrestige)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 16).fill(Theme.deepBlue.opacity(0.35)))
    }

    private func statRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(Theme.textSecondary)
            Spacer()
            Text(value)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Theme.textPrimary)
                .monospacedDigit()
        }
    }

    private func storyText(for progress: Double) -> String {
        switch progress {
        case ..<0.01:
            return "The moon hangs dark and silent. Your first whispers stir in the sleeping towns below."
        case ..<0.25:
            return "Faint light returns to the moon's edge. The moths grow bolder with every dream you weave."
        case ..<0.6:
            return "Whole craters glow again. Sleepers below dream of silver light they cannot name."
        case ..<1.0:
            return "The moon is nearly whole. One more push and the night will remember how to shine."
        default:
            return "The moon blazes full and bright. A New Moon Reset will let you begin again — stronger."
        }
    }
}
