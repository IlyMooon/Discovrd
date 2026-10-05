import Foundation
import Observation

/// Réglages utilisateur de l'application Discovrd stockés dans UserDefaults.
@Observable
@MainActor
public final class AppSettings {
    public static let shared = AppSettings()

    private enum Keys {
        static let alsoAddToLibrary = "discovrd_alsoAddToLibrary"
        static let allowExplicitContent = "discovrd_allowExplicitContent"
        static let autoplayPreviews = "discovrd_autoplayPreviews"
        static let hasCompletedOnboarding = "discovrd_hasCompletedOnboarding"
    }

    public var alsoAddToLibrary: Bool {
        didSet {
            UserDefaults.standard.set(alsoAddToLibrary, forKey: Keys.alsoAddToLibrary)
        }
    }

    public var allowExplicitContent: Bool {
        didSet {
            UserDefaults.standard.set(allowExplicitContent, forKey: Keys.allowExplicitContent)
        }
    }

    public var autoplayPreviews: Bool {
        didSet {
            UserDefaults.standard.set(autoplayPreviews, forKey: Keys.autoplayPreviews)
            AudioPreviewPlayer.shared.isAutoplayEnabled = autoplayPreviews
            if !autoplayPreviews {
                AudioPreviewPlayer.shared.stop()
            }
        }
    }

    public var hasCompletedOnboarding: Bool {
        didSet {
            UserDefaults.standard.set(hasCompletedOnboarding, forKey: Keys.hasCompletedOnboarding)
        }
    }

    public init() {
        self.alsoAddToLibrary = UserDefaults.standard.object(forKey: Keys.alsoAddToLibrary) as? Bool ?? true
        self.allowExplicitContent = UserDefaults.standard.object(forKey: Keys.allowExplicitContent) as? Bool ?? true
        self.autoplayPreviews = UserDefaults.standard.object(forKey: Keys.autoplayPreviews) as? Bool ?? true
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: Keys.hasCompletedOnboarding)

        AudioPreviewPlayer.shared.isAutoplayEnabled = self.autoplayPreviews
    }
}
