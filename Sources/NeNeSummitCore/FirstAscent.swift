public enum FirstAscent {
    struct Mark {
        let cell: CellKind
        let spawn: Bool
    }

    static let rows = [
        "................................",
        "................................",
        "................................",
        "................................",
        "................................",
        "................................",
        "....................SSSSSSSSSSS.",
        "....................###########.",
        "................................",
        "..........#########.............",
        "..@C...^........................",
        "################################",
    ]

    public static func make() -> Room {
        switch assemble() {
        case .success(let room):
            return room
        case .failure:
            preconditionFailure("最初の部屋が作れない")
        }
    }

    static func assemble() -> Result<Room, Room.Rejection> {
        let height = rows.count
        let width = rows[0].count
        if rows.contains(where: { $0.count != width }) {
            preconditionFailure("部屋の行の長さが揃っていない")
        }
        let filled = fill(width: width, height: height)
        switch RoomId.make(value: "first-ascent") {
        case .failure:
            preconditionFailure("部屋名が空")
        case .success(let id):
            let grid = RoomGrid(width: width, height: height, cells: filled.cells)
            return Room.make(RoomSpec(id: id, spawn: filled.spawn, grid: grid))
        }
    }

    static func fill(width: Int, height: Int) -> (cells: [CellKind], spawn: CellPoint) {
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
        return (cells, spawn)
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
