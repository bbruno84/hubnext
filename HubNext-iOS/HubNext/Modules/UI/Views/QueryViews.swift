import SwiftUI

/// Basic query builder and results list.
public struct QueryView: View {
    @StateObject private var vm: QueryViewModel

    public init(client: GraphClient) {
        _vm = StateObject(wrappedValue: QueryViewModel(client: client))
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Type"); TextField("e.g. person", text: $vm.type).textFieldStyle(.roundedBorder)
                Text("Tags"); TextField("comma,separated", text: $vm.tags).textFieldStyle(.roundedBorder)
                Button("Run") { Task { await vm.run() } }
            }
            .font(.caption)
            .padding(.vertical, 4)

            List {
                Section("Conditions") {
                    ForEach($vm.conditions) { $cond in
                        HStack {
                            TextField("field", text: $cond.field).textFieldStyle(.roundedBorder)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled(true)
                            Picker("", selection: $cond.op) {
                                Text("=").tag(QueryPredicate.Op.equals)
                                Text("≠").tag(QueryPredicate.Op.notEquals)
                                Text(">").tag(QueryPredicate.Op.greater)
                                Text("<").tag(QueryPredicate.Op.less)
                                Text("↔︎").tag(QueryPredicate.Op.between)
                                Text("∼").tag(QueryPredicate.Op.contains)
                            }.pickerStyle(.menu)
                            TextField("value", text: $cond.value).textFieldStyle(.roundedBorder)
                            if cond.op == .between {
                                TextField("value2", text: Binding(get: { cond.value2 ?? "" }, set: { cond.value2 = $0 })).textFieldStyle(.roundedBorder)
                            }
                        }
                    }
                    Button("+ Add condition") {
                        vm.conditions.append(.init(field: "", op: .equals, value: ""))
                    }
                }

                Section("Results (\(vm.results.count))") {
                    ForEach(vm.results) { e in
                        VStack(alignment: .leading) {
                            Text("\(e.type) — \(e.id.uuidString.prefix(6))").font(.caption).foregroundStyle(.secondary)
                            Text(e.payload.map { "\($0.key)=\($0.value.asString ?? "")" }.joined(separator: ", "))
                                .lineLimit(2)
                        }
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Query")
    }
}
