# MoonloomApp — Source

This is the iOS app implementation for **Moonloom: Idle Dream Factory**. It is
built from the documentation in `../docs/` (the PRDs are the source of truth).

## Requirements

- **Xcode 16+** (the project uses file-system synchronized groups, `objectVersion 77`)
- **iOS 17.0+** deployment target
- Pure SwiftUI + SwiftData + Swift Concurrency — **no third-party dependencies**

## Build & run

Open `../MoonloomApp.xcodeproj` in Xcode and run the `MoonloomApp` scheme on an
iOS 17+ simulator, or from the command line:

```sh
xcodebuild -project MoonloomApp.xcodeproj -scheme MoonloomApp \
  -destination 'platform=iOS Simulator,name=iPhone 16' build

xcodebuild -project MoonloomApp.xcodeproj -scheme MoonloomApp \
  -destination 'platform=iOS Simulator,name=iPhone 16' test
```

If the `.xcodeproj` ever needs regenerating, a matching
[`XcodeGen`](https://github.com/yonaskolb/XcodeGen) spec lives at `../project.yml`:

```sh
xcodegen generate
```

## Architecture (Clean Architecture + MVVM)

```
App/            @main entry, AppContainer (DI), root TabView navigation
Core/
  Domain/       Models, EconomyConfig, use cases (offline, prestige)
  Data/         SwiftData @Model records + GameStateRepository
Services/       NumberAbbreviator, ProductionEngine (actor), Haptics, Audio,
                Analytics, TimeProvider
Features/       Factory, MoonRestoration, Shop, Settings (views + view models)
Presentation/   Theme + reusable components
Resources/      Assets.xcassets
```

The single observed `GameState` (`@MainActor ObservableObject`) is the source of
truth the UI binds to. The `ProductionEngine` actor advances the simulation;
simulation math lives in the domain layer, never in views.

## Foundation scope (MOONLOOM-PROMPT-001)

Implemented: app shell + 4-tab navigation, GameState, EconomyConfig with all 12
tiers, persistence, production engine, offline earnings, prestige math &
New Moon Reset, number formatting, haptics, and audio/analytics stubs.

Deferred to later phases (clearly isolated, safe): live StoreKit purchasing
(Shop is a non-charging catalog), audio playback, local notifications, the full
biome story sequence, achievements, and cosmetic theming. See
`../docs/PROJECT_TRACKER.md`.
