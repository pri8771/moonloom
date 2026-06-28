import SwiftUI

/// Centralised colours and gradients for Moonloom's moon/night/dream aesthetic
/// (deep midnight blues, soft golds — see `NON_TECHNICAL_PRD.md` "Beautiful
/// Design"). Kept simple for the foundation; richer theming/cosmetics arrive in
/// a later phase.
enum Theme {
    static let midnight = Color(red: 0.05, green: 0.06, blue: 0.16)
    static let deepBlue = Color(red: 0.10, green: 0.13, blue: 0.30)
    static let moonGold = Color(red: 0.98, green: 0.85, blue: 0.55)
    static let softViolet = Color(red: 0.45, green: 0.40, blue: 0.75)
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.7)

    static var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [midnight, deepBlue],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
