enum Phase: Equatable, Sendable {
    case grounded
    case air
    case wall(Direction)
}
