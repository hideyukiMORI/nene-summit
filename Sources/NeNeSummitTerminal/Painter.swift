import NeNeSummitRender

enum Painter {
    static func paint(_ glyphs: [Glyph]) -> String {
        var text = ""
        var previous: Glyph.Tone?
        for glyph in glyphs {
            if previous != glyph.tone {
                text += style(glyph.tone)
                previous = glyph.tone
            }
            text.append(glyph.symbol)
        }
        return text
    }

    static func style(_ tone: Glyph.Tone) -> String {
        switch tone {
        case .sky:
            return fill(17)
        case .stone:
            return fill(252)
        case .hazard:
            return fill(160)
        case .flag:
            return fill(44)
        case .crest:
            return fill(220)
        case .climber:
            return fill(214)
        case .banner:
            return "\u{001B}[0;38;5;46m"
        case .mark:
            return "\u{001B}[0;38;5;51m"
        case .quiet:
            return "\u{001B}[0;38;5;245m"
        }
    }

    static func fill(_ code: Int) -> String {
        "\u{001B}[0;48;5;\(code)m"
    }
}
