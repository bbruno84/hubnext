import SwiftUI

/// People list with add/delete actions.
public struct PeopleListView: View {
    @StateObject private var vm: PeopleViewModel
    @State private var newName: String = ""

    public init(client: GraphClient) {
        _vm = StateObject(wrappedValue: PeopleViewModel(client: client))
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                TextField("New person name", text: $newName)
                    .textFieldStyle(.roundedBorder)
                Button("Add") {
                    Task { await vm.createPerson(name: newName); newName = "" }
                }
                .disabled(newName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            List {
                ForEach(vm.people) { p in
                    HStack {
                        Text((p.payload["name"]?.asString ?? "—"))
                        Spacer()
                        Text(p.updatedAt, style: .time).foregroundStyle(.secondary)
                    }
                }
                .onDelete { idx in
                    for i in idx { let id = vm.people[i].id; Task { await vm.deletePerson(id: id) } }
                }
            }
        }
        .padding()
        .navigationTitle("People")
        .task { await vm.load() }
    }
}
