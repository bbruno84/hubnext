import Foundation

/// View model that wraps query building and execution for a specific type.
@MainActor
public final class QueryViewModel: ObservableObject {
    public struct Condition: Identifiable, Hashable {
        public var id = UUID()
        public var field: String
        public var op: QueryPredicate.Op
        public var value: String
        public var value2: String?
    }
    @Published public var type: EntityType = "person"
    @Published public var tags: String = ""
    @Published public var conditions: [Condition] = []
    @Published public private(set) var results: [Entity] = []

    private let client: GraphClient
    public init(client: GraphClient) { self.client = client }

    /// Executes the query using the current builder state.
    public func run() async {
        let tagList = tags.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
        let preds: [QueryPredicate] = conditions.map { c in
            let v1 = GraphPayloadValue.string(c.value)
            let v2 = c.value2.map { GraphPayloadValue.string($0) }
            return QueryPredicate(field: c.field, op: c.op, value: v1, value2: v2)
        }
        do { results = try await client.query(type: type, tagsAnyOf: tagList, predicates: preds) }
        catch { print("Query failed: \(error)") }
    }
}
