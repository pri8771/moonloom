import Foundation

/// The five currencies tracked by Moonloom.
///
/// Three are *soft* currencies earned through production (`whispers`,
/// `dreamthread`, `moonlight`), one is a *premium soft* currency
/// (`stardust`), and one is the *prestige* currency (`lucidShards`) earned
/// on a New Moon Reset. See `TECHNICAL_PRD.md` §3 and the README currency table.
enum ResourceType: String, CaseIterable, Codable, Sendable, Identifiable {
    case whispers
    case dreamthread
    case moonlight
    case stardust
    case lucidShards

    var id: String { rawValue }

    /// Human-readable name shown in the UI.
    var displayName: String {
        switch self {
        case .whispers: return "Whispers"
        case .dreamthread: return "Dreamthread"
        case .moonlight: return "Moonlight"
        case .stardust: return "Stardust"
        case .lucidShards: return "Lucid Shards"
        }
    }

    /// SF Symbol used as the currency's glyph.
    var systemImage: String {
        switch self {
        case .whispers: return "wind"
        case .dreamthread: return "scribble.variable"
        case .moonlight: return "moon.stars.fill"
        case .stardust: return "sparkles"
        case .lucidShards: return "moonphase.new.moon"
        }
    }

    /// Soft currencies are reset on a New Moon Reset; premium and prestige
    /// currencies persist across resets. See `TECHNICAL_PRD.md` §6.
    var isSoftCurrency: Bool {
        switch self {
        case .whispers, .dreamthread, .moonlight: return true
        case .stardust, .lucidShards: return false
        }
    }
}
