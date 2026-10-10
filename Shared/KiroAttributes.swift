import ActivityKit
import AppIntents
import Foundation

enum KiroMood: String, Codable, Hashable, CaseIterable, AppEnum {
    case idle, greeting, question, music, sleeping

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Emoción de Kiro"
    static var caseDisplayRepresentations: [KiroMood: DisplayRepresentation] = [
        .idle: "Reposo", .greeting: "Saludo", .question: "Pregunta",
        .music: "Música", .sleeping: "Dormido"
    ]

    var label: String {
        switch self {
        case .idle: "Con vos"
        case .greeting: "¡Hola de nuevo!"
        case .question: "¿Sos vos?"
        case .music: "A tu ritmo"
        case .sleeping: "Zzz…"
        }
    }

    var symbol: String {
        switch self {
        case .idle: "sparkle"
        case .greeting: "hand.wave.fill"
        case .question: "questionmark"
        case .music: "music.note"
        case .sleeping: "moon.fill"
        }
    }
}

struct KiroAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var mood: KiroMood
        var gesture: Int = 0
        var revision: UUID = UUID()
        var origin: String = "Kiro"
    }

    var startedAt: Date
    var quietAt: Date
}

enum KiroError: LocalizedError {
    case activitiesDisabled, appProcessRequired, musicPermissionRequired

    var errorDescription: String? {
        switch self {
        case .activitiesDisabled: "Activá las actividades en vivo de Kiro en Ajustes."
        case .appProcessRequired: "Abrí Kiro y volvé a intentar la acción."
        case .musicPermissionRequired: "Conectá Apple Music desde Kiro antes de consultar su reproducción."
        }
    }
}
