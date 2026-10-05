import Foundation

/// Exécuteur autonome de tests unitaires pour valider la logique pure sans dépendance au harness Xcode.
@main
struct TestRunner {
    static func main() async {
        print("▶️ [TEST SUITE] Démarrage des tests unitaires de logique pure...")

        var passed = 0
        var failed = 0

        func assertCondition(_ condition: Bool, _ name: String) {
            if condition {
                print("  ✅ [PASS] \(name)")
                passed += 1
            } else {
                print("  ❌ [FAIL] \(name)")
                failed += 1
            }
        }

        // 1. Tests de TasteProfileEngine
        print("\n--- Test Suite: TasteProfileEngine ---")
        let emptyProfile = TasteProfileEngine.computeProfile(historyItems: [])
        assertCondition(emptyProfile.artistScores.isEmpty, "Profil vide: scores artistes vides")
        assertCondition(emptyProfile.genreScores.isEmpty, "Profil vide: scores genres vides")
        assertCondition(emptyProfile.topArtistIDs.isEmpty, "Profil vide: liste top artistes vide")

        let now = Date()
        let items = [
            PlayHistoryItem(songID: "s1", artistID: "artist_recent", genreNames: ["Electro", "House"], playCount: 10, lastPlayedDate: now),
            PlayHistoryItem(songID: "s2", artistID: "artist_old", genreNames: ["Rock"], playCount: 10, lastPlayedDate: now.addingTimeInterval(-86400 * 60))
        ]
        let scoredProfile = TasteProfileEngine.computeProfile(historyItems: items, referenceDate: now)
        let recentScore = scoredProfile.artistScores["artist_recent"] ?? 0
        let oldScore = scoredProfile.artistScores["artist_old"] ?? 0
        assertCondition(recentScore > oldScore, "Pondération récence: artist_recent (\(recentScore)) > artist_old (\(oldScore))")
        assertCondition(scoredProfile.topArtistIDs.first == "artist_recent", "Top artiste: premier est bien artist_recent")
        assertCondition((scoredProfile.genreScores["Electro"] ?? 0) > (scoredProfile.genreScores["Rock"] ?? 0), "Genre score: Electro > Rock")

        // 2. Tests de DeckAlgorithm (filtrage)
        print("\n--- Test Suite: DeckAlgorithm - Filtrage ---")
        let candidate1 = TrackItem(id: "s1", title: "Song 1", artistName: "A1", artistId: "a1", isExplicit: false)
        let candidate2 = TrackItem(id: "s2", title: "Song 2", artistName: "A2", artistId: "a2", isExplicit: false)
        let candidate3 = TrackItem(id: "s3", title: "Song 3", artistName: "A3", artistId: "a3", isExplicit: true)
        let candidateDupe = TrackItem(id: "s1", title: "Song 1 Dupe", artistName: "A1", artistId: "a1", isExplicit: false)

        let libraryIDs: Set<String> = ["s2"]
        let swipedIDs: Set<String> = ["s4"]

        let filteredNoExp = DeckAlgorithm.filterCandidates(
            candidates: [candidate1, candidate2, candidate3, candidateDupe],
            librarySongIDs: libraryIDs,
            swipedSongIDs: swipedIDs,
            allowExplicit: false
        )
        assertCondition(filteredNoExp.count == 1 && filteredNoExp.first?.id == "s1", "Filtrage sans explicite: seul s1 conservé (doublons et bibliothèque éliminés)")

        let filteredWithExp = DeckAlgorithm.filterCandidates(
            candidates: [candidate1, candidate2, candidate3, candidateDupe],
            librarySongIDs: libraryIDs,
            swipedSongIDs: swipedIDs,
            allowExplicit: true
        )
        assertCondition(filteredWithExp.count == 2 && filteredWithExp.map(\.id) == ["s1", "s3"], "Filtrage avec explicite: s1 et s3 conservés")

        // 3. Tests de DeckAlgorithm (diversité)
        print("\n--- Test Suite: DeckAlgorithm - Diversité Artistes ---")
        let t1 = TrackItem(id: "1", title: "T1", artistName: "Artist A", artistId: "art_A")
        let t2 = TrackItem(id: "2", title: "T2", artistName: "Artist A", artistId: "art_A")
        let t3 = TrackItem(id: "3", title: "T3", artistName: "Artist A", artistId: "art_A")
        let t4 = TrackItem(id: "4", title: "T4", artistName: "Artist B", artistId: "art_B")
        let t5 = TrackItem(id: "5", title: "T5", artistName: "Artist A", artistId: "art_A")

        let diversified = DeckAlgorithm.enforceArtistDiversity(tracks: [t1, t2, t3, t4, t5], maxConsecutive: 2)
        var maxConsecutiveObserved = 0
        var currentRun = 0
        var lastArt: String? = nil

        for t in diversified {
            if t.artistId == lastArt {
                currentRun += 1
            } else {
                currentRun = 1
                lastArt = t.artistId
            }
            maxConsecutiveObserved = max(maxConsecutiveObserved, currentRun)
        }
        assertCondition(maxConsecutiveObserved <= 2, "Diversité d'artiste: jamais plus de 2 consécutifs (observé: \(maxConsecutiveObserved))")

        // 4. Tests de Flux MyArtistsViewModel
        print("\n--- Test Suite: MyArtistsViewModel & Undo ---")
        let mockMusic = MockMusicService()
        let store = MockSwipeStore()
        let viewModel = await MyArtistsViewModel(musicService: mockMusic, swipeStore: store)
        await viewModel.loadInitialDeck()
        let deckNotEmpty = await !viewModel.deckTracks.isEmpty
        assertCondition(deckNotEmpty, "Chargement initial du deck: non vide")

        if let first = await viewModel.deckTracks.first {
            let initialCount = await viewModel.deckTracks.count
            await viewModel.handleSwipe(track: first, direction: .like)
            let countAfterSwipe = await viewModel.deckTracks.count
            let canUndoAfterSwipe = await viewModel.canUndo
            assertCondition(countAfterSwipe == initialCount - 1, "Swipe: suppression de la carte courante")
            assertCondition(canUndoAfterSwipe == true, "Swipe: canUndo est activé")

            await viewModel.undoLastSwipe()
            let canUndoAfterUndo = await viewModel.canUndo
            assertCondition(canUndoAfterUndo == false, "Undo: canUndo repasse à false après annulation")
        }

        print("\n==========================================")
        print("RÉSULTAT: \(passed) succès, \(failed) échecs.")
        if failed > 0 {
            exit(1)
        }
    }
}
