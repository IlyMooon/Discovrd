import Foundation

/// Modèle générique et découplé représentant une piste musicale dans Discovrd.
/// Ce modèle permet à l'application de fonctionner avec MusicKit ainsi qu'avec des mocks complets en prévisualisation et tests unitaires.
public struct TrackItem: Identifiable, Hashable, Sendable, Codable {
    public let id: String
    public let title: String
    public let artistName: String
    public let artistId: String
    public let albumTitle: String?
    public let genreNames: [String]
    public let releaseDate: Date?
    public let duration: TimeInterval?
    public let isExplicit: Bool
    public let artworkURL: URL?
    public let artworkBackgroundColorHex: String?
    public let previewURL: URL?
    public let appleMusicURL: URL?
    public let recommendationReason: String

    public init(
        id: String,
        title: String,
        artistName: String,
        artistId: String,
        albumTitle: String? = nil,
        genreNames: [String] = [],
        releaseDate: Date? = nil,
        duration: TimeInterval? = 180,
        isExplicit: Bool = false,
        artworkURL: URL? = nil,
        artworkBackgroundColorHex: String? = nil,
        previewURL: URL? = nil,
        appleMusicURL: URL? = nil,
        recommendationReason: String = "Découverte"
    ) {
        self.id = id
        self.title = title
        self.artistName = artistName
        self.artistId = artistId
        self.albumTitle = albumTitle
        self.genreNames = genreNames
        self.releaseDate = releaseDate
        self.duration = duration
        self.isExplicit = isExplicit
        self.artworkURL = artworkURL
        self.artworkBackgroundColorHex = artworkBackgroundColorHex
        self.previewURL = previewURL
        self.appleMusicURL = appleMusicURL
        self.recommendationReason = recommendationReason
    }
}
