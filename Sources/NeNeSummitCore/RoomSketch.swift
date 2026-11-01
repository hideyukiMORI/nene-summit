enum RoomSketch {
    struct Mark {
        let cell: CellKind
        let spawn: Bool
    }

    struct Filled {
        let cells: [CellKind]
        let spawn: CellPoint
    }

    static func room(named name: String, rows: [String], ascent: Ascent) -> Room {
        switch assemble(named: name, rows: rows, ascent: ascent) {
        case .success(let room):
            return room
        case .failure:
            preconditionFailure("部屋が作れない")
        }
    }

    static func assemble(named name: String, rows: [String], ascent: Ascent) -> Result<Room, Room.Rejection> {
        let height = rows.count
        let width = rows[0].count
        if rows.contains(where: { $0.count != width }) {
            preconditionFailure("部屋の行の長さが揃っていない")
        }
        let filled = fill(rows: rows, width: width, height: height)
        switch RoomId.make(value: name) {
        case .failure:
            preconditionFailure("部屋名が空")
        case .success(let id):
            let grid = RoomGrid(width: width, height: height, cells: filled.cells)
            let spec = RoomSpec(id: id, spawn: filled.spawn, grid: grid, ascent: ascent)
            return Room.make(spec)
        }
    }

    static func fill(rows: [String], width: Int, height: Int) -> Filled {
        var cells = [CellKind](repeating: .open, count: width * height)
        var spawn = CellPoint(x: 0, y: 0)
        for (index, row) in rows.enumerated() {
            let y = height - 1 - index
            for (x, character) in row.enumerated() {
                let mark = mark(character)
                cells[y * width + x] = mark.cell
                if mark.spawn {
                    spawn = CellPoint(x: x, y: y)
                }
            }
        }
        return Filled(cells: cells, spawn: spawn)
    }

    static func mark(_ character: Character) -> Mark {
        switch character {
        case ".":
            return Mark(cell: .open, spawn: false)
        case "#":
            return Mark(cell: .solid, spawn: false)
        case "^":
            return Mark(cell: .spike, spawn: false)
        case "C":
            return Mark(cell: .checkpoint, spawn: false)
        case "S":
            return Mark(cell: .summit, spawn: false)
        case "@":
            return Mark(cell: .open, spawn: true)
        default:
            preconditionFailure("未知のマス")
        }
    }
}
