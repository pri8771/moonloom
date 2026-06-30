import SwiftUI

/// A circular "moon" that fills with gold as restoration progresses (0...1).
struct MoonProgressView: View {
    let progress: Double

    private var clamped: Double { min(max(progress, 0), 1) }

    var body: some View {
        ZStack {
            Circle()
                .fill(Theme.deepBlue.opacity(0.5))
            Circle()
                .trim(from: 0, to: clamped)
                .stroke(Theme.moonGold, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.4), value: clamped)
            Image(systemName: "moon.stars.fill")
                .font(.system(size: 54))
                .foregroundStyle(Theme.moonGold.opacity(0.4 + 0.6 * clamped))
            VStack {
                Spacer()
                Text("\(Int((clamped * 100).rounded()))%")
                    .font(.system(.title3, design: .rounded).weight(.bold))
                    .foregroundStyle(Theme.textPrimary)
                    .padding(.bottom, 18)
            }
        }
        .frame(width: 180, height: 180)
        .accessibilityLabel("Moon restored \(Int((clamped * 100).rounded())) percent")
    }
}
