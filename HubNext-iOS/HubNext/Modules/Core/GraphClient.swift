import Foundation

/// Errors thrown by GraphClient implementations.
public enum GraphError: Error {
    case notFound
    case invalidOperation(String)
    case persistence(String)
    case sync(String)
}

/// Basic CRUD for entities.
public protocol GraphClientCRUD {
    /// Creates and returns a new entity.
    func createEntity(_ e: Entity) async throws -> Entity
    /// Updates an entity (by id) and returns the updated one.
    func updateEntity(_ e: Entity) async throws -> Entity
    /// Deletes an entity by id.
    func deleteEntity(id: UUID) async throws
    /// Returns an entity by id.
    func entity(id: UUID) async throws -> Entity
    /// Returns all entities of given type (optionally filtered by tag).
    func entities(type: EntityType, tag: String?) async throws -> [Entity]
}

/// Relationship operations.
public protocol GraphClientRelations {
    func createRelationship(_ r: Relationship) async throws -> Relationship
    func deleteRelationship(id: UUID) async throws
    func relationships(from: UUID?, to: UUID?, name: String?) async throws -> [Relationship]
}

/// Query operations (subset for MVP).
public struct QueryPredicate: Codable, Equatable {
    public enum Op: String, Codable { case equals, notEquals, greater, less, between, contains }
    public var field: String
    public var op: Op
    public var value: GraphPayloadValue
    public var value2: GraphPayloadValue?
    public init(field: String, op: Op, value: GraphPayloadValue, value2: GraphPayloadValue? = nil) {
        self.field = field; self.op = op; self.value = value; self.value2 = value2
    }
}
public protocol GraphClientQuery {
    func query(type: EntityType, tagsAnyOf: [String], predicates: [QueryPredicate]) async throws -> [Entity]
}

/// Sync operations (stubbed in MVP to keep app running without GraphNext/CloudKit).
public protocol GraphClientSync {
    var autoSyncEnabled: Bool { get set }
    func pull() async throws
    func push() async throws
    func resetSyncState() async throws
}

/// Capability & environment
public protocol GraphClientCapabilities {
    var capabilities: Capability { get }
}

/// Aggregated facade used by ViewModels. Constrained to AnyObject so callers can mutate settable
/// properties (e.g., autoSyncEnabled) through let references.
public typealias GraphClient = AnyObject & GraphClientCRUD & GraphClientRelations & GraphClientQuery & GraphClientSync & GraphClientCapabilities
