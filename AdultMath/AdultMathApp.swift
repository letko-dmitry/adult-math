import SwiftUI

@main
struct AdultMathApp: App {
    @State private var progressManager = ProgressManager()
    @State private var questionTracker = QuestionTracker()
    @State private var notificationService = NotificationService()
    @State private var notificationState = NotificationState()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
            }
            .environment(progressManager)
            .environment(questionTracker)
            .environment(notificationService)
            .environment(notificationState)
        }
    }
}
