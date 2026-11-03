enum LaneC {
    static let spanWidth = 40

    static func rows(_ index: Int) -> [String] {
        if index == 10 {
            return bloom()
        }
        if index == 11 {
            return span()
        }
        return climb()
    }

    private static func bloom() -> [String] {
        var rows: [String] = []
        var y = 15
        while y >= 0 {
            rows.append(bloomLine(y))
            y -= 1
        }
        return rows
    }

    private static func bloomLine(_ y: Int) -> String {
        var row = ""
        var x = 0
        while x < 26 {
            row.append(bloomCell(x: x, y: y))
            x += 1
        }
        return row
    }

    private static func bloomCell(x: Int, y: Int) -> Character {
        if y == 1 && x == 2 {
            return "@"
        }
        if y == 1 && x == 5 {
            return "*"
        }
        if bloomSolid(x: x, y: y) {
            return "#"
        }
        return "."
    }

    private static func bloomSolid(x: Int, y: Int) -> Bool {
        if y == 0 {
            return true
        }
        if y == 8 && x >= 10 && x <= 24 {
            return true
        }
        return x == 25 && y != 9 && y != 10
    }

    private static func span() -> [String] {
        var rows: [String] = []
        var above = 0
        while above < 18 {
            rows.append(String(repeating: ".", count: spanWidth))
            above += 1
        }
        rows.append(spanLine(mark: "@", at: 0))
        rows.append(spanLine(mark: "", at: 0))
        rows.append(spanLine(mark: "DDD", at: 16))
        rows.append(spanLine(mark: "", at: 0))
        rows.append(spanLine(mark: "o$", at: 0))
        rows.append(spanFloor())
        return rows
    }

    private static func spanLine(mark: String, at start: Int) -> String {
        var row = ""
        var x = 0
        while x < spanWidth {
            row.append(spanMark(mark, at: start, x: x))
            x += 1
        }
        return row
    }

    private static func spanMark(_ mark: String, at start: Int, x: Int) -> Character {
        let offset = x - start
        if offset >= 0 && offset < mark.count {
            return mark[mark.index(mark.startIndex, offsetBy: offset)]
        }
        return "."
    }

    private static func spanFloor() -> String {
        var row = ""
        var x = 0
        while x < spanWidth {
            row.append(spanGround(x))
            x += 1
        }
        return row
    }

    private static func spanGround(_ x: Int) -> Character {
        if x < 3 {
            return "f"
        }
        if x == 7 {
            return "^"
        }
        return "#"
    }

    private static func climb() -> [String] {
        var rows: [String] = []
        var y = LaneA.climbHeight - 1
        while y >= 0 {
            rows.append(LaneA.climbLine(y, flag: false))
            y -= 1
        }
        return rows
    }
}
