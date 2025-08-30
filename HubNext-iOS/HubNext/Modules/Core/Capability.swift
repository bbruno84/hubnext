import Foundation

/// Describes optional features supported by the underlying graph backend.
public struct Capability: OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) { self.rawValue = rawValue }
    public static let fullTextSearch   = Capability(rawValue: 1 << 0)
    public static let undirectedRels   = Capability(rawValue: 1 << 1)
    public static let assetStreaming   = Capability(rawValue: 1 << 2)
    public static let pushNotifications = Capability(rawValue: 1 << 3)
    public static let accountSwitch    = Capability(rawValue: 1 << 4)
}
