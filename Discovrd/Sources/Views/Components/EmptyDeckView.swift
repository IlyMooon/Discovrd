import SwiftUI

/// Vue d'état vide affichée lorsque toutes les recommandations ont été consultées.
public struct EmptyDeckView: View {
    public let title: String
    public let message: String
    public let buttonTitle: String
    public let onRefresh: () -> Void

    public init(
        title: String = "Plus aucun morceau pour le moment",
        message: String = "Reviens un peu plus tard ou écoute de nouveaux titres pour enrichir ton profil.",
        buttonTitle: String = "Actualiser",
        onRefresh: @escaping () -> Void
    ) {
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.onRefresh = onRefresh
    }

    public var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "music.note.list")
                .font(.system(size: 64, weight: .light))
                .foregroundStyle(Color.accentColor)
                .padding(28)
                .background(
                    Circle()
                        .glassEffect(.regular, in: .circle)
                )

            VStack(spacing: 8) {
                Text(title)
                    .font(.title3.weight(.bold))
                    .multilineTextAlignment(.center)

                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            Button(action: onRefresh) {
                Label(buttonTitle, systemImage: "arrow.clockwise")
                    .font(.headline)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.glassProminent)
        }
        .padding(32)
    }
}
