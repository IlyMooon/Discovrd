import Foundation
import SwiftData

/// Direction d'un swipe effectué par l'utilisateur.
public enum SwipeDirection: String, Codable, Sendable {
    case like
    case pass
}

/// Source d'une recommandation swipée.
public enum SwipeSource: String, Codable, Sendable {
    case discover
    case myArtists
}

/// Enregistrement persistant d'un swipe dans SwiftData.
@Model
public final class SwipeRecord {
    @Attribute(.unique) public var songID: String
    public var artistID: String
    public var rawDirection: String
    public var timestamp: Date
    public var rawSource: String

    public var direction: SwipeDirection {
        get { SwipeDirection(rawValue: rawDirection) ?? .pass }
        set { rawDirection = newValue.rawValue }
    }

    public var source: SwipeSource {
        get { SwipeSource(rawValue: rawSource) ?? .discover }
        set { rawSource = newValue.rawValue }
    }

    public init(
        songID: String,
        artistID: String,
        direction: SwipeDirection,
        timestamp: Date = Date(),
        source: SwipeSource
    ) {
        self.songID = songID
        self.artistID = artistID
        self.rawDirection = direction.rawValue
        self.timestamp = timestamp
        self.rawSource = source.rawValue
    }
}
