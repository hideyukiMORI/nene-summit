struct Velocity: Equatable, Sendable {
    let x: Int
    let y: Int

    static let still = Velocity(x: 0, y: 0)
}
