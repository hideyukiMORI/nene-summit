enum LaneC {
    static let spanWidth = 40
    private static let spanHeight = 16
    private static let gulfWidth = 40
    private static let gulfHeight = 18

    static func rows(_ index: Int) -> [String] {
        if index == 10 {
            return bloom()
        }
        if index == 11 {
            return span()
        }
        if index == 12 {
            return gulf()
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
        if bloomCrumble(x: x, y: y) {
            return "f"
        }
        if bloomSolid(x: x, y: y) {
            return "#"
        }
        return "."
    }

    private static func bloomCrumble(x: Int, y: Int) -> Bool {
        y == 8 && x >= 14 && x <= 17
    }

    private static func bloomSolid(x: Int, y: Int) -> Bool {
        if y == 0 {
            return true
        }
        if y == 8 && x >= 10 && x <= 24 && !bloomCrumble(x: x, y: y) {
            return true
        }
        return x == 25 && y != 9 && y != 10
    }

    private struct Fold {
        let width: Int
        let lip: Int
        let dash: Bool
    }

    private static func span() -> [String] {
        folded(Fold(width: spanWidth, lip: 1, dash: false), height: spanHeight)
    }

    private static func gulf() -> [String] {
        folded(Fold(width: gulfWidth, lip: 1, dash: true), height: 8)
    }

    private static func folded(_ spec: Fold, height: Int) -> [String] {
        var rows: [String] = []
        var y = height - 1
        while y >= 0 {
            rows.append(foldLine(y, spec: spec))
            y -= 1
        }
        return rows
    }

    private static func foldLine(_ y: Int, spec: Fold) -> String {
        var row = ""
        var x = 0
        while x < spec.width {
            row.append(foldCell(x: x, y: y, spec: spec))
            x += 1
        }
        return row
    }

    private static func foldCell(x: Int, y: Int, spec: Fold) -> Character {
        if let mark = foldMark(x: x, y: y, spec: spec) {
            return mark
        }
        if foldSolid(x: x, y: y, spec: spec) {
            return "#"
        }
        return "."
    }

    private static func foldMark(x: Int, y: Int, spec: Fold) -> Character? {
        if y == 1 && x == 2 {
            return "@"
        }
        if y == 1 && x == 3 {
            return "o"
        }
        if y == 1 && x == 5 {
            return "$"
        }
        if foldCrumble(x: x, y: y, spec: spec) {
            return "f"
        }
        if foldSpike(x: x, y: y, spec: spec) {
            return "^"
        }
        if spec.lip > 2 && y == spec.lip + 3 && x >= 28 && x <= 30 {
            return "D"
        }
        return nil
    }

    private static func foldCrumble(x: Int, y: Int, spec: Fold) -> Bool {
        if spec.lip > 2 {
            return y == spec.lip && x >= 30 && x <= 33
        }
        return y == 0 && x >= 16 && x <= 18
    }

    private static func foldSpike(x: Int, y: Int, spec: Fold) -> Bool {
        if y != 0 {
            return false
        }
        if x >= 6 && x <= 9 {
            return true
        }
        return spec.dash && x >= 24 && x <= 27
    }

    private static func foldSolid(x: Int, y: Int, spec: Fold) -> Bool {
        if foldCrumble(x: x, y: y, spec: spec) || foldSpike(x: x, y: y, spec: spec) {
            return false
        }
        if x <= 1 || y >= 4 || y == 0 {
            return true
        }
        if spec.lip > 2 && y == spec.lip && x >= 26 && x < spec.width - 1 {
            return true
        }
        if x == spec.width - 1 {
            return y != spec.lip && y != spec.lip + 1
        }
        return foldStep(x: x, y: y, lip: spec.lip)
    }

    private static func foldStep(x: Int, y: Int, lip: Int) -> Bool {
        if x < 16 || x > 36 {
            return false
        }
        let level = 2 + (x - 16) / 2
        return y == level && level <= lip
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
