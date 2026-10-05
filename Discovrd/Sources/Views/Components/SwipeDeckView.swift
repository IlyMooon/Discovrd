import SwiftUI

/// Composant SwipeDeck réutilisable, partagé entre « Découvrir » et « Mes artistes ».
/// Gère la gestuelle de glissement, les animations spring, les tampons, l'audio preview et les boutons.
public struct SwipeDeckView: View {
    public let tracks: [TrackItem]
    public let canUndo: Bool
    public let isLoadingMore: Bool
    public let onSwipe: (TrackItem, SwipeDirection) -> Void
    public let onUndo: () -> Void

    @State private var dragOffset: CGSize = .zero
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init(
        tracks: [TrackItem],
        canUndo: Bool,
        isLoadingMore: Bool,
        onSwipe: @escaping (TrackItem, SwipeDirection) -> Void,
        onUndo: @escaping () -> Void
    ) {
        self.tracks = tracks
        self.canUndo = canUndo
        self.isLoadingMore = isLoadingMore
        self.onSwipe = onSwipe
        self.onUndo = onUndo
    }

    public var body: some View {
        VStack(spacing: 20) {
            ZStack {
                // Cartes empilées en arrière-plan
                ForEach(Array(tracks.prefix(3).enumerated().reversed()), id: \.element.id) { index, track in
                    cardLayer(for: track, at: index)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 20)
            .padding(.top, 12)

            // Barre de contrôles flottants sous la carte
            ActionButtonsBar(
                canUndo: canUndo,
                onPass: {
                    triggerManualSwipe(direction: .pass)
                },
                onUndo: onUndo,
                onLike: {
                    triggerManualSwipe(direction: .like)
                }
            )
            .padding(.bottom, 16)
        }
        .onChange(of: tracks.first?.id) { _, _ in
            if let topTrack = tracks.first {
                AudioPreviewPlayer.shared.play(track: topTrack)
                AudioPreviewPlayer.shared.preloadNextTracks(Array(tracks.dropFirst()))
            } else {
                AudioPreviewPlayer.shared.stop()
            }
        }
        .onAppear {
            if let topTrack = tracks.first {
                AudioPreviewPlayer.shared.play(track: topTrack)
                AudioPreviewPlayer.shared.preloadNextTracks(Array(tracks.dropFirst()))
            }
        }
    }

    @ViewBuilder
    private func cardLayer(for track: TrackItem, at index: Int) -> some View {
        let isTop = index == 0
        let cardScale = 1.0 - (CGFloat(index) * 0.04)
        let yOffset = CGFloat(index) * 14.0

        ZStack(alignment: .top) {
            TrackCardView(track: track, isTopCard: isTop)

            // Tampons d'action sur la carte du dessus
            if isTop && abs(dragOffset.width) > 20 {
                HStack {
                    if dragOffset.width > 0 {
                        SwipeStampView(direction: .like, progress: dragOffset.width / 120.0)
                            .padding(.leading, 24)
                            .padding(.top, 24)
                        Spacer()
                    } else {
                        Spacer()
                        SwipeStampView(direction: .pass, progress: abs(dragOffset.width) / 120.0)
                            .padding(.trailing, 24)
                            .padding(.top, 24)
                    }
                }
            }
        }
        .scaleEffect(isTop ? 1.0 : cardScale)
        .offset(
            x: isTop ? dragOffset.width : 0,
            y: isTop ? dragOffset.height : yOffset
        )
        .rotationEffect(.degrees(isTop ? Double(dragOffset.width / 22.0) : 0))
        .gesture(
            isTop ? dragGesture(for: track) : nil
        )
        .accessibilityAction(named: "J'aime") {
            triggerManualSwipe(direction: .like)
        }
        .accessibilityAction(named: "Passer") {
            triggerManualSwipe(direction: .pass)
        }
    }

    private func dragGesture(for track: TrackItem) -> some Gesture {
        DragGesture()
            .onChanged { value in
                dragOffset = value.translation
            }
            .onEnded { value in
                let swipeThreshold: CGFloat = 130
                if value.translation.width > swipeThreshold {
                    finishSwipe(track: track, direction: .like)
                } else if value.translation.width < -swipeThreshold {
                    finishSwipe(track: track, direction: .pass)
                } else {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        dragOffset = .zero
                    }
                }
            }
    }

    private func triggerManualSwipe(direction: SwipeDirection) {
        guard let topTrack = tracks.first else { return }
        let targetX: CGFloat = direction == .like ? 500 : -500
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            dragOffset = CGSize(width: targetX, height: 20)
        }
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 200_000_000)
            finishSwipe(track: topTrack, direction: direction)
        }
    }

    private func finishSwipe(track: TrackItem, direction: SwipeDirection) {
        dragOffset = .zero
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        onSwipe(track, direction)
    }
}
