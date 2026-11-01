struct WishResult: Equatable, Sendable {
    let kinematics: Kinematics
    let action: Action
    let events: [StepEvent]
}
