import SwiftUI

/// Root tab view composing the main features.
struct ContentView: View {
    let orchestrator: AppOrchestrator
    let client: GraphClient

    var body: some View {
        TabView {
            NavigationView { PeopleListView(client: client) }
                .tabItem { Label("People", systemImage: "person.2") }
            NavigationView { ProjectsListView(client: client) }
                .tabItem { Label("Projects", systemImage: "list.bullet.rectangle") }
            NavigationView { QueryView(client: client) }
                .tabItem { Label("Query", systemImage: "magnifyingglass") }
            NavigationView { DeveloperView(orchestrator: orchestrator) }
                .tabItem { Label("Developer", systemImage: "wrench.and.screwdriver") }
        }
    }
}
