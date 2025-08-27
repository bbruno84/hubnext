import Foundation

/// Developer tools view model: seed, sync toggles, logs (simplified for MVP).
@MainActor
public final class DeveloperViewModel: ObservableObject {
    @Published public private(set) var logs: [LogEvent] = []
    @Published public var autoSyncEnabled: Bool
    private let orchestrator: AppOrchestrator
    private let client: GraphClient

    public init(orchestrator: AppOrchestrator) {
        self.orchestrator = orchestrator
        self.client = orchestrator.client
        self.autoSyncEnabled = orchestrator.autoSyncEnabled
    }

    /// Appends a log event to the developer console.
    public func log(_ level: LogEvent.Level, _ area: String, _ message: String, attributes: [String:String] = [:]) {
        logs.insert(LogEvent(area: area, level: level, message: message, attributes: attributes), at: 0)
    }

    /// Generates a small or medium seed dataset.
    public func seed(kind: String) async {
        do {
            switch kind {
            case "small":
                try await seedSmall()
            case "medium":
                try await seedMedium()
            default:
                try await seedSmall()
            }
            log(.info, "Seed", "Completed \(kind)")
        } catch {
            log(.error, "Seed", "Failed: \(error.localizedDescription)")
        }
    }

    private func seedSmall() async throws {
        // 8 people, 4 projects
        for i in 1...8 { _ = try await client.createEntity(Entity(type: "person", payload: ["name": .string("Person \(i)")])) }
        for i in 1...4 { _ = try await client.createEntity(Entity(type: "project", payload: ["title": .string("Project \(i)")])) }
    }
    private func seedMedium() async throws {
        for i in 1...30 { _ = try await client.createEntity(Entity(type: "person", payload: ["name": .string("Person \(i)")])) }
        for i in 1...12 { _ = try await client.createEntity(Entity(type: "project", payload: ["title": .string("Project \(i)")])) }
    }

    /// Toggles auto sync (no-op for in-memory backend).
    public func setAutoSync(_ on: Bool) {
        orchestrator.setAutoSync(on)
        self.autoSyncEnabled = on
        log(.info, "Sync", "Auto-sync set to \(on ? "ON" : "OFF")")
    }

    /// Triggers a manual sync (pull then push).
    public func syncNow() async {
        await orchestrator.syncNow()
        log(.info, "Sync", "Manual sync completed")
    }
}
