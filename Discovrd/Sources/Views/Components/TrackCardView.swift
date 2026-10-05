import SwiftUI

/// Carte individuelle de la pile de swipe avec pochette complète et panneau d'informations en verre.
public struct TrackCardView: View {
    public let track: TrackItem
    public let isTopCard: Bool
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    public init(track: TrackItem, isTopCard: Bool) {
        self.track = track
        self.isTopCard = isTopCard
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                // Pochette d'album
                artworkView(size: geometry.size)

                // Panneau d'informations en Liquid Glass (uniquement sur la carte du dessus pour la performance)
                if isTopCard {
                    infoGlassPanel
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
                } else {
                    simplifiedInfoPanel
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
            .shadow(color: Color.black.opacity(0.18), radius: 24, x: 0, y: 12)
            .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 2)
        }
    }

    @ViewBuilder
    private func artworkView(size: CGSize) -> some View {
        if let url = track.artworkURL {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(Color(uiColor: .secondarySystemBackground))
                        .overlay(ProgressView())
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .clipped()
                case .failure:
                    placeholderArtwork
                @unknown default:
                    placeholderArtwork
                }
            }
        } else {
            placeholderArtwork
        }
    }

    private var placeholderArtwork: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [
                        Color(hex: track.artworkBackgroundColorHex ?? "#1E1B4B") ?? .purple,
                        Color.black.opacity(0.8)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                Image(systemName: "music.note")
                    .font(.system(size: 64, weight: .light))
                    .foregroundStyle(.white.opacity(0.4))
            )
    }

    private var infoGlassPanel: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Libellé de recommandation "Parce que tu écoutes..."
            HStack(spacing: 6) {
                Image(systemName: "sparkles")
                    .font(.caption2.weight(.semibold))
                Text(track.recommendationReason)
                    .font(.caption.weight(.medium))
                    .lineLimit(1)
            }
            .foregroundStyle(.white.opacity(0.9))
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(Color.black.opacity(0.35))
            )

            // Titre & Artiste
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text(track.title)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.white)
                        .lineLimit(1)

                    if track.isExplicit {
                        Image(systemName: "e.square.fill")
                            .font(.caption2)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                }

                Text(track.artistName)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.85))
                    .lineLimit(1)

                if let album = track.albumTitle, !album.isEmpty {
                    Text(album)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.65))
                        .lineLimit(1)
                }
            }

            // Genres et bouton d'écoute Apple Music
            HStack {
                if let genre = track.genreNames.first {
                    Text(genre)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.white.opacity(0.8))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Capsule().fill(Color.white.opacity(0.15)))
                }

                Spacer()

                if let appleMusicURL = track.appleMusicURL {
                    Link(destination: appleMusicURL) {
                        HStack(spacing: 4) {
                            Text("Ouvrir")
                                .font(.caption.weight(.semibold))
                            Image(systemName: "arrow.up.right")
                                .font(.caption2)
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.2))
                        )
                    }
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            ZStack {
                if reduceTransparency {
                    Color.black.opacity(0.85)
                } else {
                    Color.clear
                        .glassEffect(.regular, in: .rect(cornerRadius: 24))
                }
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(track.title) par \(track.artistName). \(track.recommendationReason)")
    }

    private var simplifiedInfoPanel: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(track.title)
                .font(.headline.weight(.bold))
                .foregroundStyle(.white)
                .lineLimit(1)
            Text(track.artistName)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.8))
                .lineLimit(1)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.black.opacity(0.65))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}
