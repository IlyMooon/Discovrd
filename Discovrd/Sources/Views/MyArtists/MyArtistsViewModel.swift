import Foundation
import Observation

/// ViewModel pour l'onglet « Mes artistes ».
/// Récupère les nouveautés des artistes de la bibliothèque puis leurs meilleurs titres non présents.
@Observable
@MainActor
public final class MyArtistsViewModel {
    public private(set) var deckTracks: [TrackItem] = []
    public private(set) var isLoading: Bool = false
    public private(set) var isLoadingMore: Bool = false
    public private(set) var errorMessage: String?
    public private(set) var canUndo: Bool = false

    private let musicService: MusicServiceProtocol
    private let swipeStore: SwipeStoreProtocol

    private var storefront: String = "fr"
    private var pendingAddTasks: [String: Task<Void, Never>] = [:]
    private var undoTimer: Task<Void, Never>?

    public init(musicService: MusicServiceProtocol, swipeStore: SwipeStoreProtocol) {
        self.musicService = musicService
        self.swipeStore = swipeStore
    }

    public func loadInitialDeck() async {
        guard deckTracks.isEmpty && !isLoading else { return }
        isLoading = true
        errorMessage = nil

        do {
            storefront = try await musicService.fetchStorefront()
            let libraryArtists = try await musicService.fetchLibraryArtists()
            let libraryIDs = try await musicService.fetchLibrarySongIDs()
            let swipedIDs = try await swipeStore.fetchSwipedSongIDs()

            let artistIDs = libraryArtists.map(\.id)

            // 1. Sorties récentes
            let recentReleases = try await musicService.fetchRecentReleases(
                artistIDs: Array(artistIDs.prefix(20)),
                storefront: storefront
            )

            // 2. Meilleurs titres des artistes de la bibliothèque
            var topSongs: [TrackItem] = []
            for artistID in artistIDs.prefix(5) {
                let songs = try await musicService.fetchTopSongs(artistID: artistID, storefront: storefront)
                topSongs.append(contentsOf: songs)
            }

            // Ordre : nouveautés d'abord (date de sortie décroissante), puis meilleurs titres
            let combined = recentReleases + topSongs

            let filtered = DeckAlgorithm.filterCandidates(
                candidates: combined,
                librarySongIDs: libraryIDs,
                swipedSongIDs: swipedIDs,
                allowExplicit: AppSettings.shared.allowExplicitContent
            )

            let diversified = DeckAlgorithm.enforceArtistDiversity(tracks: filtered)
            self.deckTracks = diversified
            self.isLoading = false
        } catch {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }

    public func handleSwipe(track: TrackItem, direction: SwipeDirection) {
        guard !deckTracks.isEmpty else { return }
        deckTracks.removeAll(where: { $0.id == track.id })

        canUndo = true
        undoTimer?.cancel()
        undoTimer = Task { @MainActor in
            try? await Task.sleep(nanoseconds: 4_000_000_000)
            self.canUndo = false
        }

        Task {
            try? await swipeStore.recordSwipe(
                songID: track.id,
                artistID: track.artistId,
                direction: direction,
                source: .myArtists
            )
        }

        if direction == .like {
            let alsoLibrary = AppSettings.shared.alsoAddToLibrary
            let task = Task { @MainActor in
                try? await Task.sleep(nanoseconds: 4_000_000_000)
                guard !Task.isCancelled else { return }
                try? await self.musicService.addSongToDiscovrdPlaylist(songID: track.id, alsoAddToLibrary: alsoLibrary)
            }
            pendingAddTasks[track.id] = task
        }
    }

    public func undoLastSwipe() {
        guard canUndo else { return }
        canUndo = false
        undoTimer?.cancel()

        Task {
            if let record = try? await swipeStore.removeLastSwipe() {
                if let task = pendingAddTasks.removeValue(forKey: record.songID) {
                    task.cancel()
                }
            }
        }
    }
}
