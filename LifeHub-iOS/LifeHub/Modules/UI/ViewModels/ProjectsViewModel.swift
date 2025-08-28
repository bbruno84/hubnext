import Foundation

/// View model for Project entities.
@MainActor
public final class ProjectsViewModel: ObservableObject {
    @Published public private(set) var projects: [Entity] = []
    private let client: GraphClient

    public init(client: GraphClient) {
        self.client = client
    }

    public func load() async {
        do { projects = try await client.entities(type: "project", tag: nil) }
        catch { print("Load projects failed: \(error)") }
    }

    public func createProject(title: String) async {
        let e = Entity(type: "project", tags: [], payload: ["title": .string(title)])
        do { _ = try await client.createEntity(e); await load() }
        catch { print("Create project failed: \(error)") }
    }
}
