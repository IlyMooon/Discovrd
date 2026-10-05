import Foundation

/// Magasin de test en mémoire pour SwipeStoreProtocol réutilisable dans les Previews et Tests.
public final class MockSwipeStore: SwipeStoreProtocol, @unchecked Sendable {
    private var records: [SwipeRecord] = []
    private var last: (songID: String, artistID: String, direction: SwipeDirection, source: SwipeSource)?

    public init() {}

    public func recordSwipe(songID: String, artistID: String, direction: SwipeDirection, source: SwipeSource) async throws {
        last = (songID, artistID, direction, source)
    }

    public func removeLastSwipe() async throws -> SwipeRecord? {
        guard let l = last else { return nil }
        last = nil
        return SwipeRecord(songID: l.songID, artistID: l.artistID, direction: l.direction, source: l.source)
    }

    public func fetchSwipedSongIDs() async throws -> Set<String> {
        return Set(records.map(\.songID))
    }

    public func resetHistory() async throws {
        records.removeAll()
        last = nil
    }
}
