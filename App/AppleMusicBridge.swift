import AppIntents
import Combine
import MediaPlayer

/// Reads Apple Music only when invoked or while Kiro's app is foreground.
/// It does not control playback, scan Spotify or keep any background service alive.
@MainActor
final class AppleMusicBridge: ObservableObject {
    @Published private(set) var enabled = false
    private var observation: AnyCancellable?

    func authorize() async -> Bool {
        let status = await withCheckedContinuation { continuation in
            MPMediaLibrary.requestAuthorization { continuation.resume(returning: $0) }
        }
        enabled = status == .authorized
        return enabled
    }

    func startObserving() {
        guard enabled, observation == nil else { return }
        let player = MPMusicPlayerController.systemMusicPlayer
        player.beginGeneratingPlaybackNotifications()
        observation = NotificationCenter.default.publisher(for: .MPMusicPlayerControllerPlaybackStateDidChange,
                                                          object: player)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                Task { @MainActor in
                    guard KiroActivityCoordinator.active != nil else { return }
                    try? await Self.sync(allowStart: false)
                }
            }
    }

    func stopObserving() {
        guard observation != nil else { return }
        observation?.cancel(); observation = nil
        MPMusicPlayerController.systemMusicPlayer.endGeneratingPlaybackNotifications()
    }

    static func sync(allowStart: Bool = true) async throws {
        guard MPMediaLibrary.authorizationStatus() == .authorized else { throw KiroError.musicPermissionRequired }
        let playing = MPMusicPlayerController.systemMusicPlayer.playbackState == .playing
        try await KiroActivityCoordinator.set(playing ? .music : .idle,
                                             origin: "Apple Music: lectura puntual", allowStart: allowStart)
    }
}

struct CheckAppleMusicIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Consultar Apple Music para Kiro"
    static var description = IntentDescription("Consulta la reproducción en este momento. No mantiene un monitor en segundo plano.")
    static var openAppWhenRun = false
    @MainActor func perform() async throws -> some IntentResult {
        try await AppleMusicBridge.sync()
        return .result()
    }
}

struct KiroShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(intent: SetKiroMoodIntent(mood: .greeting),
                    phrases: ["Saludame con \(.applicationName)"],
                    shortTitle: "Saludo", systemImageName: "hand.wave")
        AppShortcut(intent: SetKiroMoodIntent(mood: .music),
                    phrases: ["Modo música de \(.applicationName)"],
                    shortTitle: "Música", systemImageName: "music.note")
        AppShortcut(intent: EndKiroSessionIntent(),
                    phrases: ["Descansar con \(.applicationName)"],
                    shortTitle: "Descansar", systemImageName: "moon")
    }
}
