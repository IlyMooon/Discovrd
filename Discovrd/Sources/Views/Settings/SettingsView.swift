import SwiftUI

/// Écran des réglages en Form système moderne avec gestion des préférences et réinitialisation des données locales.
public struct SettingsView: View {
    @Bindable var settings = AppSettings.shared
    public let swipeStore: SwipeStoreProtocol

    @State private var showResetConfirmation = false
    @State private var resetSuccessMessage: String?

    public init(swipeStore: SwipeStoreProtocol) {
        self.swipeStore = swipeStore
    }

    public var body: some View {
        NavigationStack {
            Form {
                Section("Ajout de morceaux") {
                    Toggle("Ajouter aussi à la bibliothèque", isOn: $settings.alsoAddToLibrary)
                    Text("Par défaut, les morceaux aimés sont ajoutés à votre playlist Discovrd dans Apple Music.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Section("Filtres & Préférences") {
                    Toggle("Autoriser le contenu explicite", isOn: $settings.allowExplicitContent)
                    Toggle("Lecture automatique des extraits", isOn: $settings.autoplayPreviews)
                }

                Section("Données & Historique") {
                    Button(role: .destructive) {
                        showResetConfirmation = true
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("Réinitialiser l'historique de swipes")
                        }
                    }

                    if let message = resetSuccessMessage {
                        Text(message)
                            .font(.caption)
                            .foregroundStyle(.green)
                    }
                }

                Section("À propos de Discovrd") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0 (1)")
                            .foregroundStyle(.secondary)
                    }

                    HStack {
                        Text("Confidentialité")
                        Spacer()
                        Text("100% sur l'appareil")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Réglages")
            .confirmationDialog(
                "Réinitialiser l'historique de swipes ?",
                isPresented: $showResetConfirmation,
                titleVisibility: .visible
            ) {
                Button("Réinitialiser tout l'historique", role: .destructive) {
                    Task {
                        try? await swipeStore.resetHistory()
                        resetSuccessMessage = "Historique réinitialisé avec succès."
                    }
                }
                Button("Annuler", role: .cancel) {}
            } message: {
                Text("Les morceaux passés pourront de nouveau vous être suggérés lors des prochaines sessions.")
            }
        }
    }
}
