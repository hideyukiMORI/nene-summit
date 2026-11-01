struct RoomGrid: Equatable, Sendable {
    let width: Int
    let height: Int
    let cells: [CellKind]
}
