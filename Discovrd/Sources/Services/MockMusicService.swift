import Foundation

/// Implémentation Mock complète et déterministe de MusicServiceProtocol pour les tests et SwiftUI Previews.
public final class MockMusicService: MusicServiceProtocol, @unchecked Sendable {
    public var authStatusToReturn: MusicAuthStatus
    public var subscriptionStatusToReturn: SubscriptionStatus
    public var mockTracks: [TrackItem]
    public var mockArtists: [(id: String, name: String)]
    public var mockLibrarySongIDs: Set<String>
    public var addedToPlaylistCount = 0
    public var addedToLibraryCount = 0

    public init(
        authStatus: MusicAuthStatus = .authorized,
        subscriptionStatus: SubscriptionStatus = .subscribed,
        mockTracks: [TrackItem] = MockMusicService.sampleTracks,
        mockArtists: [(id: String, name: String)] = [
            ("art_1", "Daft Punk"),
            ("art_2", "Phoenix"),
            ("art_3", "Justice"),
            ("art_4", "Kavinsky")
        ],
        mockLibrarySongIDs: Set<String> = ["lib_song_1", "lib_song_2"]
    ) {
        self.authStatusToReturn = authStatus
        self.subscriptionStatusToReturn = subscriptionStatus
        self.mockTracks = mockTracks
        self.mockArtists = mockArtists
        self.mockLibrarySongIDs = mockLibrarySongIDs
    }

    public func requestAuthorization() async -> MusicAuthStatus {
        return authStatusToReturn
    }

    public func checkSubscription() async -> SubscriptionStatus {
        return subscriptionStatusToReturn
    }

    public func fetchStorefront() async throws -> String {
        return "fr"
    }

    public func fetchLibrarySongIDs() async throws -> Set<String> {
        return mockLibrarySongIDs
    }

    public func fetchLibraryArtists() async throws -> [(id: String, name: String)] {
        return mockArtists
    }

    public func fetchListeningHistory() async throws -> [PlayHistoryItem] {
        return [
            PlayHistoryItem(songID: "song_h1", artistID: "art_1", genreNames: ["Électronique", "French Touch"], playCount: 42, lastPlayedDate: Date()),
            PlayHistoryItem(songID: "song_h2", artistID: "art_2", genreNames: ["Indie Pop", "Rock"], playCount: 28, lastPlayedDate: Date().addingTimeInterval(-86400 * 3)),
            PlayHistoryItem(songID: "song_h3", artistID: "art_3", genreNames: ["Électronique"], playCount: 15, lastPlayedDate: Date().addingTimeInterval(-86400 * 10))
        ]
    }

    public func fetchSimilarArtists(artistID: String, storefront: String) async throws -> [(id: String, name: String)] {
        return [
            ("art_sim_1", "Breakbot"),
            ("art_sim_2", "Cassius"),
            ("art_sim_3", "SebastiAn")
        ]
    }

    public func fetchTopSongs(artistID: String, storefront: String) async throws -> [TrackItem] {
        return mockTracks.filter { $0.artistId == artistID || artistID.hasPrefix("art_sim") }
    }

    public func fetchRecentReleases(artistIDs: [String], storefront: String) async throws -> [TrackItem] {
        return mockTracks
    }

    public func addSongToDiscovrdPlaylist(songID: String, alsoAddToLibrary: Bool) async throws {
        addedToPlaylistCount += 1
        if alsoAddToLibrary {
            addedToLibraryCount += 1
        }
    }

    public static let sampleTracks: [TrackItem] = [
        TrackItem(
            id: "track_1",
            title: "Instant Crush",
            artistName: "Daft Punk ft. Julian Casablancas",
            artistId: "art_1",
            albumTitle: "Random Access Memories",
            genreNames: ["French Touch", "Électronique"],
            releaseDate: Date(),
            duration: 337,
            isExplicit: false,
            artworkURL: URL(string: "https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=600"),
            artworkBackgroundColorHex: "#1C1427",
            previewURL: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/sample.m4a"),
            appleMusicURL: URL(string: "https://music.apple.com"),
            recommendationReason: "Parce que tu écoutes Phoenix"
        ),
        TrackItem(
            id: "track_2",
            title: "1901",
            artistName: "Phoenix",
            artistId: "art_2",
            albumTitle: "Wolfgang Amadeus Phoenix",
            genreNames: ["Indie Pop", "Rock"],
            releaseDate: Date().addingTimeInterval(-86400 * 120),
            duration: 193,
            isExplicit: false,
            artworkURL: URL(string: "https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=600"),
            artworkBackgroundColorHex: "#0D2538",
            previewURL: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/sample.m4a"),
            appleMusicURL: URL(string: "https://music.apple.com"),
            recommendationReason: "Nouveauté de tes artistes"
        ),
        TrackItem(
            id: "track_3",
            title: "Genesis",
            artistName: "Justice",
            artistId: "art_3",
            albumTitle: "Cross",
            genreNames: ["Électronique", "Dance"],
            releaseDate: Date().addingTimeInterval(-86400 * 50),
            duration: 234,
            isExplicit: false,
            artworkURL: URL(string: "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=600"),
            artworkBackgroundColorHex: "#221105",
            previewURL: nil,
            appleMusicURL: URL(string: "https://music.apple.com"),
            recommendationReason: "Parce que tu écoutes Daft Punk"
        ),
        TrackItem(
            id: "track_4",
            title: "Nightcall",
            artistName: "Kavinsky",
            artistId: "art_4",
            albumTitle: "OutRun",
            genreNames: ["Synthwave", "Électronique"],
            releaseDate: Date().addingTimeInterval(-86400 * 200),
            duration: 259,
            isExplicit: false,
            artworkURL: URL(string: "https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=600"),
            artworkBackgroundColorHex: "#120B2E",
            previewURL: nil,
            appleMusicURL: URL(string: "https://music.apple.com"),
            recommendationReason: "Parce que tu aimes la Synthwave"
        )
    ]
}
