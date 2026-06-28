import Foundation
import OSLog

/// Background ambient audio service.
///
/// **Foundation stub:** the playback pipeline (AVAudioEngine, ambient tracks,
/// SFX bank) is scheduled for a later phase (see `PROJECT_TRACKER.md` E009 asset
/// production). This stub is intentionally inert and side-effect-free: it tracks
/// the requested state and logs intent so the rest of the app can wire up audio
/// controls now without risk. It never touches `AVAudioSession`, so it cannot
/// interrupt other media or crash. Replace the bodies when audio assets land.
@MainActor
final class AudioService {

    private let logger = Logger(subsystem: "com.moonloom.app", category: "Audio")

    private(set) var isMusicPlaying = false
    var isMusicEnabled = true
    var isSFXEnabled = true

    func startAmbientMusic() {
        guard isMusicEnabled, !isMusicPlaying else { return }
        isMusicPlaying = true
        logger.debug("Ambient music requested (stub — no audio assets yet).")
    }

    func stopAmbientMusic() {
        guard isMusicPlaying else { return }
        isMusicPlaying = false
        logger.debug("Ambient music stopped (stub).")
    }

    func playSFX(_ name: String) {
        guard isSFXEnabled else { return }
        logger.debug("SFX requested: \(name, privacy: .public) (stub).")
    }
}
