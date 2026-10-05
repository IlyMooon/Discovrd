import XCTest
import Foundation

final class DeckFlowTests: XCTestCase {
    @MainActor
    func testUndoFlow() async {
        let mockMusic = MockMusicService()
        let store = MockSwipeStore()
        let viewModel = MyArtistsViewModel(musicService: mockMusic, swipeStore: store)

        await viewModel.loadInitialDeck()
        XCTAssertFalse(viewModel.deckTracks.isEmpty)

        guard let firstTrack = viewModel.deckTracks.first else { return }
        let initialCount = viewModel.deckTracks.count

        // Exécution d'un swipe
        viewModel.handleSwipe(track: firstTrack, direction: .like)
        XCTAssertEqual(viewModel.deckTracks.count, initialCount - 1)
        XCTAssertTrue(viewModel.canUndo)

        // Annulation immédiate
        viewModel.undoLastSwipe()
        XCTAssertFalse(viewModel.canUndo)
    }
}
