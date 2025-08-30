import Foundation

/// A `Codable` sum type to represent simple payload values.
public enum GraphPayloadValue: Codable, Equatable, Hashable {
    case string(String)
    case int(Int)
    case double(Double)
    case bool(Bool)
    case date(Date)

    public init(from decoder: Decoder) throws {
        let c = try decoder.singleValueContainer()
        if let v = try? c.decode(String.self) { self = .string(v); return }
        if let v = try? c.decode(Int.self) { self = .int(v); return }
        if let v = try? c.decode(Double.self) { self = .double(v); return }
        if let v = try? c.decode(Bool.self) { self = .bool(v); return }
        if let v = try? c.decode(Date.self) { self = .date(v); return }
        throw DecodingError.dataCorruptedError(in: c, debugDescription: "Unsupported GraphPayloadValue")
    }

    public func encode(to encoder: Encoder) throws {
        var c = encoder.singleValueContainer()
        switch self {
        case .string(let s): try c.encode(s)
        case .int(let i): try c.encode(i)
        case .double(let d): try c.encode(d)
        case .bool(let b): try c.encode(b)
        case .date(let dt): try c.encode(dt)
        }
    }

    /// Convenience for textual search.
    public var asString: String? {
        switch self {
        case .string(let s): return s
        case .int(let i): return String(i)
        case .double(let d): return String(d)
        case .bool(let b): return b ? "true" : "false"
        case .date(let dt): return ISO8601DateFormatter().string(from: dt)
        }
    }
}

public typealias GraphPayload = [String: GraphPayloadValue]
