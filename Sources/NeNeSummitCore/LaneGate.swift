enum LaneGate {
    private static let vaultWidth = 40

    static func shaft() -> [String] {
        [
            "#..#######################",
            "#..#######################",
            "#ff#######################",
            "#..#######################",
            "#.^#######################",
            "#@..######################",
            "##########################",
        ]
    }

    static func vault() -> [String] {
        var rows: [String] = []
        var y = 7
        while y >= 0 {
            rows.append(vaultLine(y))
            y -= 1
        }
        return rows
    }

    private static func vaultLine(_ y: Int) -> String {
        var row = ""
        var x = 0
        while x < vaultWidth {
            row.append(vaultCell(x: x, y: y))
            x += 1
        }
        return row
    }

    private static func vaultCell(x: Int, y: Int) -> Character {
        if y == 1 && x == 2 {
            return "@"
        }
        if y == 1 && x == 3 {
            return "$"
        }
        if y == 1 && x == 5 {
            return "o"
        }
        if vaultCrumble(x: x, y: y) {
            return "f"
        }
        if vaultSpike(x) && y == 0 {
            return "^"
        }
        if vaultSolid(x: x, y: y) {
            return "#"
        }
        return "."
    }

    private static func vaultCrumble(x: Int, y: Int) -> Bool {
        y == 0 && x >= 16 && x <= 18
    }

    private static func vaultSpike(_ x: Int) -> Bool {
        (x >= 6 && x <= 9) || (x >= 24 && x <= 27)
    }

    private static func vaultSolid(x: Int, y: Int) -> Bool {
        if x <= 1 || y >= 4 {
            return true
        }
        if x == vaultWidth - 1 {
            return y != 1 && y != 2
        }
        return y == 0 && !vaultSpike(x) && !vaultCrumble(x: x, y: y)
    }
}
