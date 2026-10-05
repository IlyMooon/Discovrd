import Foundation
import Observation

/// ViewModel orchestrant l'onglet « Découvrir ».
/// Récupère les artistes similaires pour les artistes les plus écoutés, filtre et recharge automatiquement sous les 5 cartes.
@Observable
@MainActor
public final class DiscoverViewModel {
    public private(set) var deckTracks: [TrackItem] = []
    public private(set) var isLoading: Bool = false
    public private(set) var isLoadingMore: Bool = false
    public private(set) var errorMessage: String?
    public private(set) var canUndo: Bool = false

    private let musicService: MusicServiceProtocol
    private let tasteProfileService: TasteProfileServiceProtocol
    private let swipeStore: SwipeStoreProtocol

    private var storefront: String = "fr"
    private var pendingAddTasks: [String: Task<Void, Never>] = [:]
    private var undoTimer: Task<Void, Never>?

    public init(
        musicService: MusicServiceProtocol,
        tasteProfileService: TasteProfileServiceProtocol,
        swipeStore: SwipeStoreProtocol
    ) {
        self.musicService = musicService
        self.tasteProfileService = tasteProfileService
        self.swipeStore = swipeStore
    }

    public func loadInitialDeck() async {
        guard deckTracks.isEmpty && !isLoading else { return }
        isLoading = true
        errorMessage = nil

        do {
            storefront = try await musicService.fetchStorefront()
            let profile = try await tasteProfileService.getOrComputeProfile(forceRefresh: false)
            let libraryIDs = try await musicService.fetchLibrarySongIDs()
            let swipedIDs = try await swipeStore.fetchSwipedSongIDs()

            var candidateTracks: [TrackItem] = []
            let targetArtists = Array(profile.topArtistIDs.prefix(5))

            for artistID in targetArtists {
                let similar = try await musicService.fetchSimilarArtists(artistID: artistID, storefront: storefront)
                for sim in similar.prefix(3) {
                    let songs = try await musicService.fetchTopSongs(artistID: sim.id, storefront: storefront)
                    let annotated = songs.map { song in
                        TrackItem(
                            id: song.id,
                            title: song.title,
                            artistName: song.artistName,
                            artistId: song.artistId,
                            albumTitle: song.albumTitle,
                            genreNames: song.genreNames,
                            duration: song.duration,
                            isExplicit: song.isExplicit,
                            artworkURL: song.artworkURL,
                            artworkBackgroundColorHex: song.artworkBackgroundColorHex,
                            previewURL: song.previewURL,
                            appleMusicURL: song.appleMusicURL,
                            recommendationReason: "Parce que tu écoutes \(artistID)"
                        )
                    }
                    candidateTracks.append(contentsOf: annotated)
                }
            }

            let filtered = DeckAlgorithm.filterCandidates(
                candidates: candidateTracks,
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

        // Activer la possibilité d'annuler
        canUndo = true
        undoTimer?.cancel()
        undoTimer = Task { @MainActor in
            try? await Task.sleep(nanoseconds: 4_000_000_000)
            self.canUndo = false
        }

        // Sauvegarder localement dans le SwipeStore
        Task {
            try? await swipeStore.recordSwipe(
                songID: track.id,
                artistID: track.artistId,
                direction: direction,
                source: .discover
            )
        }

        // Si j'aime : différer de 4 secondes l'écriture dans la playlist pour permettre l'annulation
        if direction == .like {
            let alsoLibrary = AppSettings.shared.alsoAddToLibrary
            let task = Task { @MainActor in
                try? await Task.sleep(nanoseconds: 4_000_000_000)
                guard !Task.isCancelled else { return }
                try? await self.musicService.addSongToDiscovrdPlaylist(songID: track.id, alsoAddToLibrary: alsoLibrary)
            }
            pendingAddTasks[track.id] = task
        }

        // Vérifier si le seuil de 5 cartes est franchi pour précharger en tâche de fond
        if deckTracks.count < 5 && !isLoadingMore {
            Task {
                await loadMoreTracks()
            }
        }
    }

    public func undoLastSwipe() {
        guard canUndo else { return }
        canUndo = false
        undoTimer?.cancel()

        Task {
            if let record = try? await swipeStore.removeLastSwipe() {
                // Annuler l'écriture différée si présente
                if let task = pendingAddTasks.removeValue(forKey: record.songID) {
                    task.cancel()
                }
            }
        }
    }

    private func loadMoreTracks() async {
        guard !isLoadingMore else { return }
        isLoadingMore = true

        do {
            let profile = try await tasteProfileService.getOrComputeProfile(forceRefresh: false)
            let libraryIDs = try await musicService.fetchLibrarySongIDs()
            let swipedIDs = try await swipeStore.fetchSwipedSongIDs()

            var newCandidates: [TrackItem] = []
            // Prendre les artistes suivants
            let targetArtists = Array(profile.topArtistIDs.dropFirst(5).prefix(5))

            for artistID in targetArtists {
                let similar = try await musicService.fetchSimilarArtists(artistID: artistID, storefront: storefront)
                for sim in similar.prefix(2) {
                    let songs = try await musicService.fetchTopSongs(artistID: sim.id, storefront: storefront)
                    newCandidates.append(contentsOf: songs)
                }
            }

            let filtered = DeckAlgorithm.filterCandidates(
                candidates: newCandidates,
                librarySongIDs: libraryIDs,
                swipedSongIDs: swipedIDs,
                allowExplicit: AppSettings.shared.allowExplicitContent
            )

            let diversified = DeckAlgorithm.enforceArtistDiversity(tracks: filtered)
            self.deckTracks.append(contentsOf: diversified)
            self.isLoadingMore = false
        } catch {
            self.isLoadingMore = false
        }
    }
}
