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
            return fill(18)
        case .stone:
            return fill(137)
        case .hazard:
            return fill(160)
        case .flag:
            return fill(37)
        case .crest:
            return fill(220)
        case .climber:
            return fill(214)
        case .spring:
            return fill(119)
        case .banner:
            return ink(156)
        case .mark:
            return ink(186)
        case .quiet:
            return ink(249)
        }
    }

    static func fill(_ code: Int) -> String {
        "\u{001B}[0;48;5;\(code)m"
    }

    static func ink(_ code: Int) -> String {
        "\u{001B}[0;38;5;\(code);48;5;234m"
    }
}
