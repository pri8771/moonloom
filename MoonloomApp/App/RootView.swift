import SwiftUI

/// Root tab navigation. The four primary destinations defined for the
/// foundation: Factory, Moon Restoration, Shop, and Settings
/// (`MOONLOOM-PROMPT-001` acceptance criteria). Presents the offline
/// "Welcome back" modal when the container reports pending earnings.
struct RootView: View {
    @EnvironmentObject private var container: AppContainer

    var body: some View {
        TabView {
            FactoryView()
                .tabItem { Label("Factory", systemImage: "building.2.fill") }

            MoonRestorationView()
                .tabItem { Label("Moon", systemImage: "moon.stars.fill") }

            ShopView()
                .tabItem { Label("Shop", systemImage: "bag.fill") }

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape.fill") }
        }
        .tint(Theme.moonGold)
        .sheet(isPresented: offlineModalPresented) {
            if let result = container.pendingOfflineEarnings {
                OfflineWelcomeView(result: result) {
                    container.pendingOfflineEarnings = nil
                }
            }
        }
    }

    /// Drives the offline modal from the optional pending-earnings value.
    private var offlineModalPresented: Binding<Bool> {
        Binding(
            get: { container.pendingOfflineEarnings != nil },
            set: { isPresented in
                if !isPresented { container.pendingOfflineEarnings = nil }
            }
        )
    }
}
