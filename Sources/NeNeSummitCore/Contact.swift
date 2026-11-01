enum Contact: Equatable, Sendable {
    case none
    case spike
    case checkpoint(CellPoint)
    case summit
    case spring
}
