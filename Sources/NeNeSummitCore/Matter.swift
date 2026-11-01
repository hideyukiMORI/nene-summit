struct Matter: Equatable, Sendable {
    let room: Room
    let tick: Int

    func kind(x: Int, y: Int) -> CellKind {
        if DeckField.covers(room, x: x, y: y, tick: tick) {
            return .solid
        }
        let kind = room.kind(x: x, y: y)
        if kind == .crumble {
            if Crumble.holds(tick) {
                return .solid
            }
            return .open
        }
        return kind
    }

    func crushes(x: Int, y: Int) -> Bool {
        DeckField.crushes(room, x: x, y: y, tick: tick)
    }
}
