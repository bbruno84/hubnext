import Foundation

/// A structured log event for Developer console.
public struct LogEvent: Identifiable, Codable {
    public enum Level: String, Codable { case info, warn, error, debug }
    public var id = UUID()
    public var timestamp = Date()
    public var area: String
    public var level: Level
    public var message: String
    public var attributes: [String: String] = [:]
}
