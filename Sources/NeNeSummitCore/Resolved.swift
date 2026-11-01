struct Resolved: Equatable, Sendable {
    let kinematics: Kinematics
    let action: Action
    let progress: Progress
    let events: [StepEvent]
}
