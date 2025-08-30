import SwiftUI

/// Projects list with add action.
public struct ProjectsListView: View {
    @StateObject private var vm: ProjectsViewModel
    @State private var title: String = ""

    public init(client: GraphClient) {
        _vm = StateObject(wrappedValue: ProjectsViewModel(client: client))
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                TextField("New project title", text: $title)
                    .textFieldStyle(.roundedBorder)
                Button("Add") {
                    Task { await vm.createProject(title: title); title = "" }
                }.disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            List {
                ForEach(vm.projects) { p in
                    HStack {
                        Text((p.payload["title"]?.asString ?? "—"))
                        Spacer()
                        Text(p.updatedAt, style: .time).foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Projects")
        .task { await vm.load() }
    }
}
