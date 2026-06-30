import SwiftUI

/// "Welcome back!" modal summarising offline earnings (TECHNICAL_PRD §5).
struct OfflineWelcomeView: View {
    let result: OfflineEarningsCalculator.Result
    let onDismiss: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var revealed = false

    private let formatter = NumberAbbreviator()

    /// Total Moonlight earned (the headline figure).
    private var totalMoonlight: Double {
        result.earnings[.moonlight] ?? 0
    }

    /// Per-building breakdown, capped to the top entries for a tidy modal.
    private var breakdownRows: [OfflineEarningsCalculator.TierEarning] {
        Array(result.perTier.prefix(8))
    }

    var body: some View {
        ZStack {
            Theme.backgroundGradient.ignoresSafeArea()
            VStack(spacing: 20) {
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(Theme.moonGold)
                    .scaleEffect(revealed || reduceMotion ? 1 : 0.5)
                    .opacity(revealed || reduceMotion ? 1 : 0)
                Text("Welcome back!")
                    .font(.system(.title, design: .rounded).weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
                Text("Your moth couriers were busy for \(elapsedText) while you were away\(result.capApplied ? " (capped)" : "").")
                    .font(.callout)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Theme.textSecondary)

                totalEarned

                if let top = result.mostProductiveTier {
                    Label("Top earner: \(top.tierName)", systemImage: "star.fill")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Theme.moonGold)
                }

                if !breakdownRows.isEmpty {
                    VStack(spacing: 8) {
                        ForEach(Array(breakdownRows.enumerated()), id: \.element.id) { index, entry in
                            HStack {
                                Text(entry.tierName)
                                    .font(.subheadline)
                                    .foregroundStyle(Theme.textPrimary)
                                Spacer()
                                Text("+\(formatter.string(from: entry.amount))")
                                    .font(.subheadline.weight(.bold))
                                    .foregroundStyle(Theme.moonGold)
                                    .monospacedDigit()
                            }
                            .opacity(revealed || reduceMotion ? 1 : 0)
                            .offset(y: revealed || reduceMotion ? 0 : 12)
                            .animation(reduceMotion ? nil
                                       : .spring(response: 0.4, dampingFraction: 0.8).delay(0.1 * Double(index) + 0.2),
                                       value: revealed)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 16).fill(Theme.deepBlue.opacity(0.5)))
                }

                Button(action: onDismiss) {
                    Text("Collect")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(RoundedRectangle(cornerRadius: 14).fill(Theme.moonGold))
                        .foregroundStyle(Theme.midnight)
                }
                .buttonStyle(.plain)
            }
            .padding(28)
        }
        .onAppear {
            if reduceMotion {
                revealed = true
            } else {
                withAnimation(.spring(response: 0.45, dampingFraction: 0.7)) { revealed = true }
            }
        }
    }

    private var totalEarned: some View {
        HStack(spacing: 6) {
            Image(systemName: ResourceType.moonlight.systemImage)
                .foregroundStyle(Theme.moonGold)
            Text("+\(formatter.string(from: totalMoonlight)) Moonlight")
                .font(.system(.title3, design: .rounded).weight(.bold))
                .foregroundStyle(Theme.textPrimary)
                .monospacedDigit()
        }
    }

    private var elapsedText: String {
        OfflineDurationFormatter.string(from: result.creditedSeconds)
    }
}

/// Formats an elapsed offline duration like "2h 5m" or "45m".
enum OfflineDurationFormatter {
    static func string(from seconds: TimeInterval) -> String {
        let total = Int(seconds.rounded())
        let hours = total / 3_600
        let minutes = (total % 3_600) / 60
        if hours > 0 && minutes > 0 { return "\(hours)h \(minutes)m" }
        if hours > 0 { return "\(hours)h" }
        if minutes > 0 { return "\(minutes)m" }
        return "\(total)s"
    }
}
