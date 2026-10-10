import ActivityKit
import Foundation

@MainActor
enum KiroActivityCoordinator {
    static var active: Activity<KiroAttributes>? {
        Activity<KiroAttributes>.activities.first { $0.activityState == .active || $0.activityState == .stale }
    }

    static func set(_ mood: KiroMood, origin: String, allowStart: Bool = true) async throws {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { throw KiroError.activitiesDisabled }
        // A small actor-isolated critical section (no awaits) avoids creating two
        // activities when an automation and a foreground action arrive together.
        let activity: Activity<KiroAttributes>
        let revision = UUID()
        let state = KiroAttributes.ContentState(mood: mood, gesture: mood == .music ? -1 : 0,
                                                revision: revision, origin: origin)
        if let existing = active {
            activity = existing
        } else {
            guard allowStart else { return }
            let now = Date()
            activity = try Activity.request(
                attributes: KiroAttributes(startedAt: now, quietAt: now.addingTimeInterval(3600)),
                content: ActivityContent(state: state, staleDate: now.addingTimeInterval(3600)),
                pushType: nil)
        }
        // staleDate marks quiet mode, not an automatic end. A new user event
        // renews the quiet period; explicit End always removes the activity.
        let quietAt = Date().addingTimeInterval(3600)
        await activity.update(ActivityContent(state: state, staleDate: quietAt))

        // Only two one-shot waits per gesture. No polling, timers or repeat loop.
        guard mood == .greeting || mood == .music else { return }
        try await Task.sleep(for: .milliseconds(450))
        guard activity.content.state.revision == revision, activity.activityState == .active else { return }
        var second = state
        second.gesture = 1
        await activity.update(ActivityContent(state: second, staleDate: quietAt))
        try await Task.sleep(for: .milliseconds(650))
        guard activity.content.state.revision == revision, activity.activityState == .active else { return }
        var settled = state
        settled.gesture = 0
        if mood == .greeting { settled.mood = .idle }
        await activity.update(ActivityContent(state: settled, staleDate: quietAt))
    }

    static func end() async {
        for activity in Activity<KiroAttributes>.activities {
            let state = KiroAttributes.ContentState(mood: .sleeping)
            await activity.end(ActivityContent(state: state, staleDate: nil), dismissalPolicy: .immediate)
        }
    }
}
