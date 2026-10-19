# Discovrd

A native iOS music discovery app powered by Apple Music and intuitive swipe gestures.

[![Platform](https://img.shields.io/badge/Platform-iOS%2026%2B-blue?logo=apple)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-6.0-orange?logo=swift)](https://swift.org)
[![Frameworks](https://img.shields.io/badge/Frameworks-SwiftUI%20%7C%20MusicKit%20%7C%20SwiftData-purple)](https://developer.apple.com/documentation/musickit)
[![License](https://img.shields.io/badge/License-TODO-lightgrey)](#license)

---

## Short Description

Discovrd is a native iOS music discovery application built for Apple Music subscribers. It replaces passive recommendation lists with an interactive, tactile card-swiping interface inspired by modern discovery workflows.

By analyzing the user's Apple Music library and recent listening history directly on the device, Discovrd identifies emerging tracks, similar artists, and overlooked catalog gems. Everything is computed and stored locally on the device using SwiftData, ensuring complete privacy with zero external servers, trackers, or telemetry.

---

## Features

- **Tactile Swipe Deck**: Swipe right to like a track and automatically add it to a dedicated "Discovrd" playlist in Apple Music; swipe left to pass and exclude it from future sessions.
- **4-Second Graceful Undo**: A dynamic undo timer allows users to revert accidental swipes before changes are committed to Apple Music.
- **Instant 30-Second Audio Previews**: Automatically plays official 30-second audio previews using `AVPlayer` with predictive preloading of upcoming cards for zero-latency transitions.
- **Dual Discovery Decks**:
  - **Discover**: Surfaces songs from artists not yet in your library, calculated from your most-played artists and similar artist graphs.
  - **My Artists**: Delivers recent releases, new singles, and popular uncollected tracks from artists already in your library.
- **On-Device Taste Profile Engine**: Mathematical scoring with exponential recency decay ($\lambda = -0.023$, halving weight every 30 days) to keep suggestions aligned with recent listening habits.
- **Catalog Filtering & Diversity Rules**: Automatically excludes tracks already in the user's library or previously swiped, enforces explicit content preferences, and guarantees that no more than two consecutive cards come from the same artist.
- **Liquid Glass Visual Design**: Translucent glass controls (`buttonStyle(.glass)`), an ambient dynamic background that adapts to album artwork colors, and full support for Dark Mode and VoiceOver.
- **100% Privacy & Local Persistence**: All swipe history, preferences, and cached profiles are stored strictly on-device via SwiftData and UserDefaults.

---

## Screenshots / Demo

> [!NOTE]
> Screenshots will be added prior to App Store release. See [RELEASE_CHECKLIST.md](file:///Users/germainbard/Documents/Discovrd/RELEASE_CHECKLIST.md) Phase 2 for exact capture specifications (iPhone 6.9" and 6.3"/6.7").

| Discover Feed | Swipe Action | My Artists Feed | Settings |
| :---: | :---: | :---: | :---: |
| *TODO: Add screenshot* | *TODO: Add screenshot* | *TODO: Add screenshot* | *TODO: Add screenshot* |

---

## Requirements / Prerequisites

- **macOS**: 15.0 (Sequoia) or later
- **Xcode**: 16.0 or later (with iOS 26+ SDK)
- **Swift**: 6.0 compiler toolchain with Complete Strict Concurrency
- **Apple Developer Account**: Paid membership required to enable the **MusicKit** capability in your App ID for testing on physical devices and TestFlight.
- **Apple Music Subscription**: Active Apple Music subscription required for real catalog queries, audio streaming, and playlist writing. (For offline or simulator testing, `MockMusicService` can be used without an account).
- **Test Target**: Physical iPhone running iOS 26+ (recommended) or iOS Simulator.

---

## Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/IlyMooon/Discovrd.git
   cd Discovrd
   ```

2. **Open the project in Xcode:**
   ```bash
   open Discovrd.xcodeproj
   ```

   > [!NOTE]
   > Discovrd uses native Apple frameworks (`SwiftUI`, `MusicKit`, `SwiftData`, `AVFoundation`). There are no third-party package dependencies (SPM, CocoaPods, or Carthage).

3. **(Optional) Rebuild project configuration:**
   If source files or resources are modified outside of Xcode, regenerate `project.pbxproj` using the included Python script:
   ```bash
   python3 make_pbx.py
   ```

---

## Configuration

### 1. Apple Developer Signing & MusicKit Capability
Because Discovrd communicates directly with Apple Music via MusicKit, you must link your Apple Developer Team:
1. In Xcode, select the `Discovrd` project in the Project Navigator.
2. Under **Targets**, select `Discovrd`.
3. Open the **Signing & Capabilities** tab.
4. Set your development **Team**.
5. Update the **Bundle Identifier** from `com.example.Discovrd` to your unique identifier (e.g., `com.yourname.Discovrd`).
6. Confirm that the **MusicKit** capability is present in the target's capabilities list.

### 2. Environment Variables & `.env`
Discovrd does **not** require any API keys, backend tokens, or `.env` files at runtime. MusicKit authentication is handled transparently by iOS using your signed provisioning profile.

A safe template [`file://.env.example`](file:///Users/germainbard/Documents/Discovrd/.env.example) is provided for optional CI/CD or command-line signing variables:
```bash
cp .env.example .env
```

### 3. In-App User Settings
User preferences are stored locally in `UserDefaults` and managed through [`AppSettings.swift`](file:///Users/germainbard/Documents/Discovrd/Discovrd/Sources/Models/AppSettings.swift):

| Preference | Key | Type | Default | Description |
| :--- | :--- | :--- | :--- | :--- |
| **Also Add to Library** | `discovrd_alsoAddToLibrary` | `Bool` | `true` | When enabled, liked tracks are added to both the "Discovrd" playlist and the user's Apple Music library. |
| **Allow Explicit Content** | `discovrd_allowExplicitContent` | `Bool` | `true` | When disabled, explicit tracks are filtered out of all decks. |
| **Autoplay Previews** | `discovrd_autoplayPreviews` | `Bool` | `true` | Automatically streams 30-second audio previews when cards become active. |
| **Onboarding Completed** | `discovrd_hasCompletedOnboarding` | `Bool` | `false` | Tracks whether the initial welcome tour has been completed. |

---

## How to Run

### Development Mode (Simulator & Mocks)
1. Open `Discovrd.xcodeproj` in Xcode.
2. Select the `Discovrd` scheme.
3. Choose an iOS Simulator (e.g., `iPhone 16 Pro`).
4. Press `Cmd + R` to build and run.
5. In simulator environments without Apple Music credentials, UI components and flows can be previewed using SwiftUI Previews and [`MockMusicService`](file:///Users/germainbard/Documents/Discovrd/Discovrd/Sources/Services/MockMusicService.swift).

### Production / Release Mode (Physical Device)
1. Connect a physical iPhone running iOS 26+ via USB or local Wi-Fi.
2. Ensure your Apple ID on the device has an active Apple Music subscription.
3. Select your device as the run destination in Xcode.
4. Press `Cmd + R` (Debug) or build for Release:
   ```bash
   xcodebuild -project Discovrd.xcodeproj \
     -scheme Discovrd \
     -configuration Release \
     -destination 'generic/platform=iOS' \
     build
   ```

### Running Tests

#### Unit Tests via Xcode
Press `Cmd + U` to run all unit tests in `DiscovrdTests` and UI tests in `DiscovrdUITests`.

#### Unit Tests via Terminal
```bash
xcodebuild test \
  -project Discovrd.xcodeproj \
  -scheme Discovrd \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro'
```

#### Standalone Logic Test Runner
The project includes [`DiscovrdTests/TestRunner.swift`](file:///Users/germainbard/Documents/Discovrd/DiscovrdTests/TestRunner.swift), a standalone test suite that validates `TasteProfileEngine`, `DeckAlgorithm`, and `MyArtistsViewModel` pure logic.

---

## Usage

1. **Onboarding & Permissions**:
   - On first launch, browse the 3-screen walkthrough outlining gesture controls and privacy.
   - Tap **Authorize Apple Music** when prompted to allow Discovrd to read your library and manage your "Discovrd" playlist.
2. **Discover Tab**:
   - Swipe **Right** (or tap the Heart button) to like a track. The song is scheduled for addition to your "Discovrd" playlist.
   - Swipe **Left** (or tap the Cross button) to pass on a track. It will not be suggested again.
   - Tap the **Undo** button (orange arrow) within 4 seconds if you made an accidental swipe.
3. **My Artists Tab**:
   - Switch to the "My Artists" tab to discover new singles, latest releases, and popular uncollected tracks from artists already in your collection.
4. **Settings Tab**:
   - Adjust explicit content filtering or preview autoplay.
   - Tap **"Réinitialiser l'historique de swipes"** to clear stored swipe records and reset recommendation exclusions.

---

## Project Structure

```
Discovrd/
├── Discovrd.xcodeproj/                     # Xcode project definition and shared schemes
├── Discovrd/
│   ├── Resources/
│   │   ├── Assets.xcassets/                # Accent colors, AppIcon, and visual assets
│   │   ├── Info.plist                      # Application configuration and permission keys
│   │   ├── PrivacyInfo.xcprivacy           # Apple Privacy Manifest (NSPrivacyTracking = false)
│   │   ├── en.lproj/InfoPlist.strings      # English localization strings
│   │   └── fr.lproj/InfoPlist.strings      # French localization strings
│   └── Sources/
│       ├── App/
│       │   └── DiscovrdApp.swift           # Application entry point, SwiftData setup & DI
│       ├── Models/
│       │   ├── TrackItem.swift             # Unified track data model
│       │   ├── SwipeRecord.swift           # Persistent SwiftData model for swipe history
│       │   ├── CachedTasteProfile.swift    # SwiftData cache for computed user preferences
│       │   ├── TasteProfile.swift          # Pure mathematical engine for taste scoring
│       │   ├── DeckAlgorithm.swift         # Pure filtering, deduplication, and diversity logic
│       │   └── AppSettings.swift           # Persistent user settings backed by UserDefaults
│       ├── Services/
│       │   ├── ServiceProtocols.swift      # Protocol definitions for services and stores
│       │   ├── AppleMusicService.swift     # MusicKit and Apple Music API integration
│       │   ├── MusicAPINetworkClient.swift # Network execution client with exponential backoff
│       │   ├── TasteProfileService.swift   # History aggregation and 12-hour profile caching
│       │   ├── AudioPreviewPlayer.swift    # AVPlayer wrapper with predictive track preloading
│       │   ├── SwiftDataSwipeStore.swift   # SwiftData persistence store for swipes
│       │   ├── MockMusicService.swift      # Deterministic mock service for tests and previews
│       │   └── MockSwipeStore.swift        # In-memory swipe store for isolated testing
│       └── Views/
│           ├── MainTabView.swift           # Root tab bar navigation view
│           ├── Components/                 # Reusable UI components (Deck, Card, Glass, Stamps)
│           ├── Discover/                   # Discover feed view and DiscoverViewModel
│           ├── MyArtists/                  # My Artists feed view and MyArtistsViewModel
│           ├── Onboarding/                 # Onboarding carousel and authorization views
│           ├── Settings/                   # Settings view and data management
│           └── DiscovrdPreviews.swift      # SwiftUI preview compositions with mock data
├── DiscovrdTests/                          # Unit test suite (Algorithm, Flow, TasteProfile)
├── DiscovrdUITests/                        # UI automation tests
├── .env.example                            # Template for optional CI/CD environment variables
├── .gitignore                              # Comprehensive git ignore rules for iOS and tools
├── make_pbx.py                             # Python script to regenerate project.pbxproj
├── generate_project.swift                  # Swift script for project file generation
├── METADATA.md                             # App Store Connect metadata copy (FR & EN)
├── PRIVACY_POLICY.md                       # Full privacy policy ready for web hosting
└── RELEASE_CHECKLIST.md                    # Step-by-step signing, QA, and App Store checklist
```

---

## Build / Deploy

To package and submit Discovrd to TestFlight or the App Store:

1. **Verify Developer Portal Configuration**:
   - Ensure your App ID on [developer.apple.com](https://developer.apple.com) has **MusicKit** enabled.
2. **Archive the Application**:
   - In Xcode, select `Product > Destination > Any iOS Device (arm64)`.
   - Select `Product > Archive`, or execute via terminal:
     ```bash
     xcodebuild archive \
       -project Discovrd.xcodeproj \
       -scheme Discovrd \
       -configuration Release \
       -archivePath build/Discovrd.xcarchive
     ```
3. **Upload to App Store Connect**:
   - Open Xcode Organizer (`Window > Organizer`), select the archive, and click **Distribute App**.
   - Choose **App Store Connect** and upload.
4. **App Store Listing**:
   - Copy marketing copy, keywords, and App Review test notes from [`METADATA.md`](file:///Users/germainbard/Documents/Discovrd/METADATA.md).
   - Host [`PRIVACY_POLICY.md`](file:///Users/germainbard/Documents/Discovrd/PRIVACY_POLICY.md) on a public URL and link it in App Store Connect.
   - Follow all release verification steps detailed in [`RELEASE_CHECKLIST.md`](file:///Users/germainbard/Documents/Discovrd/RELEASE_CHECKLIST.md).

---

## Troubleshooting / FAQ

### 1. `MusicAuthStatus.denied` or `restricted`
- **Cause**: The user denied the Apple Music permission request or Screen Time restrictions prevent access.
- **Fix**: Open the **Settings** app on the iOS device, navigate to **Privacy & Security > Media & Apple Music**, and toggle **Discovrd** on.

### 2. `SubscriptionStatus.notSubscribed` (Degraded Mode)
- **Cause**: The signed-in Apple ID does not have an active Apple Music subscription.
- **Fix**: Sign in to an Apple ID with an active subscription in device settings. While 30-second previews may still play depending on catalog availability, creating playlists and adding songs requires an active subscription.

### 3. Audio Previews Do Not Play
- **Cause**: The device is on silent mode, `autoplayPreviews` is disabled in Settings, or the specific catalog track lacks a 30-second preview asset (`previewURL == nil`).
- **Fix**: Verify audio volume, check the "Lecture automatique des extraits" toggle in Settings, and test with tracks that provide valid preview URLs.

### 4. Xcode error: "tool 'xcodebuild' requires Xcode, but active developer directory is CommandLineTools"
- **Cause**: `xcode-select` points to standalone Command Line Tools instead of the full Xcode application bundle.
- **Fix**: Run the following command in Terminal:
  ```bash
  sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
  ```

### 5. API Rate Limiting (HTTP 429)
- **Cause**: Sending too many simultaneous requests to the Apple Music API.
- **Behavior**: Handled automatically by [`MusicAPINetworkClient.swift`](file:///Users/germainbard/Documents/Discovrd/Discovrd/Sources/Services/MusicAPINetworkClient.swift) using exponential backoff (up to 3 retries).

### 6. SwiftData ModelContainer Initialization Fallback
- **Cause**: Device storage corruption or restricted container creation in non-standard test environments.
- **Behavior**: [`DiscovrdApp.swift`](file:///Users/germainbard/Documents/Discovrd/Discovrd/Sources/App/DiscovrdApp.swift) catches initialization errors and gracefully falls back to an in-memory `ModelContainer` to prevent crashes.

---

## Contributing

1. Fork the repository and create a feature branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```
2. Adhere to Swift 6 strict concurrency (`SWIFT_STRICT_CONCURRENCY = complete`).
3. Ensure all tests pass:
   ```bash
   xcodebuild test -project Discovrd.xcodeproj -scheme Discovrd -destination 'platform=iOS Simulator,name=iPhone 16 Pro'
   ```
4. Commit your changes with clear, semantic commit messages.
5. Push to your branch and open a Pull Request.

---

## License

> [!IMPORTANT]
> TODO: Add a `LICENSE` file to the root of the repository (e.g., MIT, Apache 2.0, or proprietary) to define the legal terms of use for this project.

---

## Credits / Acknowledgements

- **Apple MusicKit**: Native integration with the Apple Music catalog and personal cloud libraries.
- **SwiftUI & SwiftData**: Modern declarative user interface and local data persistence.
- **AVFoundation**: Low-latency audio preview playback engine.
- Designed and built by **Germain Bard**.
