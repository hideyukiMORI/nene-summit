struct Slide: Equatable, Sendable {
    let place: Place
    let velocity: Velocity
    let across: SideStop
    let vertical: SideStop

    var kinematics: Kinematics {
        Kinematics(place: place, velocity: velocity)
    }
}
