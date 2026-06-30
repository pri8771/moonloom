import Foundation

/// A purchasable item in the shop. Mirrors the StoreKit product catalog defined
/// in `TECHNICAL_PRD.md` §7 and `MONETIZATION_PRD.md`.
struct ShopItem: Identifiable, Sendable, Hashable {
    enum Kind: String, Sendable {
        case factoryTheme = "Factory Theme"
        case mothSkin = "Moth Skin"
        case stardust = "Stardust Bundle"
        case subscription = "Subscription"
        case offlineExpansion = "Offline Expansion"
    }

    /// StoreKit product identifier.
    let id: String
    let title: String
    let detail: String
    let displayPrice: String
    let systemImage: String
    let kind: Kind
}

/// The static shop catalog. Prices shown here are the planned tier prices; the
/// authoritative prices come from StoreKit once integration lands.
enum ShopCatalog {
    static let items: [ShopItem] = [
        ShopItem(id: "com.moonloom.dream_pack_celestial",
                 title: "Celestial Theme", detail: "Recolor your factory in cool starlight.",
                 displayPrice: "$2.99", systemImage: "sparkles", kind: .factoryTheme),
        ShopItem(id: "com.moonloom.dream_pack_ember",
                 title: "Ember Theme", detail: "Warm, glowing factory aesthetic.",
                 displayPrice: "$2.99", systemImage: "flame.fill", kind: .factoryTheme),
        ShopItem(id: "com.moonloom.moth_skin_golden",
                 title: "Golden Moth", detail: "Give your couriers golden wings.",
                 displayPrice: "$1.99", systemImage: "ant.fill", kind: .mothSkin),
        ShopItem(id: "com.moonloom.moth_skin_shadow",
                 title: "Shadow Moth", detail: "Sleek shadow-winged couriers.",
                 displayPrice: "$1.99", systemImage: "ant.fill", kind: .mothSkin),
        ShopItem(id: "com.moonloom.stardust_small",
                 title: "50 Stardust", detail: "A small pouch of premium currency.",
                 displayPrice: "$0.99", systemImage: "sparkle", kind: .stardust),
        ShopItem(id: "com.moonloom.stardust_medium",
                 title: "175 Stardust", detail: "A generous handful of Stardust.",
                 displayPrice: "$2.99", systemImage: "sparkle", kind: .stardust),
        ShopItem(id: "com.moonloom.stardust_large",
                 title: "500 Stardust", detail: "A glittering trove of Stardust.",
                 displayPrice: "$7.99", systemImage: "sparkle", kind: .stardust),
        ShopItem(id: "com.moonloom.pass_monthly",
                 title: "Moonloom Pass", detail: "2× offline earnings + exclusive cosmetics.",
                 displayPrice: "$4.99/mo", systemImage: "crown.fill", kind: .subscription),
        ShopItem(id: "com.moonloom.offline_expansion",
                 title: "Offline Expansion", detail: "Raise the offline cap from 2h to 12h.",
                 displayPrice: "$3.99", systemImage: "clock.badge.checkmark", kind: .offlineExpansion)
    ]
}
