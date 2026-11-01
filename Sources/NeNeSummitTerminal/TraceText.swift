public enum TraceText {
    public static func bytes(_ bytes: [UInt8]) -> String {
        if bytes.isEmpty {
            return "-"
        }
        return bytes.map(hex).joined(separator: " ")
    }

    public static func strokes(_ strokes: [Stroke]) -> String {
        if strokes.isEmpty {
            return "-"
        }
        return strokes.map(stroke).joined(separator: ",")
    }

    public static func presses(_ presses: [Press]) -> String {
        if presses.isEmpty {
            return "-"
        }
        return presses.map(name).joined(separator: ",")
    }

    static func hex(_ value: UInt8) -> String {
        let digits = Array("0123456789abcdef")
        let hi = digits[Int(value / 16)]
        let lo = digits[Int(value % 16)]
        return "\(hi)\(lo)"
    }

    static func stroke(_ stroke: Stroke) -> String {
        switch stroke {
        case .pressed(let press):
            return "pressed(\(name(press)))"
        case .released(let press):
            return "released(\(name(press)))"
        case .typed(let press):
            return "typed(\(name(press)))"
        }
    }

    static func name(_ press: Press) -> String {
        switch press {
        case .left:
            return "left"
        case .right:
            return "right"
        case .up:
            return "up"
        case .down:
            return "down"
        case .jump:
            return "jump"
        case .dash:
            return "dash"
        case .mode:
            return "mode"
        case .quit:
            return "quit"
        }
    }
}
