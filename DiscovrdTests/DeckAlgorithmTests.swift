import XCTest
import Foundation

final class DeckAlgorithmTests: XCTestCase {
    func testCandidateFiltering() {
        let candidate1 = TrackItem(id: "s1", title: "Song 1", artistName: "A1", artistId: "a1", isExplicit: false)
        let candidate2 = TrackItem(id: "s2", title: "Song 2", artistName: "A2", artistId: "a2", isExplicit: false)
        let candidate3 = TrackItem(id: "s3", title: "Song 3", artistName: "A3", artistId: "a3", isExplicit: true)
        let candidateDupe = TrackItem(id: "s1", title: "Song 1 Dupe", artistName: "A1", artistId: "a1", isExplicit: false)

        let libraryIDs: Set<String> = ["s2"]
        let swipedIDs: Set<String> = ["s4"]

        // 1. Sans explicite
        let filteredNoExplicit = DeckAlgorithm.filterCandidates(
            candidates: [candidate1, candidate2, candidate3, candidateDupe],
            librarySongIDs: libraryIDs,
            swipedSongIDs: swipedIDs,
            allowExplicit: false
        )

        XCTAssertEqual(filteredNoExplicit.count, 1)
        XCTAssertEqual(filteredNoExplicit.first?.id, "s1")

        // 2. Avec explicite
        let filteredWithExplicit = DeckAlgorithm.filterCandidates(
            candidates: [candidate1, candidate2, candidate3, candidateDupe],
            librarySongIDs: libraryIDs,
            swipedSongIDs: swipedIDs,
            allowExplicit: true
        )

        XCTAssertEqual(filteredWithExplicit.count, 2)
        XCTAssertEqual(filteredWithExplicit.map(\.id), ["s1", "s3"])
    }

    func testArtistDiversity() {
        let t1 = TrackItem(id: "1", title: "T1", artistName: "Artist A", artistId: "art_A")
        let t2 = TrackItem(id: "2", title: "T2", artistName: "Artist A", artistId: "art_A")
        let t3 = TrackItem(id: "3", title: "T3", artistName: "Artist A", artistId: "art_A")
        let t4 = TrackItem(id: "4", title: "T4", artistName: "Artist B", artistId: "art_B")
        let t5 = TrackItem(id: "5", title: "T5", artistName: "Artist A", artistId: "art_A")

        let diversified = DeckAlgorithm.enforceArtistDiversity(tracks: [t1, t2, t3, t4, t5], maxConsecutive: 2)

        var consecutiveCount = 0
        var lastArtistId: String? = nil

        for track in diversified {
            if track.artistId == lastArtistId {
                consecutiveCount += 1
            } else {
                consecutiveCount = 1
                lastArtistId = track.artistId
            }
            XCTAssertLessThanOrEqual(consecutiveCount, 2)
        }
    }
}
