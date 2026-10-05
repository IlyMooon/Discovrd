import Foundation
import SwiftData

/// Implémentation du service de profil de goûts avec cache SwiftData de 12 heures.
public final class TasteProfileService: TasteProfileServiceProtocol, @unchecked Sendable {
    private let musicService: MusicServiceProtocol
    private let modelContainer: ModelContainer

    public init(musicService: MusicServiceProtocol, modelContainer: ModelContainer) {
        self.musicService = musicService
        self.modelContainer = modelContainer
    }

    public func getOrComputeProfile(forceRefresh: Bool = false) async throws -> TasteProfile {
        let context = ModelContext(modelContainer)

        if !forceRefresh {
            let descriptor = FetchDescriptor<CachedTasteProfile>(
                predicate: #Predicate { $0.id == "primary_profile" }
            )
            if let cached = try context.fetch(descriptor).first, !cached.isExpired {
                return TasteProfile(
                    artistScores: cached.artistScores,
                    genreScores: cached.genreScores,
                    topArtistIDs: cached.topArtistIDs,
                    calculatedAt: cached.lastUpdated
                )
            }
        }

        // Récupération de l'historique et calcul pur
        let history = try await musicService.fetchListeningHistory()
        let computed = TasteProfileEngine.computeProfile(historyItems: history)

        // Sauvegarde en cache
        let descriptor = FetchDescriptor<CachedTasteProfile>(
            predicate: #Predicate { $0.id == "primary_profile" }
        )
        let existing = try context.fetch(descriptor).first
        if let existing = existing {
            existing.lastUpdated = computed.calculatedAt
            existing.expirationDate = Calendar.current.date(byAdding: .hour, value: 12, to: computed.calculatedAt) ?? computed.calculatedAt
            existing.artistScores = computed.artistScores
            existing.genreScores = computed.genreScores
            existing.topArtistIDs = computed.topArtistIDs
        } else {
            let newCache = CachedTasteProfile(
                id: "primary_profile",
                lastUpdated: computed.calculatedAt,
                expirationDate: Calendar.current.date(byAdding: .hour, value: 12, to: computed.calculatedAt) ?? computed.calculatedAt,
                artistScores: computed.artistScores,
                genreScores: computed.genreScores,
                topArtistIDs: computed.topArtistIDs
            )
            context.insert(newCache)
        }

        try context.save()
        return computed
    }
}
