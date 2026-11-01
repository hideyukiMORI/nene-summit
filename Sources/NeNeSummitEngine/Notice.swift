import NeNeSummitCore

public struct Notice: Equatable, Sendable {
    public let events: [StepEvent]
    public let opened: Bool
}
