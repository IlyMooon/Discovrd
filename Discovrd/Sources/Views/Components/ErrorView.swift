import SwiftUI

/// Vue d'erreur réseau avec bouton Réessayer.
public struct ErrorView: View {
    public let message: String
    public let onRetry: () -> Void

    public init(message: String, onRetry: @escaping () -> Void) {
        self.message = message
        self.onRetry = onRetry
    }

    public var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 56, weight: .light))
                .foregroundStyle(.orange)
                .padding(24)
                .background(
                    Circle()
                        .glassEffect(Glass.regular.tint(Color.orange.opacity(0.15)), in: .circle)
                )

            VStack(spacing: 8) {
                Text("Connexion interrompue")
                    .font(.title3.weight(.bold))

                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            Button(action: onRetry) {
                Label("Réessayer", systemImage: "arrow.clockwise")
                    .font(.headline)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.glass)
        }
        .padding(32)
    }
}
