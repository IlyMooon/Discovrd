import Foundation

public struct PBXGenerator {
    public static func main() {
        // Collecter tous les fichiers Swift du projet
        let baseDir = "/Users/germainbard/Documents/Discovrd"
        let sourceFiles = [
            "Discovrd/Sources/App/DiscovrdApp.swift",
            "Discovrd/Sources/Models/TrackItem.swift",
            "Discovrd/Sources/Models/SwipeRecord.swift",
            "Discovrd/Sources/Models/CachedTasteProfile.swift",
            "Discovrd/Sources/Models/TasteProfile.swift",
            "Discovrd/Sources/Models/DeckAlgorithm.swift",
            "Discovrd/Sources/Models/AppSettings.swift",
            "Discovrd/Sources/Services/ServiceProtocols.swift",
            "Discovrd/Sources/Services/SwiftDataSwipeStore.swift",
            "Discovrd/Sources/Services/TasteProfileService.swift",
            "Discovrd/Sources/Services/MusicAPINetworkClient.swift",
            "Discovrd/Sources/Services/AppleMusicService.swift",
            "Discovrd/Sources/Services/MockMusicService.swift",
            "Discovrd/Sources/Services/MockSwipeStore.swift",
            "Discovrd/Sources/Services/AudioPreviewPlayer.swift",
            "Discovrd/Sources/Views/Components/AmbientArtworkBackground.swift",
            "Discovrd/Sources/Views/Components/TrackCardView.swift",
            "Discovrd/Sources/Views/Components/ActionButtonsBar.swift",
            "Discovrd/Sources/Views/Components/SwipeStampView.swift",
            "Discovrd/Sources/Views/Components/SwipeDeckView.swift",
            "Discovrd/Sources/Views/Components/EmptyDeckView.swift",
            "Discovrd/Sources/Views/Components/ErrorView.swift",
            "Discovrd/Sources/Views/Discover/DiscoverViewModel.swift",
            "Discovrd/Sources/Views/Discover/DiscoverView.swift",
            "Discovrd/Sources/Views/MyArtists/MyArtistsViewModel.swift",
            "Discovrd/Sources/Views/MyArtists/MyArtistsView.swift",
            "Discovrd/Sources/Views/Settings/SettingsView.swift",
            "Discovrd/Sources/Views/Onboarding/OnboardingView.swift",
            "Discovrd/Sources/Views/Onboarding/AuthorizationPromptView.swift",
            "Discovrd/Sources/Views/MainTabView.swift",
            "Discovrd/Sources/Views/DiscovrdPreviews.swift"
        ]

        let testFiles = [
            "DiscovrdTests/TasteProfileTests.swift",
            "DiscovrdTests/DeckAlgorithmTests.swift",
            "DiscovrdTests/DeckFlowTests.swift"
        ]

        let uiTestFiles = [
            "DiscovrdUITests/DiscovrdUITests.swift"
        ]

        print("Génération du projet Discovrd.xcodeproj...")
    }
}
PBXGenerator.main()
