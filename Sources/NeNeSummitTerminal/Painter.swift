import NeNeSummitRender

enum Painter {
    static func paint(_ glyphs: [Glyph]) -> String {
        var text = ""
        for glyph in glyphs {
            text += color(glyph.tone)
            text.append(glyph.symbol)
        }
        return text
    }

    static func color(_ tone: Glyph.Tone) -> String {
        switch tone {
        case .sky:
            return "\u{001B}[0m"
        case .stone:
            return "\u{001B}[37m"
        case .hazard:
            return "\u{001B}[31m"
        case .mark:
            return "\u{001B}[36m"
        case .climber:
            return "\u{001B}[33m"
        case .banner:
            return "\u{001B}[32m"
        case .quiet:
            return "\u{001B}[2m"
        }
    }
}
