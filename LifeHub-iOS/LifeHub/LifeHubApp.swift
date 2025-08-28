import SwiftUI

@main
struct LifeHubApp: App {
    private let client: GraphClient
    @StateObject private var orchestrator: AppOrchestrator

    init() {
        let client = InMemoryGraphClient() // swap with GraphNext adapter later
        self.client = client
        _orchestrator = StateObject(wrappedValue: AppOrchestrator(client: client))
    }

    var body: some Scene {
        WindowGroup {
            ContentView(orchestrator: orchestrator, client: client)
        }
    }
}
