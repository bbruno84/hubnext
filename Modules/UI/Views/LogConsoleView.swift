import SwiftUI

/// Simple developer console displaying LogEvents.
public struct LogConsoleView: View {
    public var events: [LogEvent]
    public init(events: [LogEvent]) { self.events = events }

    public var body: some View {
        List(events) { e in
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(e.timestamp, style: .time).font(.caption2).foregroundStyle(.secondary)
                    Spacer()
                    Text(e.level.rawValue.uppercased()).font(.caption2).foregroundStyle(color(for: e.level))
                }
                Text("[\(e.area)] \(e.message)")
                if !e.attributes.isEmpty {
                    Text(e.attributes.map { "\($0.key)=\($0.value)" }.joined(separator: " • "))
                        .font(.caption2).foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 2)
        }
    }

    private func color(for level: LogEvent.Level) -> Color {
        switch level {
        case .info: return .blue
        case .warn: return .orange
        case .error: return .red
        case .debug: return .gray
        }
    }
}
