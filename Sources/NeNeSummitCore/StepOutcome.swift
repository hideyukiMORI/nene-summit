public struct StepOutcome: Equatable, Sendable {
    public let state: SummitState
    let events: [StepEvent]
}
