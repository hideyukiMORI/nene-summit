struct Kinematics: Equatable, Sendable {
    let place: Place
    let velocity: Velocity

    func stopped() -> Kinematics {
        Kinematics(place: place, velocity: .still)
    }
}
