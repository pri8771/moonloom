import Foundation
#if canImport(UIKit)
import UIKit
#endif

/// Lightweight wrapper around UIKit haptics. All calls are no-ops when haptics
/// are unavailable (e.g. on non-UIKit platforms or in unit tests), so callers
/// never need to guard. Respects the player's SFX setting via `isEnabled`.
@MainActor
final class HapticsService {

    /// Mirrors the player's "sound & haptics" preference. When `false`, all
    /// feedback is suppressed.
    var isEnabled: Bool = true

    enum Impact { case light, medium, heavy, soft, rigid }

    func impact(_ style: Impact) {
        guard isEnabled else { return }
        #if canImport(UIKit)
        let generator = UIImpactFeedbackGenerator(style: style.uiStyle)
        generator.impactOccurred()
        #endif
    }

    func success() {
        notify(.success)
    }

    func warning() {
        notify(.warning)
    }

    func error() {
        notify(.error)
    }

    #if canImport(UIKit)
    private func notify(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        guard isEnabled else { return }
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    #else
    private enum FeedbackType { case success, warning, error }
    private func notify(_ type: FeedbackType) { /* no-op off-device */ }
    #endif
}

#if canImport(UIKit)
private extension HapticsService.Impact {
    var uiStyle: UIImpactFeedbackGenerator.FeedbackStyle {
        switch self {
        case .light: return .light
        case .medium: return .medium
        case .heavy: return .heavy
        case .soft: return .soft
        case .rigid: return .rigid
        }
    }
}
#endif
