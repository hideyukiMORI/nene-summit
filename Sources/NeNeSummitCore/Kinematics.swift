struct Kinematics: Equatable, Sendable {
    let place: Place
    let velocity: Velocity

    func at(_ place: Place) -> Kinematics {
        Kinematics(place: place, velocity: velocity)
    }

    func stopped() -> Kinematics {
        Kinematics(place: place, velocity: .still)
    }
}
