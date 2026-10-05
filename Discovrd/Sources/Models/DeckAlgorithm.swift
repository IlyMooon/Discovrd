import Foundation

/// Filtre et algorithme pur de composition de la file de cartes.
public enum DeckAlgorithm {
    /// Filtre les morceaux candidats pour exclure ceux déjà présents en bibliothèque ou déjà swipés,
    /// déduplique par ID, et filtre le contenu explicite si requis.
    public static func filterCandidates(
        candidates: [TrackItem],
        librarySongIDs: Set<String>,
        swipedSongIDs: Set<String>,
        allowExplicit: Bool
    ) -> [TrackItem] {
        var seenIDs = Set<String>()
        var filtered: [TrackItem] = []

        for track in candidates {
            // Déduplication intra-lot
            guard !seenIDs.contains(track.id) else { continue }
            // Morceau déjà dans la bibliothèque
            guard !librarySongIDs.contains(track.id) else { continue }
            // Morceau déjà swipé (aimé ou passé)
            guard !swipedSongIDs.contains(track.id) else { continue }
            // Filtre de contenu explicite
            if !allowExplicit && track.isExplicit {
                continue
            }

            seenIDs.insert(track.id)
            filtered.append(track)
        }

        return filtered
    }

    /// Applique la règle de diversité : jamais plus de 2 cartes consécutives du même artiste.
    public static func enforceArtistDiversity(
        tracks: [TrackItem],
        maxConsecutive: Int = 2
    ) -> [TrackItem] {
        guard tracks.count > maxConsecutive else { return tracks }

        var result: [TrackItem] = []
        var pool = tracks

        while !pool.isEmpty {
            // Trouver le premier élément qui ne viole pas la règle des N consécutifs
            let lastArtist = result.last?.artistId
            let countOfLast = result.suffix(maxConsecutive).filter { $0.artistId == lastArtist }.count

            let nextIndex: Int?
            if countOfLast >= maxConsecutive, let lastArtist = lastArtist {
                // Chercher le premier morceau d'un artiste différent
                nextIndex = pool.firstIndex(where: { $0.artistId != lastArtist })
            } else {
                nextIndex = 0
            }

            if let idx = nextIndex {
                let chosen = pool.remove(at: idx)
                result.append(chosen)
            } else {
                // Impossible de diversifier davantage, on vide le reste
                result.append(contentsOf: pool)
                pool.removeAll()
            }
        }

        return result
    }
}
