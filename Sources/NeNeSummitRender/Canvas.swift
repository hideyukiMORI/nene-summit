import NeNeSummitCore

public enum Canvas {
    public static func draw(_ state: SummitState) -> Frame {
        var lines: [[Glyph]] = []
        var y = state.room.height - 1
        while y >= 0 {
            lines.append(row(y, state: state))
            y -= 1
        }
        lines.append(contentsOf: strip(state))
        return Frame(lines: lines)
    }

    static func strip(_ state: SummitState) -> [[Glyph]] {
        [heading(state), dash(state), line("a d  move   space jump   k dash   q quit", tone: .quiet)]
    }

    static func heading(_ state: SummitState) -> [Glyph] {
        if state.progress.expedition == .summited {
            return line("頂上に着いた", tone: .banner)
        }
        return line("NENE SUMMIT", tone: .banner)
    }

    static func dash(_ state: SummitState) -> [Glyph] {
        let pip = state.action.charges.remaining > 0 ? "*" : "-"
        return line("DASH ", tone: .quiet) + line(String(pip), tone: .mark)
    }

    static func line(_ text: String, tone: Glyph.Tone) -> [Glyph] {
        text.map { Glyph(symbol: $0, tone: tone) }
    }

    static func row(_ y: Int, state: SummitState) -> [Glyph] {
        let portrait = state.portrait()
        var glyphs: [Glyph] = []
        var x = 0
        while x < state.room.width {
            if portrait.x == x && portrait.y == y {
                glyphs.append(Glyph(symbol: "A", tone: .climber))
            } else {
                glyphs.append(glyph(state.room.kind(x: x, y: y)))
            }
            x += 1
        }
        return glyphs
    }

    static func glyph(_ kind: CellKind) -> Glyph {
        switch kind {
        case .open:
            return Glyph(symbol: " ", tone: .sky)
        case .solid:
            return Glyph(symbol: "#", tone: .stone)
        case .spike:
            return Glyph(symbol: "^", tone: .hazard)
        case .checkpoint:
            return Glyph(symbol: "+", tone: .mark)
        case .summit:
            return Glyph(symbol: "*", tone: .mark)
        }
    }
}
