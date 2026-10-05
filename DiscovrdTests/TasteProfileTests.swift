import XCTest
import Foundation

final class TasteProfileTests: XCTestCase {
    func testEmptyHistory() {
        let profile = TasteProfileEngine.computeProfile(historyItems: [])
        XCTAssertTrue(profile.artistScores.isEmpty)
        XCTAssertTrue(profile.genreScores.isEmpty)
        XCTAssertTrue(profile.topArtistIDs.isEmpty)
    }

    func testScoringWithRecency() {
        let now = Date()
        let items = [
            PlayHistoryItem(
                songID: "s1",
                artistID: "artist_recent",
                genreNames: ["Electro", "House"],
                playCount: 10,
                lastPlayedDate: now
            ),
            PlayHistoryItem(
                songID: "s2",
                artistID: "artist_old",
                genreNames: ["Rock"],
                playCount: 10,
                lastPlayedDate: now.addingTimeInterval(-86400 * 60)
            )
        ]

        let profile = TasteProfileEngine.computeProfile(historyItems: items, referenceDate: now)

        let recentScore = profile.artistScores["artist_recent"] ?? 0
        let oldScore = profile.artistScores["artist_old"] ?? 0

        XCTAssertGreaterThan(recentScore, oldScore)
        XCTAssertEqual(profile.topArtistIDs.first, "artist_recent")
        XCTAssertGreaterThan(profile.genreScores["Electro"] ?? 0, profile.genreScores["Rock"] ?? 0)
    }
}
