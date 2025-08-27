import SwiftUI

@main
struct LifeHubApp: App {
    private let client = InMemoryGraphClient() // swap with GraphNext adapter later
    private lazy var orchestrator = AppOrchestrator(client: client)

    var body: some Scene {
        WindowGroup {
            ContentView(orchestrator: orchestrator, client: client)
        }
    }
}
