import Foundation

/// High level app orchestrator: holds the GraphClient and exposes app-wide ops.
public final class AppOrchestrator: ObservableObject {
    public var client: GraphClient
    @Published public var autoSyncEnabled: Bool = false

    public init(client: GraphClient) {
        self.client = client
        self.autoSyncEnabled = client.autoSyncEnabled
    }

    /// Triggers a full sync (pull then push). No-op for in-memory client.
    public func syncNow() async {
        do {
            try await client.pull()
            try await client.push()
        } catch {
            print("Sync error: \(error)")
        }
    }

    /// Toggle auto-sync. Delegates to client if supported.
    public func setAutoSync(_ on: Bool) {
        client.autoSyncEnabled = on
        self.autoSyncEnabled = on
    }
}
