import Foundation

/// Identifies a node type in the graph (e.g., person, project, document, place).
public typealias EntityType = String

/// Graph entity with decoupled payload.
public struct Entity: Identifiable, Hashable, Codable {
    public var id: UUID
    public var type: EntityType
    public var tags: [String]
    public var payload: GraphPayload
    public var createdAt: Date
    public var updatedAt: Date

    public init(id: UUID = UUID(), type: EntityType, tags: [String] = [], payload: GraphPayload = [:], createdAt: Date = Date(), updatedAt: Date = Date()) {
        self.id = id
        self.type = type
        self.tags = tags
        self.payload = payload
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

/// Directed relationship between two entities.
public struct Relationship: Identifiable, Hashable, Codable {
    public var id: UUID
    public var from: UUID
    public var to: UUID
    public var name: String
    public var createdAt: Date
    public var updatedAt: Date

    public init(id: UUID = UUID(), from: UUID, to: UUID, name: String, createdAt: Date = Date(), updatedAt: Date = Date()) {
        self.id = id
        self.from = from
        self.to = to
        self.name = name
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
