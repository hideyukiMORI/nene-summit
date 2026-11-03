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
        case .sky, .cloud, .ridge, .mist, .stone, .hazard, .flag:
            return terrain(tone)
        case .crest, .climber, .spring, .gleam, .coin, .spark, .veil:
            return accent(tone)
        case .banner, .mark, .quiet, .hint, .ink:
            return script(tone)
        }
    }

    static func terrain(_ tone: Glyph.Tone) -> String {
        switch tone {
        case .sky:
            return fill(16)
        case .cloud:
            return ink(152, 16)
        case .ridge:
            return ink(109, 16)
        case .mist:
            return ink(146, 16)
        case .stone:
            return ink(159, 16)
        case .hazard:
            return ink(255, 16)
        case .flag:
            return ink(123, 16)
        default:
            return fill(24)
        }
    }

    static func accent(_ tone: Glyph.Tone) -> String {
        switch tone {
        case .crest:
            return ink(229, 16)
        case .climber:
            return ink(203, 16)
        case .spring:
            return ink(195, 16)
        case .gleam:
            return ink(204, 16)
        case .coin:
            return ink(220, 16)
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
        case .ink:
            return "\u{001B}[0;38;5;16;48;5;252m"
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
