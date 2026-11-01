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
        case .sky, .ridge, .stone, .hazard, .flag:
            return terrain(tone)
        case .crest, .climber, .spring, .gleam, .spark, .veil:
            return accent(tone)
        case .banner, .mark, .quiet, .hint:
            return script(tone)
        }
    }

    static func terrain(_ tone: Glyph.Tone) -> String {
        switch tone {
        case .sky:
            return fill(16)
        case .ridge:
            return fill(18)
        case .stone:
            return fill(67)
        case .hazard:
            return fill(168)
        case .flag:
            return fill(80)
        default:
            return fill(24)
        }
    }

    static func accent(_ tone: Glyph.Tone) -> String {
        switch tone {
        case .crest:
            return fill(229)
        case .climber:
            return fill(203)
        case .spring:
            return fill(85)
        case .gleam:
            return fill(44)
        case .spark:
            return ink(24, 16)
        case .veil:
            return fill(16)
        default:
            return fill(24)
        }
    }

    static func script(_ tone: Glyph.Tone) -> String {
        switch tone {
        case .banner:
            return ink(152, 16)
        case .mark:
            return ink(223, 16)
        case .hint:
            return ink(152, 16)
        case .quiet:
            return ink(152, 16)
        default:
            return ink(152, 16)
        }
    }

    static func fill(_ code: Int) -> String {
        "\u{001B}[0;48;5;\(code)m"
    }

    static func ink(_ code: Int, _ ground: Int) -> String {
        "\u{001B}[0;38;5;\(code);48;5;\(ground)m"
    }
}
