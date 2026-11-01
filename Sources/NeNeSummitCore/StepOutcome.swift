public struct StepOutcome: Equatable, Sendable {
    public let state: SummitState
    public let events: [StepEvent]
}
