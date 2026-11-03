enum LaneB {
    static func rows(_ index: Int) -> [String] {
        switch index {
        case 5:
            return LaneGate.shaft()
        case 6:
            return lift()
        case 7:
            return LaneGate.vault()
        case 8:
            return LaneRide.ferry()
        default:
            return LaneRide.spire()
        }
    }

    private static func lift() -> [String] {
        var rows: [String] = []
        var y = 27
        while y >= 0 {
            rows.append(liftLine(y))
            y -= 1
        }
        return rows
    }

    private static func liftLine(_ y: Int) -> String {
        var row = ""
        var x = 0
        while x < 26 {
            row.append(liftCell(x: x, y: y))
            x += 1
        }
        return row
    }

    private static func liftCell(x: Int, y: Int) -> Character {
        if let mark = liftMark(x: x, y: y) {
            return mark
        }
        if liftSolid(x: x, y: y) {
            return "#"
        }
        if liftPit(x: x, y: y) {
            return "^"
        }
        return "."
    }

    private static func liftMark(x: Int, y: Int) -> Character? {
        if y == 2 && x == 2 {
            return "@"
        }
        if y == 12 && x == 22 {
            return "V"
        }
        return nil
    }

    private static func liftSolid(x: Int, y: Int) -> Bool {
        if y == 0 || liftStep(x: x, y: y) {
            return true
        }
        if liftWall(x: x, y: y) {
            return true
        }
        return liftShelf(x: x, y: y)
    }

    private static func liftWall(x: Int, y: Int) -> Bool {
        if x != 25 {
            return false
        }
        return y != 20 && y != 21
    }

    private static func liftShelf(x: Int, y: Int) -> Bool {
        if y == 13 && x <= 20 {
            return true
        }
        return y == 19 && x >= 23 && x <= 24
    }

    private static func liftStep(x: Int, y: Int) -> Bool {
        if x < 2 || x > 21 {
            return false
        }
        let level = 1 + (x - 2) / 2
        return y == level && level <= 11
    }

    private static func liftPit(x: Int, y: Int) -> Bool {
        if x < 22 || x > 24 {
            return false
        }
        return y >= 1 && y <= 10
    }
}
