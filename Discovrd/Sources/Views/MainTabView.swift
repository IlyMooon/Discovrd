import SwiftUI

/// Écran principal avec la TabView moderne utilisant l'API Tab d'iOS 26 (laissant le système appliquer le verre à la tab bar).
public struct MainTabView: View {
    public let musicService: MusicServiceProtocol
    public let tasteProfileService: TasteProfileServiceProtocol
    public let swipeStore: SwipeStoreProtocol

    @State private var selectedTab: Int = 0

    public init(
        musicService: MusicServiceProtocol,
        tasteProfileService: TasteProfileServiceProtocol,
        swipeStore: SwipeStoreProtocol
    ) {
        self.musicService = musicService
        self.tasteProfileService = tasteProfileService
        self.swipeStore = swipeStore
    }

    public var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Découvrir", systemImage: "sparkles", value: 0) {
                DiscoverView(
                    musicService: musicService,
                    tasteProfileService: tasteProfileService,
                    swipeStore: swipeStore
                )
            }

            Tab("Mes artistes", systemImage: "person.2.crop.square.stack", value: 1) {
                MyArtistsView(
                    musicService: musicService,
                    swipeStore: swipeStore
                )
            }

            Tab("Réglages", systemImage: "gearshape", value: 2) {
                SettingsView(swipeStore: swipeStore)
            }
        }
        .onChange(of: selectedTab) { _, _ in
            // Pause de l'audio preview lors du changement d'onglet
            AudioPreviewPlayer.shared.pause()
        }
    }
}
