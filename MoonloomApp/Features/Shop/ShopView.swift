import SwiftUI

/// Cosmetics & convenience shop.
///
/// **Foundation state:** the catalog is real (matches the StoreKit product IDs),
/// but live purchasing is intentionally deferred to the monetization phase
/// (PROJECT_TRACKER E008). Purchase buttons are disabled and a banner makes the
/// status explicit, so nothing here is a misleading no-op.
struct ShopView: View {
    private let items = ShopCatalog.items

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.backgroundGradient.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 12) {
                        comingSoonBanner
                        ForEach(items) { item in
                            row(for: item)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Shop")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }

    private var comingSoonBanner: some View {
        Label("In-app purchases arrive in a later update. No purchases are charged yet.",
              systemImage: "info.circle")
            .font(.caption)
            .foregroundStyle(Theme.textSecondary)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 12).fill(Theme.deepBlue.opacity(0.35)))
    }

    private func row(for item: ShopItem) -> some View {
        HStack(spacing: 12) {
            Image(systemName: item.systemImage)
                .font(.title2)
                .foregroundStyle(Theme.moonGold)
                .frame(width: 40, height: 40)
                .background(Circle().fill(Theme.deepBlue.opacity(0.7)))
            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.headline)
                    .foregroundStyle(Theme.textPrimary)
                Text(item.detail)
                    .font(.caption)
                    .foregroundStyle(Theme.textSecondary)
                Text(item.kind.rawValue)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(Theme.softViolet)
            }
            Spacer(minLength: 8)
            Text(item.displayPrice)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(Theme.textSecondary)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(RoundedRectangle(cornerRadius: 12).fill(Theme.deepBlue.opacity(0.5)))
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 14).fill(Theme.deepBlue.opacity(0.25)))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(item.title), \(item.displayPrice), coming soon")
    }
}
