import SwiftUI
import SwiftData

/// Point d'entrée de l'application Discovrd.
@main
struct DiscovrdApp: App {
    private let modelContainer: ModelContainer
    private let musicService: MusicServiceProtocol
    private let tasteProfileService: TasteProfileServiceProtocol
    private let swipeStore: SwipeStoreProtocol

    @State private var authStatus: MusicAuthStatus = .notDetermined
    @State private var subscriptionStatus: SubscriptionStatus = .checking
    @Bindable private var settings = AppSettings.shared
    @Environment(\.scenePhase) private var scenePhase

    init() {
        let container: ModelContainer
        let schema = Schema([
            SwipeRecord.self,
            CachedTasteProfile.self
        ])
        if let disk = try? ModelContainer(for: schema, configurations: [ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)]) {
            container = disk
        } else if let memory = try? ModelContainer(for: schema, configurations: [ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)]) {
            container = memory
        } else {
            // Conteneur de repli mémoire garanti
            let fallbackSchema = Schema([SwipeRecord.self])
            container = (try? ModelContainer(for: fallbackSchema, configurations: [ModelConfiguration(isStoredInMemoryOnly: true)])) ?? (try? ModelContainer(for: schema)) ?? DiscovrdApp.makeFallbackContainer()
        }

        self.modelContainer = container
        let music = AppleMusicService()
        self.musicService = music
        self.tasteProfileService = TasteProfileService(musicService: music, modelContainer: container)
        self.swipeStore = SwiftDataSwipeStore(modelContainer: container)
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                if !settings.hasCompletedOnboarding {
                    OnboardingView {
                        settings.hasCompletedOnboarding = true
                    }
                } else if authStatus != .authorized {
                    AuthorizationPromptView(authStatus: authStatus) {
                        Task {
                            authStatus = await musicService.requestAuthorization()
                            subscriptionStatus = await musicService.checkSubscription()
                        }
                    }
                } else {
                    MainTabView(
                        musicService: musicService,
                        tasteProfileService: tasteProfileService,
                        swipeStore: swipeStore
                    )
                }
            }
            .task {
                authStatus = await musicService.requestAuthorization()
                subscriptionStatus = await musicService.checkSubscription()
            }
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase != .active {
                    AudioPreviewPlayer.shared.pause()
                }
            }
        }
        .modelContainer(modelContainer)
    }

    private static func makeFallbackContainer() -> ModelContainer {
        do {
            return try ModelContainer(for: Schema([SwipeRecord.self]), configurations: [ModelConfiguration(isStoredInMemoryOnly: true)])
        } catch {
            return (try? ModelContainer(for: Schema([]))) ?? makeEmptyContainer()
        }
    }

    private static func makeEmptyContainer() -> ModelContainer {
        let tempUrl = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("discovrd_fallback.store")
        let config = ModelConfiguration(url: tempUrl)
        return (try? ModelContainer(for: Schema([]), configurations: [config])) ?? makeInMemoryMinimalContainer()
    }

    private static func makeInMemoryMinimalContainer() -> ModelContainer {
        if let c = try? ModelContainer(for: Schema([]), configurations: [ModelConfiguration(isStoredInMemoryOnly: true)]) {
            return c
        }
        if let c = try? ModelContainer(for: Schema([])) {
            return c
        }
        let schema = Schema([SwipeRecord.self])
        if let c = try? ModelContainer(for: schema, configurations: [ModelConfiguration(isStoredInMemoryOnly: true)]) {
            return c
        }
        return (try? ModelContainer(for: schema)) ?? {
            do {
                return try ModelContainer(for: Schema([]))
            } catch {
                return (try? ModelContainer(for: schema)) ?? makeEmptyContainer()
            }
        }()
    }
}
