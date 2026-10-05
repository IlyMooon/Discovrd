import Foundation
import Observation

/// État d'abonnement Apple Music de l'utilisateur.
public enum SubscriptionStatus: Equatable, Sendable {
    case checking
    case subscribed
    case notSubscribed(isDegradedMode: Bool)
    case error(String)
}

/// État d'autorisation d'accès à Apple Music.
public enum MusicAuthStatus: Equatable, Sendable {
    case notDetermined
    case authorized
    case denied
    case restricted
}

/// Service d'interaction avec le catalogue et la bibliothèque Apple Music.
public protocol MusicServiceProtocol: Sendable {
    func requestAuthorization() async -> MusicAuthStatus
    func checkSubscription() async -> SubscriptionStatus
    func fetchStorefront() async throws -> String
    func fetchLibrarySongIDs() async throws -> Set<String>
    func fetchLibraryArtists() async throws -> [(id: String, name: String)]
    func fetchListeningHistory() async throws -> [PlayHistoryItem]
    func fetchSimilarArtists(artistID: String, storefront: String) async throws -> [(id: String, name: String)]
    func fetchTopSongs(artistID: String, storefront: String) async throws -> [TrackItem]
    func fetchRecentReleases(artistIDs: [String], storefront: String) async throws -> [TrackItem]
    func addSongToDiscovrdPlaylist(songID: String, alsoAddToLibrary: Bool) async throws
}

/// Service de profilage musical et de gestion de cache.
public protocol TasteProfileServiceProtocol: Sendable {
    func getOrComputeProfile(forceRefresh: Bool) async throws -> TasteProfile
}

/// Magasin d'enregistrement et de requêtage des swipes de l'utilisateur.
public protocol SwipeStoreProtocol: Sendable {
    func recordSwipe(songID: String, artistID: String, direction: SwipeDirection, source: SwipeSource) async throws
    func removeLastSwipe() async throws -> SwipeRecord?
    func fetchSwipedSongIDs() async throws -> Set<String>
    func resetHistory() async throws
}
