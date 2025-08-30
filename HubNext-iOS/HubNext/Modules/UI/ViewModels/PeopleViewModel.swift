import Foundation

/// A view model responsible for managing CRUD operations on Person entities.
/// Provides observable state for SwiftUI and delegates persistence to a GraphClient.
@MainActor
public final class PeopleViewModel: ObservableObject {
    public struct PersonForm {
        public var name: String = ""
        public var tags: [String] = []
        public var payload: [String: GraphPayloadValue] = [:]
    }
    @Published public private(set) var people: [Entity] = []
    private let client: GraphClient

    public init(client: GraphClient) {
        self.client = client
    }

    /// Loads the list of people from the backend.
    public func load() async {
        do { people = try await client.entities(type: "person", tag: nil) }
        catch { print("Load people failed: \(error)") }
    }

    /// Creates a new person with the provided name and optional tags.
    /// - Parameter name: The person's display name.
    public func createPerson(name: String) async {
        var e = Entity(type: "person", tags: [], payload: ["name": .string(name)])
        do {
            e = try await client.createEntity(e)
            await load()
        } catch { print("Create person failed: \(error)") }
    }

    /// Deletes a person by id.
    public func deletePerson(id: UUID) async {
        do { try await client.deleteEntity(id: id); await load() }
        catch { print("Delete person failed: \(error)") }
    }
}
