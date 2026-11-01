public struct Action: Equatable, Sendable {
    let facing: Direction
    public let phase: Phase
    let dashTicks: Int
    public let charges: DashCharges
}
