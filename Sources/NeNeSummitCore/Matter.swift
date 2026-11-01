struct Matter: Equatable, Sendable {
    let room: Room
    let tick: Int

    func kind(x: Int, y: Int) -> CellKind {
        if DeckField.covers(room, x: x, y: y, tick: tick) {
            return .solid
        }
        return room.kind(x: x, y: y)
    }
}
