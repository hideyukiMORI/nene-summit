public struct Action: Equatable, Sendable {
    let facing: Direction
    let phase: Phase
    let dashTicks: Int
    public let charges: DashCharges
}
