import Foundation
import SwiftData

/// Implémentation SwiftData du stockage des swipes.
public final class SwiftDataSwipeStore: SwipeStoreProtocol, @unchecked Sendable {
    private let modelContainer: ModelContainer
    private var lastRecordedSwipe: (songID: String, artistID: String, direction: SwipeDirection, source: SwipeSource)?

    public init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }

    public func recordSwipe(
        songID: String,
        artistID: String,
        direction: SwipeDirection,
        source: SwipeSource
    ) async throws {
        lastRecordedSwipe = (songID, artistID, direction, source)
        let context = ModelContext(modelContainer)
        let record = SwipeRecord(
            songID: songID,
            artistID: artistID,
            direction: direction,
            timestamp: Date(),
            source: source
        )
        context.insert(record)
        try context.save()
    }

    public func removeLastSwipe() async throws -> SwipeRecord? {
        guard let last = lastRecordedSwipe else { return nil }
        let context = ModelContext(modelContainer)
        let songID = last.songID
        let descriptor = FetchDescriptor<SwipeRecord>(
            predicate: #Predicate { $0.songID == songID }
        )
        let matches = try context.fetch(descriptor)
        if let match = matches.first {
            context.delete(match)
            try context.save()
            lastRecordedSwipe = nil
            return match
        }
        return nil
    }

    public func fetchSwipedSongIDs() async throws -> Set<String> {
        let context = ModelContext(modelContainer)
        let descriptor = FetchDescriptor<SwipeRecord>()
        let records = try context.fetch(descriptor)
        return Set(records.map(\.songID))
    }

    public func resetHistory() async throws {
        let context = ModelContext(modelContainer)
        let descriptor = FetchDescriptor<SwipeRecord>()
        let records = try context.fetch(descriptor)
        for record in records {
            context.delete(record)
        }
        try context.save()
        lastRecordedSwipe = nil
    }
}
