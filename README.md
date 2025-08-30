# HubNext — MVP (iOS + modular code for SPM extraction)

This archive contains a **working iOS Xcode project** for LifeHub (SwiftUI, iOS 16),
plus a modular folder structure (`Modules/Core`, `Modules/UI`, `Modules/Platform`) ready
to be extracted as **Swift Package Manager** packages in a later step. The focus is on
a **functional, clean architecture (MVVM + light coordinators)** with a **Developer** area
(seed, toggles, console log).

> Placeholders:
> - Bundle ID: `com.placeholder.hubnext`
> - iCloud Container: `iCloud.com.placeholder.hubnext`
> - Team ID: `TEAMIDPLACEHOLDER`

## What’s included (MVP)
- iOS app target (**buildable in Xcode**).
- Tabs: People, Projects, Documents (placeholder), Places (placeholder), Query (basic), Log, Developer.
- In-memory Graph client (CRUD Entity/Relationship), basic Query (type/tag/text contains), Log console.
- MVVM + lightweight "Coordinator" structs for routing.
- Doc comments (///) in English for public classes/functions.
- Developer area: seed small/medium, toggle auto-sync (no-op stub), switch persistence (visual only), console log.
- Ready-to-wire stubs for: GraphNext adapter + CloudKit sync (guarded by `#if canImport(GraphNext)` stubs).

> NOTE: CloudKit sync and true GraphNext integration are **stubbed** to compile without GraphNext.
> You can integrate your GraphNext package later and flip the `GraphClient` adapter.

## Open in Xcode
1. Open `LifeHub-iOS/LifeHub.xcodeproj` in Xcode 15+.
2. Let Xcode update settings if prompted.
3. Select the `LifeHub` scheme and run on iOS 16+ simulator/device.
4. Replace placeholders for Bundle ID / iCloud container under **Signing & Capabilities**.

## Future steps (optional)
- Extract `Modules/Core`, `Modules/UI`, `Modules/Platform` into SPM packages and re-link the app.
- Add macOS, tvOS, watchOS targets using the same ViewModels and UI components.
- Replace in-memory client with GraphNext adapter and enable CloudKit sync.
