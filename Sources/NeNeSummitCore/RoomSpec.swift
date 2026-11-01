struct RoomSpec: Equatable, Sendable {
    let id: RoomId
    let spawn: CellPoint
    let grid: RoomGrid
}
