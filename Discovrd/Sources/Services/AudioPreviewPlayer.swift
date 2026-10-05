import AVFoundation
import Foundation
import Observation

/// Contrôleur audio isolé pour la lecture des extraits musicaux de 30 secondes.
@Observable
@MainActor
public final class AudioPreviewPlayer {
    public static let shared = AudioPreviewPlayer()

    private var player: AVPlayer?
    public private(set) var isPlaying: Bool = false
    public private(set) var currentTrackID: String?
    public var isAutoplayEnabled: Bool = true

    private var preloadedPlayers: [String: AVPlayer] = [:]

    public init() {
        configureAudioSession()
    }

    private func configureAudioSession() {
        #if os(iOS)
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            // Échec toléré si dans le simulateur
        }
        #endif
    }

    /// Joue l'extrait d'un morceau s'il dispose d'une URL de prévisualisation et si l'autoplay est activé.
    public func play(track: TrackItem) {
        guard isAutoplayEnabled else {
            stop()
            return
        }

        if currentTrackID == track.id && isPlaying {
            return
        }

        stop()

        guard let previewURL = track.previewURL else {
            return
        }

        currentTrackID = track.id

        // Vérifier si déjà préchargé
        if let preloaded = preloadedPlayers[track.id] {
            player = preloaded
            preloadedPlayers.removeValue(forKey: track.id)
        } else {
            let item = AVPlayerItem(url: previewURL)
            player = AVPlayer(playerItem: item)
        }

        player?.play()
        isPlaying = true
    }

    /// Précharge les extraits des cartes suivantes dans la file.
    public func preloadNextTracks(_ tracks: [TrackItem]) {
        guard isAutoplayEnabled else { return }

        // Précharger au plus les 2 pistes suivantes
        let toPreload = tracks.prefix(2)
        for track in toPreload {
            guard let url = track.previewURL, preloadedPlayers[track.id] == nil else { continue }
            let item = AVPlayerItem(url: url)
            let newPlayer = AVPlayer(playerItem: item)
            preloadedPlayers[track.id] = newPlayer
        }

        // Nettoyage des préchargements obsolètes
        let validIDs = Set(toPreload.map(\.id))
        preloadedPlayers = preloadedPlayers.filter { validIDs.contains($0.key) }
    }

    /// Met en pause la lecture audio (changement d'onglet, mise en arrière-plan).
    public func pause() {
        player?.pause()
        isPlaying = false
    }

    /// Arrête complètement la lecture.
    public func stop() {
        player?.pause()
        player = nil
        isPlaying = false
        currentTrackID = nil
    }
}
