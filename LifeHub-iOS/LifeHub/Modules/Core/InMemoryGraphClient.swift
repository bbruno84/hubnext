import Foundation

/// A simple in-memory client for fast iteration and testing.
public final class InMemoryGraphClient: GraphClient {
    public var capabilities: Capability = []
    public var autoSyncEnabled: Bool = false

    private var entitiesStore: [UUID: Entity] = [:]
    private var relationshipsStore: [UUID: Relationship] = [:]

    public init() {}

    // MARK: - CRUD
    public func createEntity(_ e: Entity) async throws -> Entity {
        var e = e
        e.createdAt = Date()
        e.updatedAt = e.createdAt
        entitiesStore[e.id] = e
        return e
    }
    public func updateEntity(_ e: Entity) async throws -> Entity {
        guard entitiesStore[e.id] != nil else { throw GraphError.notFound }
        var e = e; e.updatedAt = Date()
        entitiesStore[e.id] = e
        return e
    }
    public func deleteEntity(id: UUID) async throws {
        guard entitiesStore.removeValue(forKey: id) != nil else { throw GraphError.notFound }
        // cascade delete relationships
        relationshipsStore = relationshipsStore.filter { $0.value.from != id && $0.value.to != id }
    }
    public func entity(id: UUID) async throws -> Entity {
        guard let e = entitiesStore[id] else { throw GraphError.notFound }
        return e
    }
    public func entities(type: EntityType, tag: String?) async throws -> [Entity] {
        let all = entitiesStore.values.filter { $0.type == type }
        if let t = tag { return all.filter { $0.tags.contains(t) } }
        return all.sorted { $0.updatedAt > $1.updatedAt }
    }

    // MARK: - Relations
    public func createRelationship(_ r: Relationship) async throws -> Relationship {
        guard entitiesStore[r.from] != nil, entitiesStore[r.to] != nil else {
            throw GraphError.invalidOperation("Invalid endpoints")
        }
        relationshipsStore[r.id] = r
        return r
    }
    public func deleteRelationship(id: UUID) async throws {
        guard relationshipsStore.removeValue(forKey: id) != nil else { throw GraphError.notFound }
    }
    public func relationships(from: UUID?, to: UUID?, name: String?) async throws -> [Relationship] {
        return relationshipsStore.values.filter { rel in
            let okFrom = from == nil || rel.from == from!
            let okTo = to == nil || rel.to == to!
            let okName = name == nil || rel.name == name!
            return okFrom && okTo && okName
        }.sorted { $0.updatedAt > $1.updatedAt }
    }

    // MARK: - Query (simple contains/compare on payload)
    public func query(type: EntityType, tagsAnyOf: [String], predicates: [QueryPredicate]) async throws -> [Entity] {
        var result = try await entities(type: type, tag: nil)
        if !tagsAnyOf.isEmpty {
            result = result.filter { !($0.tags.isDisjoint(with: tagsAnyOf)) }
        }
        for p in predicates {
            result = result.filter { e in
                guard let v = e.payload[p.field] else { return false }
                switch p.op {
                case .equals: return v == p.value
                case .notEquals: return v != p.value
                case .greater:
                    if case let .double(d) = v, case let .double(t) = p.value { return d > t }
                    if case let .int(d) = v, case let .int(t) = p.value { return d > t }
                    return false
                case .less:
                    if case let .double(d) = v, case let .double(t) = p.value { return d < t }
                    if case let .int(d) = v, case let .int(t) = p.value { return d < t }
                    return false
                case .between:
                    guard let v2 = p.value2 else { return false }
                    if case let .double(d) = v, case let .double(a) = p.value, case let .double(b) = v2 { return d >= a && d <= b }
                    if case let .int(d) = v, case let .int(a) = p.value, case let .int(b) = v2 { return d >= a && d <= b }
                    return false
                case .contains:
                    return v.asString?.localizedCaseInsensitiveContains(p.value.asString ?? "") ?? false
                }
            }
        }
        return result
    }

    // MARK: - Sync (no-op stubs)
    public func pull() async throws {}
    public func push() async throws {}
    public func resetSyncState() async throws {}
}

fileprivate extension Array where Element: Equatable {
    func isDisjoint(with other: [Element]) -> Bool {
        for e in self where other.contains(e) { return false }
        return true
    }
}
