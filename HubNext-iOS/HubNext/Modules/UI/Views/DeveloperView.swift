import SwiftUI

/// Developer tools screen with seed and sync controls + console log.
public struct DeveloperView: View {
    @StateObject private var vm: DeveloperViewModel

    public init(orchestrator: AppOrchestrator) {
        _vm = StateObject(wrappedValue: DeveloperViewModel(orchestrator: orchestrator))
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Toggle("Auto-sync", isOn: Binding(get: { vm.autoSyncEnabled }, set: { vm.setAutoSync($0) }))
                Button("Sync now") { Task { await vm.syncNow() } }
                Spacer()
                Button("Seed: small") { Task { await vm.seed(kind: "small") } }
                Button("Seed: medium") { Task { await vm.seed(kind: "medium") } }
            }
            .padding(.vertical, 4)

            LogConsoleView(events: vm.logs)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding()
        .navigationTitle("Developer")
        .onAppear {
            vm.log(.info, "Dev", "Developer tools ready")
        }
    }
}
