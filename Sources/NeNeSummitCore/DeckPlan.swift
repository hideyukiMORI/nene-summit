enum DeckPlan {
    static func collect(rows: [String]) -> [Deck] {
        var decks: [Deck] = []
        for (index, row) in rows.enumerated() {
            let y = rows.count - 1 - index
            decks.append(contentsOf: runs(row, y: y, mark: "M", axis: .horizontal))
            decks.append(contentsOf: runs(row, y: y, mark: "V", axis: .vertical))
        }
        return decks
    }

    static func runs(_ row: String, y: Int, mark: Character, axis: Axis) -> [Deck] {
        var decks: [Deck] = []
        var x = 0
        let characters = Array(row)
        while x < characters.count {
            if characters[x] == mark {
                let start = x
                while x < characters.count && characters[x] == mark {
                    x += 1
                }
                decks.append(deck(x: start, y: y, width: x - start, axis: axis))
            } else {
                x += 1
            }
        }
        return decks
    }

    static func deck(x: Int, y: Int, width: Int, axis: Axis) -> Deck {
        Deck(
            origin: CellPoint(x: x, y: y),
            size: CellPoint(x: width, y: 1),
            axis: axis,
            reach: MotionPolicy.deckReach
        )
    }
}
