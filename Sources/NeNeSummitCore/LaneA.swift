enum LaneA {
    static func rows(_ index: Int) -> [String] {
        switch index {
        case 0:
            return rise()
        case 1:
            return ledge()
        case 2:
            return pit()
        case 3:
            return cross()
        default:
            return well()
        }
    }

    static let climbWidth = 64
    static let climbHeight = 32

    private static func rise() -> [String] {
        var rows: [String] = []
        var y = climbHeight - 1
        while y >= 0 {
            rows.append(climbLine(y, flag: false))
            y -= 1
        }
        return rows
    }

    static func climbLine(_ y: Int, flag: Bool) -> String {
        var row = ""
        var x = 0
        while x < climbWidth {
            row.append(climbCell(x: x, y: y, flag: flag))
            x += 1
        }
        return row
    }

    static func climbCell(x: Int, y: Int, flag: Bool) -> Character {
        if let mark = climbMark(x: x, y: y, flag: flag) {
            return mark
        }
        if flag && y == 0 && x >= 2 && x <= 7 {
            return "."
        }
        if y == 0 || climbStep(x: x, y: y) {
            return "#"
        }
        return "."
    }

    static func climbMark(x: Int, y: Int, flag: Bool) -> Character? {
        if y == 2 && x == 2 {
            return "@"
        }
        if flag && y == 1 && x >= 2 && x <= 7 {
            return "f"
        }
        if flag && x == 58 && y >= 30 && y <= 31 {
            return "S"
        }
        return nil
    }

    static func climbStep(x: Int, y: Int) -> Bool {
        if x < 2 || x > 61 {
            return false
        }
        let level = 1 + (x - 2) / 2
        return y == level && level <= 30
    }

    private static func ledge() -> [String] {
        [
            "..........................",
            ".........................#",
            ".........................#",
            "................^^.......#",
            "###################fff...#",
            "######################...#",
            "######################..@#",
            "##########################",
        ]
    }

    private static func pit() -> [String] {
        [
            "..........................",
            "..........................",
            "..........................",
            "..............^^.....$o@..",
            "########..################",
        ]
    }

    private static func cross() -> [String] {
        var rows: [String] = []
        var above = 0
        while above < 14 {
            rows.append(String(repeating: ".", count: 26))
            above += 1
        }
        rows.append("@.........................")
        rows.append("..........................")
        rows.append("................DDD.......")
        rows.append("..........................")
        rows.append("o$........................")
        rows.append("fff####^##################")
        return rows
    }

    private static func well() -> [String] {
        [
            "..........................",
            "#.........................",
            "#.........................",
            "#.......^^................",
            "#...fff###################",
            "#...######################",
            "#@..######################",
            "##########################",
        ]
    }
}
