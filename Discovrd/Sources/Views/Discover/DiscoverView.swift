import SwiftUI

/// Écran principal de l'onglet « Découvrir ».
public struct DiscoverView: View {
    @State private var viewModel: DiscoverViewModel

    public init(
        musicService: MusicServiceProtocol,
        tasteProfileService: TasteProfileServiceProtocol,
        swipeStore: SwipeStoreProtocol
    ) {
        _viewModel = State(initialValue: DiscoverViewModel(
            musicService: musicService,
            tasteProfileService: tasteProfileService,
            swipeStore: swipeStore
        ))
    }

    public var body: some View {
        ZStack {
            // Fond ambiant réactif à la carte courante
            AmbientArtworkBackground(track: viewModel.deckTracks.first)

            if viewModel.isLoading {
                ProgressView("Calcul de vos recommandations...")
                    .font(.headline)
            } else if let error = viewModel.errorMessage {
                ErrorView(message: error) {
                    Task {
                        await viewModel.loadInitialDeck()
                    }
                }
            } else if viewModel.deckTracks.isEmpty {
                EmptyDeckView(
                    title: "Plus de découvertes pour le moment",
                    message: "Écoutez quelques morceaux sur Apple Music puis actualisez votre pile.",
                    buttonTitle: "Actualiser"
                ) {
                    Task {
                        await viewModel.loadInitialDeck()
                    }
                }
            } else {
                SwipeDeckView(
                    tracks: viewModel.deckTracks,
                    canUndo: viewModel.canUndo,
                    isLoadingMore: viewModel.isLoadingMore,
                    onSwipe: { track, direction in
                        viewModel.handleSwipe(track: track, direction: direction)
                    },
                    onUndo: {
                        viewModel.undoLastSwipe()
                    }
                )
            }
        }
        .task {
            await viewModel.loadInitialDeck()
        }
    }
}
