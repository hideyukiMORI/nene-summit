enum LaneRide {
    private static let ferryWidth = 36
    private static let ferryHeight = 14
    private static let spireWidth = 42
    private static let spireHeight = 22

    static func ferry() -> [String] {
        var rows: [String] = []
        var y = ferryHeight - 1
        while y >= 0 {
            rows.append(ferryLine(y))
            y -= 1
        }
        return rows
    }

    private static func ferryLine(_ y: Int) -> String {
        var row = ""
        var x = 0
        while x < ferryWidth {
            row.append(ferryCell(x: x, y: y))
            x += 1
        }
        return row
    }

    private static func ferryCell(x: Int, y: Int) -> Character {
        if y == 1 && x == 2 {
            return "@"
        }
        if ferryCrumble(x: x, y: y) {
            return "f"
        }
        if ferryDeck(x) && y == 0 {
            return "M"
        }
        if y == 0 && x >= 7 && x <= 14 {
            return "^"
        }
        if y == 11 && x >= 28 && x <= 30 {
            return "D"
        }
        if ferrySolid(x: x, y: y) {
            return "#"
        }
        return "."
    }

    private static func ferryCrumble(x: Int, y: Int) -> Bool {
        y == 8 && x >= 26 && x <= 29
    }

    private static func ferrySolid(x: Int, y: Int) -> Bool {
        if ferryDeck(x) && y == 0 {
            return false
        }
        if y == 0 && x >= 7 && x <= 14 {
            return false
        }
        if y == 0 {
            return true
        }
        if y == 3 && x <= 16 {
            return true
        }
        if y == 8 && x >= 24 && x <= 34 && !ferryCrumble(x: x, y: y) {
            return true
        }
        if x == ferryWidth - 1 {
            return y != 8 && y != 9
        }
        return ferryStep(x: x, y: y)
    }

    private static func ferryDeck(_ x: Int) -> Bool {
        x >= 4 && x <= 6
    }

    private static func ferryStep(x: Int, y: Int) -> Bool {
        if x < 18 || x > 32 {
            return false
        }
        let level = 1 + (x - 18) / 2
        return y == level && level <= 8
    }

    static func spire() -> [String] {
        var rows: [String] = []
        var y = spireHeight - 1
        while y >= 0 {
            rows.append(spireLine(y))
            y -= 1
        }
        return rows
    }

    private static func spireLine(_ y: Int) -> String {
        var row = ""
        var x = 0
        while x < spireWidth {
            row.append(spireCell(x: x, y: y))
            x += 1
        }
        return row
    }

    private static func spireCell(x: Int, y: Int) -> Character {
        if y == 2 && x == 2 {
            return "@"
        }
        if let hole = spireHole(x: x, y: y) {
            return hole
        }
        if y == 16 && x >= 28 && x <= 30 {
            return "D"
        }
        if spireSolid(x: x, y: y) {
            return "#"
        }
        return "."
    }

    private static func spireHole(x: Int, y: Int) -> Character? {
        if !spireCut(x) {
            return nil
        }
        if spireBridge(x) && y == 4 {
            return "f"
        }
        if y == 1 {
            return "^"
        }
        if y == 0 {
            return "#"
        }
        return "."
    }

    private static func spireCut(_ x: Int) -> Bool {
        spireBridge(x) || x == 18 || x == 19
    }

    private static func spireBridge(_ x: Int) -> Bool {
        x == 8 || x == 9
    }

    private static func spireSolid(x: Int, y: Int) -> Bool {
        if spireCut(x) {
            return false
        }
        if y == 0 || spireBuried(x: x, y: y) || spireRoof(x: x, y: y) {
            return true
        }
        return spireStep(x: x, y: y)
    }

    private static func spireRoof(x: Int, y: Int) -> Bool {
        if spireCut(x) || x < 2 || x > 41 {
            return false
        }
        let level = 1 + (x - 2) / 2
        return level <= 16 && y == level + 4
    }

    private static func spireBuried(x: Int, y: Int) -> Bool {
        if x < 2 || x > 41 {
            return false
        }
        let level = 1 + (x - 2) / 2
        return y > 0 && y < level && level <= 20
    }

    private static func spireStep(x: Int, y: Int) -> Bool {
        if x < 2 || x > 41 {
            return false
        }
        let level = 1 + (x - 2) / 2
        return y == level && level <= 20
    }
}
