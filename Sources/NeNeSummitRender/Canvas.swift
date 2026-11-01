import NeNeSummitCore

public enum Canvas {
    public static func draw(_ state: SummitState) -> Frame {
        var lines = banners(state)
        var y = state.room.height - 1
        while y >= 0 {
            lines.append(row(y, state: state))
            y -= 1
        }
        return Frame(lines: lines)
    }

    static func banners(_ state: SummitState) -> [[Glyph]] {
        let title: String
        if state.progress.expedition == .summited {
            title = "頂上に着いた"
        } else {
            title = "矢印か a d で移動  space で跳ぶ  k でダッシュ  q で終了"
        }
        let charges = "ダッシュ \(state.action.charges.remaining)"
        return [line(title), line(charges)]
    }

    static func line(_ text: String) -> [Glyph] {
        text.map { Glyph(symbol: $0, tone: .banner) }
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
