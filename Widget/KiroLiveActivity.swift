import ActivityKit
import AppIntents
import SwiftUI
import WidgetKit

@main
struct KiroWidgetBundle: WidgetBundle {
    var body: some Widget { KiroLiveActivity() }
}

struct KiroLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: KiroAttributes.self) { context in
            HStack(spacing: 14) {
                avatar(context, width: 62, height: 50)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Kiro").font(.headline)
                    Text(context.isStale ? "Un ratito de descanso" : context.state.mood.label)
                        .font(.subheadline).foregroundStyle(.secondary)
                }
                Spacer(minLength: 8)
                Button(intent: EndKiroSessionIntent()) { Image(systemName: "xmark.circle.fill") }
                    .buttonStyle(.plain).accessibilityLabel("Descansar a Kiro")
            }.padding(16)
             .activityBackgroundTint(Color(red: 0.06, green: 0.06, blue: 0.09))
             .activitySystemActionForegroundColor(.white)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) { avatar(context, width: 52, height: 43) }
                DynamicIslandExpandedRegion(.trailing) {
                    Image(systemName: context.isStale ? "moon.fill" : context.state.mood.symbol)
                        .font(.title3).foregroundStyle(Color(red: 0.70, green: 0.60, blue: 1))
                        .padding(.top, 10)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(spacing: 10) {
                        Text(context.isStale ? "Un ratito de descanso" : context.state.mood.label).font(.headline)
                        HStack(spacing: 24) {
                            Button(intent: SetKiroMoodIntent(mood: .greeting)) { Image(systemName: "hand.wave") }
                                .accessibilityLabel("Saludar con Kiro")
                            Button(intent: SetKiroMoodIntent(mood: .music)) { Image(systemName: "music.note") }
                                .accessibilityLabel("Activar pose de música")
                            Button(intent: EndKiroSessionIntent()) { Image(systemName: "moon") }
                                .accessibilityLabel("Descansar a Kiro")
                        }.buttonStyle(.plain).padding(.bottom, 6)
                    }
                }
            } compactLeading: {
                avatar(context, width: 33, height: 28)
            } compactTrailing: {
                Image(systemName: context.isStale ? "moon.fill" : context.state.mood.symbol)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color(red: 0.70, green: 0.60, blue: 1))
            } minimal: {
                avatar(context, width: 29, height: 26)
            }
            .keylineTint(Color(red: 0.48, green: 0.36, blue: 0.78))
        }
    }

    private func avatar(_ context: ActivityViewContext<KiroAttributes>, width: CGFloat, height: CGFloat) -> some View {
        KiroAvatar(mood: context.isStale ? .sleeping : context.state.mood,
                   gesture: context.isStale ? 0 : context.state.gesture)
            .frame(width: width, height: height)
            .id(context.isStale ? KiroMood.sleeping : context.state.mood)
            .transition(.opacity.combined(with: .scale(scale: 0.95)))
    }
}
