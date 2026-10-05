import SwiftUI

/// Écran principal de l'onglet « Mes artistes ».
public struct MyArtistsView: View {
    @State private var viewModel: MyArtistsViewModel

    public init(musicService: MusicServiceProtocol, swipeStore: SwipeStoreProtocol) {
        _viewModel = State(initialValue: MyArtistsViewModel(
            musicService: musicService,
            swipeStore: swipeStore
        ))
    }

    public var body: some View {
        ZStack {
            AmbientArtworkBackground(track: viewModel.deckTracks.first)

            if viewModel.isLoading {
                ProgressView("Recherche des nouveautés de vos artistes...")
                    .font(.headline)
            } else if let error = viewModel.errorMessage {
                ErrorView(message: error) {
                    Task {
                        await viewModel.loadInitialDeck()
                    }
                }
            } else if viewModel.deckTracks.isEmpty {
                EmptyDeckView(
                    title: "Aucune nouveauté détectée",
                    message: "Vos artistes n'ont pas de nouveau titre absent de votre bibliothèque pour l'instant.",
                    buttonTitle: "Vérifier à nouveau"
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
