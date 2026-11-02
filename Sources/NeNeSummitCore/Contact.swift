enum Contact: Equatable, Sendable {
    case none
    case spike
    case checkpoint(CellPoint)
    case summit
    case exit
    case spring
    case gleam(CellPoint)
    case coin(CellPoint)
    case refill
}
