struct RoomGrid: Equatable, Sendable {
    let width: Int
    let height: Int
    let cells: [CellKind]
    let decks: [Deck]

    init(width: Int, height: Int, cells: [CellKind], decks: [Deck] = []) {
        self.width = width
        self.height = height
        self.cells = cells
        self.decks = decks
    }
}
