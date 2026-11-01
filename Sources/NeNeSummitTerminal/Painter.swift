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
            return fill(24)
        case .ridge:
            return fill(60)
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
            return fill(159)
        case .spark:
            return fill(123)
        case .veil:
            return fill(17)
        default:
            return fill(24)
        }
    }

    static func script(_ tone: Glyph.Tone) -> String {
        switch tone {
        case .banner:
            return ink(159, 17)
        case .mark:
            return ink(223, 236)
        case .hint:
            return ink(152, 17)
        case .quiet:
            return ink(152, 236)
        default:
            return ink(152, 236)
        }
    }

    static func fill(_ code: Int) -> String {
        "\u{001B}[0;48;5;\(code)m"
    }

    static func ink(_ code: Int, _ ground: Int) -> String {
        "\u{001B}[0;38;5;\(code);48;5;\(ground)m"
    }
}
