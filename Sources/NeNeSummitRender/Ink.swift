enum Ink {
    struct Mark {
        let row: Int
        let column: Int
        let tone: Glyph.Tone
    }

    static func lay(_ lines: inout [[Glyph]], _ mark: Mark, _ text: String) {
        var column = mark.column
        for character in text {
            if mark.row < 0 || mark.row >= lines.count || column >= Stage.columns {
                return
            }
            lines[mark.row][column] = Glyph(symbol: character, tone: mark.tone)
            column += 1
        }
    }

    static func wrap(_ text: String, width: Int) -> [String] {
        if text.isEmpty {
            return ["..."]
        }
        var rows: [String] = []
        var line = ""
        for word in text.split(separator: " ") {
            line = join(&rows, line: line, word: String(word), width: width)
        }
        if !line.isEmpty {
            rows.append(line)
        }
        return rows
    }

    static func join(_ rows: inout [String], line: String, word: String, width: Int) -> String {
        if line.isEmpty {
            return clip(word, width: width)
        }
        if line.count + 1 + word.count <= width {
            return line + " " + word
        }
        rows.append(line)
        return clip(word, width: width)
    }

    static func clip(_ text: String, width: Int) -> String {
        String(text.prefix(width))
    }
}
