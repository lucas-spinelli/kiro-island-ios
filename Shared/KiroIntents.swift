import AppIntents

#if KIRO_WIDGET
private func requireKiroAppProcess() throws {
    throw KiroError.appProcessRequired
}
#endif

struct SetKiroMoodIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Cambiar emoción de Kiro"
    static var description = IntentDescription("Activa a Kiro o cambia su emoción sin abrir la app.")
    static var openAppWhenRun = false

    @Parameter(title: "Emoción") var mood: KiroMood

    init() { mood = .idle }
    init(mood: KiroMood) { self.mood = mood }

    @MainActor func perform() async throws -> some IntentResult {
        // LiveActivityIntent runs in the app process. Extension copies expose
        // metadata for Button(intent:) but cannot request activities themselves.
        #if KIRO_WIDGET
        try requireKiroAppProcess()
        #else
        try await KiroActivityCoordinator.set(mood, origin: "Atajo o isla")
        #endif
        return .result()
    }
}

struct EndKiroSessionIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Descansar a Kiro"
    static var openAppWhenRun = false

    @MainActor func perform() async throws -> some IntentResult {
        #if KIRO_WIDGET
        try requireKiroAppProcess()
        #else
        await KiroActivityCoordinator.end()
        #endif
        return .result()
    }
}
