import Foundation
import MusicKit

/// Implémentation réelle de MusicServiceProtocol s'appuyant sur MusicKit et l'Apple Music API.
public final class AppleMusicService: MusicServiceProtocol, @unchecked Sendable {
    private var cachedStorefront: String?

    public init() {}

    public func requestAuthorization() async -> MusicAuthStatus {
        let status = await MusicAuthorization.request()
        switch status {
        case .authorized:
            return .authorized
        case .denied:
            return .denied
        case .restricted:
            return .restricted
        case .notDetermined:
            return .notDetermined
        @unknown default:
            return .notDetermined
        }
    }

    public func checkSubscription() async -> SubscriptionStatus {
        do {
            let sub = try await MusicSubscription.current
            if sub.canPlayCatalogContent {
                return .subscribed
            } else {
                return .notSubscribed(isDegradedMode: true)
            }
        } catch {
            return .notSubscribed(isDegradedMode: true)
        }
    }

    public func fetchStorefront() async throws -> String {
        if let cached = cachedStorefront {
            return cached
        }

        let storefront: String = try await MusicAPINetworkClient.executeWithRetry {
            guard let url = URL(string: "https://api.music.apple.com/v1/me/storefront") else {
                return "fr"
            }
            let request = MusicDataRequest(urlRequest: URLRequest(url: url))
            let response = try await request.response()

            struct StorefrontResponse: Decodable {
                struct Item: Decodable {
                    let id: String
                }
                let data: [Item]
            }

            let decoded = try JSONDecoder().decode(StorefrontResponse.self, from: response.data)
            return decoded.data.first?.id ?? "fr"
        }

        self.cachedStorefront = storefront
        return storefront
    }

    public func fetchLibrarySongIDs() async throws -> Set<String> {
        var libraryIDs = Set<String>()
        var request = MusicLibraryRequest<Song>()
        request.limit = 100
        let response = try await request.response()
        for song in response.items {
            libraryIDs.insert(song.id.rawValue)
        }
        return libraryIDs
    }

    public func fetchLibraryArtists() async throws -> [(id: String, name: String)] {
        var results: [(id: String, name: String)] = []
        var request = MusicLibraryRequest<Artist>()
        request.limit = 100
        let response = try await request.response()
        for artist in response.items {
            results.append((id: artist.id.rawValue, name: artist.name))
        }
        return results
    }

    public func fetchListeningHistory() async throws -> [PlayHistoryItem] {
        var items: [PlayHistoryItem] = []

        // 1. Écoutes récentes
        var recentRequest = MusicRecentlyPlayedRequest<Song>()
        recentRequest.limit = 50
        if let response = try? await recentRequest.response() {
            for song in response.items {
                let artistID = song.artists?.first?.id.rawValue ?? song.artistName
                items.append(
                    PlayHistoryItem(
                        songID: song.id.rawValue,
                        artistID: artistID,
                        genreNames: song.genreNames,
                        playCount: 1,
                        lastPlayedDate: Date()
                    )
                )
            }
        }

        // 2. Bibliothèque
        var libRequest = MusicLibraryRequest<Song>()
        libRequest.limit = 50
        if let libResponse = try? await libRequest.response() {
            for song in libResponse.items {
                let artistID = song.artists?.first?.id.rawValue ?? song.artistName
                items.append(
                    PlayHistoryItem(
                        songID: song.id.rawValue,
                        artistID: artistID,
                        genreNames: song.genreNames,
                        playCount: max(1, song.playCount ?? 1),
                        lastPlayedDate: song.lastPlayedDate
                    )
                )
            }
        }

        return items
    }

    public func fetchSimilarArtists(artistID: String, storefront: String) async throws -> [(id: String, name: String)] {
        let endpoint = "https://api.music.apple.com/v1/catalog/\(storefront)/artists/\(artistID)/view/similar-artists"
        guard let url = URL(string: endpoint) else { return [] }

        return try await MusicAPINetworkClient.executeWithRetry {
            let request = MusicDataRequest(urlRequest: URLRequest(url: url))
            let response = try await request.response()

            struct SimilarArtistsResponse: Decodable {
                struct Item: Decodable {
                    let id: String
                    struct Attributes: Decodable {
                        let name: String
                    }
                    let attributes: Attributes?
                }
                let data: [Item]?
            }

            let decoded = try JSONDecoder().decode(SimilarArtistsResponse.self, from: response.data)
            return (decoded.data ?? []).compactMap { item in
                guard let name = item.attributes?.name else { return nil }
                return (id: item.id, name: name)
            }
        }
    }

    public func fetchTopSongs(artistID: String, storefront: String) async throws -> [TrackItem] {
        let endpoint = "https://api.music.apple.com/v1/catalog/\(storefront)/artists/\(artistID)/view/top-songs"
        guard let url = URL(string: endpoint) else { return [] }

        return try await MusicAPINetworkClient.executeWithRetry {
            let request = MusicDataRequest(urlRequest: URLRequest(url: url))
            let response = try await request.response()

            return self.parseCatalogSongs(data: response.data, defaultReason: "Morceau populaire")
        }
    }

    public func fetchRecentReleases(artistIDs: [String], storefront: String) async throws -> [TrackItem] {
        guard !artistIDs.isEmpty else { return [] }

        var allReleases: [TrackItem] = []
        // Découpage par lots pour respecter les limites de l'API
        let batchSize = 10
        let batches = stride(from: 0, to: artistIDs.count, by: batchSize).map {
            Array(artistIDs[$0..<min($0 + batchSize, artistIDs.count)])
        }

        for batch in batches {
            for artistID in batch {
                let endpoint = "https://api.music.apple.com/v1/catalog/\(storefront)/artists/\(artistID)/view/latest-release"
                guard let url = URL(string: endpoint) else { continue }

                if let releases = try? await MusicAPINetworkClient.executeWithRetry(operation: {
                    let req = MusicDataRequest(urlRequest: URLRequest(url: url))
                    let res = try await req.response()
                    return self.parseCatalogSongs(data: res.data, defaultReason: "Nouveauté de tes artistes")
                }) {
                    allReleases.append(contentsOf: releases)
                }
            }
        }

        return allReleases
    }

    public func addSongToDiscovrdPlaylist(songID: String, alsoAddToLibrary: Bool) async throws {
        var playlistRequest = MusicLibraryRequest<Playlist>()
        playlistRequest.filter(matching: \.name, equalTo: "Discovrd")
        let response = try await playlistRequest.response()

        let playlist: Playlist
        if let existing = response.items.first {
            playlist = existing
        } else {
            playlist = try await MusicLibrary.shared.createPlaylist(
                name: "Discovrd",
                description: "Vos coups de cœur découverts dans l'application Discovrd",
                authorDisplayName: "Discovrd"
            )
        }

        let songCatalogRequest = MusicCatalogResourceRequest<Song>(matching: \.id, equalTo: MusicItemID(songID))
        let songResponse = try await songCatalogRequest.response()
        guard let song = songResponse.items.first else { return }

        try await MusicLibrary.shared.add(song, to: playlist)

        if alsoAddToLibrary {
            try await MusicLibrary.shared.add(song)
        }
    }

    private func parseCatalogSongs(data: Data, defaultReason: String) -> [TrackItem] {
        struct SongItem: Decodable {
            let id: String
            struct Attributes: Decodable {
                let name: String
                let artistName: String
                let albumName: String?
                let genreNames: [String]?
                let releaseDate: String?
                let durationInMillis: Int?
                let contentRating: String?
                let url: String?
                struct Artwork: Decodable {
                    let url: String
                    let bgColor: String?
                }
                let artwork: Artwork?
                struct PreviewAsset: Decodable {
                    let url: String
                }
                let previews: [PreviewAsset]?
            }
            let attributes: Attributes?
        }

        struct ResponseWrapper: Decodable {
            let data: [SongItem]?
        }

        guard let decoded = try? JSONDecoder().decode(ResponseWrapper.self, from: data),
              let list = decoded.data else {
            return []
        }

        return list.compactMap { item in
            guard let attr = item.attributes else { return nil }

            var artURL: URL?
            if let rawArt = attr.artwork?.url {
                let formatted = rawArt
                    .replacingOccurrences(of: "{w}", with: "600")
                    .replacingOccurrences(of: "{h}", with: "600")
                    .replacingOccurrences(of: "{f}", with: "jpg")
                artURL = URL(string: formatted)
            }

            var preview: URL?
            if let rawPreview = attr.previews?.first?.url {
                preview = URL(string: rawPreview)
            }

            let appleMusic: URL? = attr.url != nil ? URL(string: attr.url!) : nil
            let isExp = attr.contentRating == "explicit"

            return TrackItem(
                id: item.id,
                title: attr.name,
                artistName: attr.artistName,
                artistId: attr.artistName,
                albumTitle: attr.albumName,
                genreNames: attr.genreNames ?? [],
                duration: attr.durationInMillis != nil ? Double(attr.durationInMillis!) / 1000.0 : 180,
                isExplicit: isExp,
                artworkURL: artURL,
                artworkBackgroundColorHex: attr.artwork?.bgColor,
                previewURL: preview,
                appleMusicURL: appleMusic,
                recommendationReason: defaultReason
            )
        }
    }
}
