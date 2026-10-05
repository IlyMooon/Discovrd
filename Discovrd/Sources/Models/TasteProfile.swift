import Foundation

/// Profil de goûts calculé de façon pure à partir des activités de l'utilisateur.
public struct TasteProfile: Equatable, Sendable {
    public let artistScores: [String: Double]
    public let genreScores: [String: Double]
    public let topArtistIDs: [String]
    public let calculatedAt: Date

    public init(
        artistScores: [String: Double] = [:],
        genreScores: [String: Double] = [:],
        topArtistIDs: [String] = [],
        calculatedAt: Date = Date()
    ) {
        self.artistScores = artistScores
        self.genreScores = genreScores
        self.topArtistIDs = topArtistIDs
        self.calculatedAt = calculatedAt
    }
}

/// Donnée d'entrée standardisée pour l'analyse d'écoute.
public struct PlayHistoryItem: Sendable {
    public let songID: String
    public let artistID: String
    public let genreNames: [String]
    public let playCount: Int
    public let lastPlayedDate: Date?

    public init(
        songID: String,
        artistID: String,
        genreNames: [String] = [],
        playCount: Int = 1,
        lastPlayedDate: Date? = nil
    ) {
        self.songID = songID
        self.artistID = artistID
        self.genreNames = genreNames
        self.playCount = max(1, playCount)
        self.lastPlayedDate = lastPlayedDate
    }
}

/// Moteur de calcul pur pour déterminer les affinités musicales.
public enum TasteProfileEngine {
    /// Calcule un profil de goûts pondéré par la fréquence d'écoute et la récence temporelle.
    public static func computeProfile(
        historyItems: [PlayHistoryItem],
        referenceDate: Date = Date()
    ) -> TasteProfile {
        guard !historyItems.isEmpty else {
            return TasteProfile(calculatedAt: referenceDate)
        }

        var artistWeights: [String: Double] = [:]
        var genreWeights: [String: Double] = [:]

        for item in historyItems {
            var recencyMultiplier = 1.0
            if let lastPlayed = item.lastPlayedDate {
                let daysAgo = max(0.0, referenceDate.timeIntervalSince(lastPlayed) / 86400.0)
                // Décroissance exponentielle douce : score x0.5 au bout de 30 jours
                recencyMultiplier = exp(-0.023 * daysAgo)
            }

            let itemScore = Double(item.playCount) * recencyMultiplier
            artistWeights[item.artistID, default: 0.0] += itemScore

            for genre in item.genreNames where !genre.isEmpty {
                genreWeights[genre, default: 0.0] += itemScore
            }
        }

        // Tri des artistes par score décroissant
        let sortedArtists = artistWeights.sorted { $0.value > $1.value }
        let topIDs = sortedArtists.map(\.key)

        return TasteProfile(
            artistScores: artistWeights,
            genreScores: genreWeights,
            topArtistIDs: topIDs,
            calculatedAt: referenceDate
        )
    }
}
