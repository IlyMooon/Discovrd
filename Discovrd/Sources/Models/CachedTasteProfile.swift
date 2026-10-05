import Foundation
import SwiftData

/// Entité persistante stockant en cache le profil de goûts de l'utilisateur.
@Model
public final class CachedTasteProfile {
    @Attribute(.unique) public var id: String
    public var lastUpdated: Date
    public var expirationDate: Date
    public var rawArtistScoresData: Data
    public var rawGenreScoresData: Data
    public var topArtistIDs: [String]

    public init(
        id: String = "primary_profile",
        lastUpdated: Date = Date(),
        expirationDate: Date = Calendar.current.date(byAdding: .hour, value: 12, to: Date()) ?? Date(),
        artistScores: [String: Double] = [:],
        genreScores: [String: Double] = [:],
        topArtistIDs: [String] = []
    ) {
        self.id = id
        self.lastUpdated = lastUpdated
        self.expirationDate = expirationDate
        self.topArtistIDs = topArtistIDs
        self.rawArtistScoresData = (try? JSONEncoder().encode(artistScores)) ?? Data()
        self.rawGenreScoresData = (try? JSONEncoder().encode(genreScores)) ?? Data()
    }

    public var artistScores: [String: Double] {
        get {
            guard !rawArtistScoresData.isEmpty else { return [:] }
            return (try? JSONDecoder().decode([String: Double].self, from: rawArtistScoresData)) ?? [:]
        }
        set {
            rawArtistScoresData = (try? JSONEncoder().encode(newValue)) ?? Data()
        }
    }

    public var genreScores: [String: Double] {
        get {
            guard !rawGenreScoresData.isEmpty else { return [:] }
            return (try? JSONDecoder().decode([String: Double].self, from: rawGenreScoresData)) ?? [:]
        }
        set {
            rawGenreScoresData = (try? JSONEncoder().encode(newValue)) ?? Data()
        }
    }

    public var isExpired: Bool {
        Date() > expirationDate
    }
}
