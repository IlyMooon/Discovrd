import SwiftUI

/// Écran d'accueil invitant l'utilisateur à autoriser l'accès à Apple Music ou redirigeant vers Réglages en cas de refus.
public struct AuthorizationPromptView: View {
    public let authStatus: MusicAuthStatus
    public let onRequestAuth: () -> Void

    public init(authStatus: MusicAuthStatus, onRequestAuth: @escaping () -> Void) {
        self.authStatus = authStatus
        self.onRequestAuth = onRequestAuth
    }

    public var body: some View {
        ZStack {
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 28) {
                Spacer()

                Image(systemName: authStatus == .denied ? "lock.slash" : "apple.logo")
                    .font(.system(size: 64, weight: .light))
                    .foregroundStyle(Color.accentColor)
                    .frame(width: 110, height: 110)
                    .background(
                        Circle()
                            .glassEffect(.regular, in: .circle)
                    )

                VStack(spacing: 12) {
                    Text(authStatus == .denied ? "Accès refusé" : "Connexion à Apple Music")
                        .font(.title2.weight(.bold))
                        .multilineTextAlignment(.center)

                    Text(
                        authStatus == .denied
                            ? "Discovrd a besoin d'accéder à votre bibliothèque Apple Music pour recommander des titres. Vous pouvez activer l'accès dans les Réglages iOS."
                            : "Pour vous proposer une sélection personnalisée et enregistrer vos morceaux préférés, autorisez l'accès à Apple Music."
                    )
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28)
                }

                Spacer()

                if authStatus == .denied {
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        Link(destination: settingsURL) {
                            Text("Ouvrir les Réglages")
                                .font(.headline.weight(.semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                        }
                        .buttonStyle(.glassProminent)
                        .padding(.horizontal, 32)
                    }
                } else {
                    Button(action: onRequestAuth) {
                        Text("Connecter Apple Music")
                            .font(.headline.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                    }
                    .buttonStyle(.glassProminent)
                    .padding(.horizontal, 32)
                }

                Text("Aucune donnée personnelle n'est collectée.")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 24)
            }
        }
    }
}
