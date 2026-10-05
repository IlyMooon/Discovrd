import SwiftUI

/// Composant de fond ambiant immersif dérivé de la pochette du morceau courant.
/// Crée la profondeur requise pour faire ressortir l'effet de réfraction Liquid Glass.
public struct AmbientArtworkBackground: View {
    public let track: TrackItem?
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    public init(track: TrackItem?) {
        self.track = track
    }

    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                // Fond par défaut
                Color(uiColor: .systemBackground)
                    .ignoresSafeArea()

                if let track = track, !reduceTransparency {
                    ZStack {
                        if let hex = track.artworkBackgroundColorHex, let color = Color(hex: hex) {
                            color
                                .opacity(0.4)
                                .ignoresSafeArea()
                        }

                        // Gradient dynamique Mesh-like
                        RadialGradient(
                            gradient: Gradient(colors: [
                                (Color(hex: track.artworkBackgroundColorHex ?? "#9933FF") ?? .purple).opacity(0.45),
                                (Color(hex: track.artworkBackgroundColorHex ?? "#0066FF") ?? .blue).opacity(0.2),
                                Color.clear
                            ]),
                            center: .topLeading,
                            startRadius: 40,
                            endRadius: proxy.size.width * 1.2
                        )
                        .ignoresSafeArea()

                        RadialGradient(
                            gradient: Gradient(colors: [
                                (Color(hex: track.artworkBackgroundColorHex ?? "#FF3366") ?? .pink).opacity(0.35),
                                Color.clear
                            ]),
                            center: .bottomTrailing,
                            startRadius: 60,
                            endRadius: proxy.size.height * 0.9
                        )
                        .ignoresSafeArea()
                    }
                    .blur(radius: 50)
                    .transition(reduceMotion ? .opacity : .opacity.combined(with: .scale(scale: 1.05)))
                }
            }
            .animation(.easeInOut(duration: 0.8), value: track?.id)
        }
    }
}

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        let r, g, b: Double
        if hexSanitized.count == 6 {
            r = Double((rgb & 0xFF0000) >> 16) / 255.0
            g = Double((rgb & 0x00FF00) >> 8) / 255.0
            b = Double(rgb & 0x0000FF) / 255.0
            self.init(.sRGB, red: r, green: g, blue: b, opacity: 1.0)
        } else {
            return nil
        }
    }
}
