import SwiftUI
import UIKit

@main
struct KiroIslandApp: App {
    var body: some Scene { WindowGroup { KiroHomeView() } }
}

struct KiroHomeView: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var music = AppleMusicBridge()
    @State private var mood = KiroMood.idle
    @State private var busy = false
    @State private var status = "Empezá una sesión para llevar a Kiro con vos."
    @State private var problem: String?
    @State private var lockSignals = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    KiroAvatar(mood: mood).frame(width: 168, height: 136).padding(.top, 24)
                    Text("Un poquito de Kiro, con vos.").font(.title2.bold())
                    Text(status).font(.subheadline).foregroundStyle(.secondary).multilineTextAlignment(.center)

                    Button("Llevar a Kiro a la isla", systemImage: "sparkle") { change(.greeting) }
                        .buttonStyle(.borderedProminent).disabled(busy)
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(KiroMood.allCases, id: \.self) { item in
                            Button(item.label, systemImage: item.symbol) { change(item) }
                                .buttonStyle(.bordered).frame(maxWidth: .infinity).disabled(busy)
                        }
                        Button("Descansar", systemImage: "xmark") {
                            Task { await KiroActivityCoordinator.end(); mood = .sleeping; status = "Kiro está descansando fuera de la isla." }
                        }.buttonStyle(.bordered)
                    }

                    VStack(alignment: .leading, spacing: 14) {
                        Text("Apple Music").font(.headline)
                        Text("Puede leer la reproducción al ejecutar un atajo o mientras esta app está abierta.")
                            .font(.footnote).foregroundStyle(.secondary)
                        Button(music.enabled ? "Consultar reproducción" : "Conectar Apple Music") {
                            Task {
                                if !music.enabled {
                                    guard await music.authorize() else { problem = "Apple Music no está autorizado."; return }
                                }
                                music.startObserving()
                                do {
                                    try await AppleMusicBridge.sync()
                                    mood = KiroActivityCoordinator.active?.content.state.mood ?? .idle
                                    status = "Apple Music consultado."
                                }
                                catch { problem = error.localizedDescription }
                            }
                        }.buttonStyle(.bordered)
                    }.frame(maxWidth: .infinity, alignment: .leading)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Gestos automáticos").font(.headline)
                        Text("Al volver a Kiro, te saluda si ya hay una sesión. Con Atajos podés activar Música al abrir Spotify o Apple Music.")
                            .font(.footnote).foregroundStyle(.secondary)
                        Toggle("Probar señales de bloqueo", isOn: $lockSignals)
                        Text("Experimental: usa las señales de protección de datos que iOS entregue. No detecta todos los bloqueos ni confirma quién usa el teléfono.")
                            .font(.caption).foregroundStyle(.secondary)
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    Text("Kiro hace un gesto breve al cambiar de emoción y después queda quieto. Siempre podés hacerlo descansar.")
                        .font(.footnote).foregroundStyle(.secondary)
                }.padding(24)
            }
            .navigationTitle("Kiro Island")
            .background(Color(red: 0.075, green: 0.075, blue: 0.10))
            .preferredColorScheme(.dark)
            .tint(Color(red: 0.64, green: 0.53, blue: 0.99))
            .alert("Kiro", isPresented: Binding(get: { problem != nil }, set: { if !$0 { problem = nil } })) {
                Button("Entendido") { problem = nil }
            } message: { Text(problem ?? "") }
            .onChange(of: scenePhase) { _, phase in
                if phase == .active {
                    music.startObserving()
                    if KiroActivityCoordinator.active != nil { change(.greeting, allowStart: false) }
                } else if phase == .background {
                    music.stopObserving()
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.protectedDataWillBecomeUnavailableNotification)) { _ in
                guard lockSignals else { return }
                change(.question, allowStart: false)
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.protectedDataDidBecomeAvailableNotification)) { _ in
                guard lockSignals else { return }
                change(.greeting, allowStart: false)
            }
        }
    }

    private func change(_ newMood: KiroMood, allowStart: Bool = true) {
        Task { @MainActor in
            busy = true
            defer { busy = false }
            do {
                try await KiroActivityCoordinator.set(newMood, origin: "App Kiro", allowStart: allowStart)
                mood = newMood == .greeting ? .idle : newMood
                status = "Kiro: \(mood.label)."
            } catch { problem = error.localizedDescription }
        }
    }
}
