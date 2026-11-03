enum LaneB {
    static func rows(_ index: Int) -> [String] {
        switch index {
        case 5:
            return shaft()
        case 6:
            return lift()
        case 7:
            return vault()
        case 8:
            return ferry()
        default:
            return spire()
        }
    }

    private static func shaft() -> [String] {
        [
            "#..#######################",
            "#..#######################",
            "#.^#######################",
            "#@..######################",
            "##########################",
        ]
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

    private static func vault() -> [String] {
        [
            "..........................",
            "..........................",
            "$.@.......................",
            "####^^^^########^^########",
        ]
    }

    private static func ferry() -> [String] {
        [
            "......................#..#",
            "......................#..#",
            "..........................",
            "..@.......................",
            "####MMM^^^^^^^############",
        ]
    }

    private static let spireWidth = 42
    private static let spireHeight = 22

    private static func spire() -> [String] {
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
        if spireSolid(x: x, y: y) {
            return "#"
        }
        return "."
    }

    private static func spireSolid(x: Int, y: Int) -> Bool {
        if y == 0 {
            return true
        }
        return spireStep(x: x, y: y)
    }

    private static func spireStep(x: Int, y: Int) -> Bool {
        if x < 2 || x > 41 {
            return false
        }
        let level = 1 + (x - 2) / 2
        return y == level && level <= 20
    }
}
