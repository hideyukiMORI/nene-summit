struct StepOutcome: Equatable, Sendable {
    let state: SummitState
    let events: [StepEvent]
}
