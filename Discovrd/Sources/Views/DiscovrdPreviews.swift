import SwiftUI

#Preview("Carte seule - Clair") {
    ZStack {
        Color.black.ignoresSafeArea()
        TrackCardView(track: MockMusicService.sampleTracks[0], isTopCard: true)
            .frame(width: 340, height: 500)
    }
    .preferredColorScheme(.light)
}

#Preview("Carte seule - Sombre") {
    ZStack {
        Color.black.ignoresSafeArea()
        TrackCardView(track: MockMusicService.sampleTracks[0], isTopCard: true)
            .frame(width: 340, height: 500)
    }
    .preferredColorScheme(.dark)
}

#Preview("Composant SwipeDeck complet") {
    ZStack {
        AmbientArtworkBackground(track: MockMusicService.sampleTracks[0])
        SwipeDeckView(
            tracks: MockMusicService.sampleTracks,
            canUndo: true,
            isLoadingMore: false,
            onSwipe: { _, _ in },
            onUndo: {}
        )
    }
    .preferredColorScheme(.dark)
}

#Preview("Écran d'onboarding") {
    OnboardingView(onComplete: {})
        .preferredColorScheme(.dark)
}

#Preview("Écran Réglages") {
    SettingsView(swipeStore: MockSwipeStore())
        .preferredColorScheme(.dark)
}
