import SwiftUI

/// The main idle screen: currency HUD, factory-wide output headline, the list of
/// unlocked production buildings, and a teaser for the next locked tier.
struct FactoryView: View {
    @EnvironmentObject private var gameState: GameState
    @EnvironmentObject private var container: AppContainer

    private var viewModel: FactoryViewModel { FactoryViewModel(gameState: gameState) }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.backgroundGradient.ignoresSafeArea()
                VStack(spacing: 0) {
                    CurrencyHUDView()
                    headline
                    buildingList
                }
            }
            .navigationTitle("Dream Factory")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }

    private var headline: some View {
        VStack(spacing: 2) {
            Text("Moonlight / second")
                .font(.caption)
                .foregroundStyle(Theme.textSecondary)
            HStack(spacing: 6) {
                Image(systemName: ResourceType.moonlight.systemImage)
                    .foregroundStyle(Theme.moonGold)
                Text(viewModel.moonlightPerSecondText)
                    .font(.system(.title2, design: .rounded).weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
                    .monospacedDigit()
            }
        }
        .padding(.bottom, 6)
    }

    private var buildingList: some View {
        ScrollView {
            LazyVStack(spacing: 4) {
                ForEach(viewModel.visibleTiers) { tier in
                    BuildingRowView(tier: tier)
                        .padding(.horizontal)
                    Divider().overlay(Theme.textSecondary.opacity(0.15))
                }

                if let locked = viewModel.nextLockedTier {
                    lockedTeaser(locked)
                        .padding()
                }
            }
            .padding(.vertical, 8)
        }
    }

    private func lockedTeaser(_ tier: ProductionTier) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "lock.fill")
                .foregroundStyle(Theme.textSecondary)
                .frame(width: 40, height: 40)
                .background(Circle().fill(Theme.deepBlue.opacity(0.4)))
            VStack(alignment: .leading, spacing: 2) {
                Text(tier.name)
                    .font(.headline)
                    .foregroundStyle(Theme.textSecondary)
                Text(viewModel.unlockHint(for: tier))
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)
            }
            Spacer()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Theme.deepBlue.opacity(0.25)))
    }
}
