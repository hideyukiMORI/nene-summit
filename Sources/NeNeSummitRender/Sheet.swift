struct Sheet {
    var lines: [[Glyph]]

    static func blank() -> Sheet {
        var lines: [[Glyph]] = []
        let row = Array(repeating: Glyph(symbol: " ", tone: .quiet), count: Stage.columns)
        var index = 0
        while index < Stage.rows {
            lines.append(row)
            index += 1
        }
        return Sheet(lines: lines)
    }

    mutating func stamp(_ row: Int, _ column: Int, _ text: String, _ tone: Glyph.Tone) {
        Ink.lay(&lines, Ink.Mark(row: row, column: column, tone: tone), text)
    }

    mutating func fill(_ row: Int, _ column: Int, _ tone: Glyph.Tone) {
        if row < 0 || row >= lines.count || column < 0 || column >= lines[row].count {
            return
        }
        lines[row][column] = Glyph(symbol: " ", tone: tone)
    }
}
