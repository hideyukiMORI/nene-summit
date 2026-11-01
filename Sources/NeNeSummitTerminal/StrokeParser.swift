enum StrokeParser {
    struct Read: Equatable, Sendable {
        let strokes: [Stroke]
        let consumed: Int
    }

    struct Piece: Equatable, Sendable {
        let stroke: Stroke?
        let consumed: Int
    }

    static func parse(_ bytes: [UInt8]) -> Read {
        var strokes: [Stroke] = []
        var index = 0
        while index < bytes.count {
            let piece = one(bytes, index: index)
            if piece.consumed == 0 {
                break
            }
            if let stroke = piece.stroke {
                strokes.append(stroke)
            }
            index += piece.consumed
        }
        return Read(strokes: strokes, consumed: index)
    }

    static func one(_ bytes: [UInt8], index: Int) -> Piece {
        if bytes[index] != 0x1B {
            return Piece(stroke: plain(bytes[index]).map { .typed($0) }, consumed: 1)
        }
        return escape(bytes, index: index)
    }

    static func escape(_ bytes: [UInt8], index: Int) -> Piece {
        if index + 1 >= bytes.count {
            return Piece(stroke: nil, consumed: 0)
        }
        let intro = bytes[index + 1]
        if intro == UInt8(ascii: "[") {
            return csi(bytes, index: index)
        }
        if intro == UInt8(ascii: "O") {
            return ss3(bytes, index: index)
        }
        return Piece(stroke: nil, consumed: 1)
    }

    static func ss3(_ bytes: [UInt8], index: Int) -> Piece {
        if index + 2 >= bytes.count {
            return Piece(stroke: nil, consumed: 0)
        }
        let stroke = arrowPress(bytes[index + 2]).map { Stroke.typed($0) }
        return Piece(stroke: stroke, consumed: 3)
    }

    static func csi(_ bytes: [UInt8], index: Int) -> Piece {
        let end = terminator(bytes, from: index + 2)
        if end >= bytes.count {
            return Piece(stroke: nil, consumed: 0)
        }
        let body = Array(bytes[(index + 2)..<end])
        return Piece(stroke: classify(body, final: bytes[end]), consumed: end - index + 1)
    }

    static func terminator(_ bytes: [UInt8], from start: Int) -> Int {
        var cursor = start
        while cursor < bytes.count, !isFinal(bytes[cursor]) {
            cursor += 1
        }
        return cursor
    }

    static func isFinal(_ byte: UInt8) -> Bool {
        byte >= 0x40 && byte <= 0x7E
    }

    static func classify(_ body: [UInt8], final: UInt8) -> Stroke? {
        if final == UInt8(ascii: "_") {
            return win32(body)
        }
        if final == UInt8(ascii: "u") {
            return kitty(body)
        }
        return marked(body, final: final)
    }

    static func marked(_ body: [UInt8], final: UInt8) -> Stroke? {
        guard let press = arrowPress(final) else {
            return nil
        }
        return phased(press, event: eventNumber(body))
    }

    static func kitty(_ body: [UInt8]) -> Stroke? {
        guard let code = leading(body), let press = fromCode(code) else {
            return nil
        }
        return phased(press, event: eventNumber(body))
    }

    static func phased(_ press: Press, event: Int?) -> Stroke {
        if event == nil {
            return .typed(press)
        }
        if event == 3 {
            return .released(press)
        }
        return .pressed(press)
    }

    static func win32(_ body: [UInt8]) -> Stroke? {
        let values = fields(body)
        let virtualKey = value(values, at: 0)
        let unicode = value(values, at: 2)
        let down = value(values, at: 3)
        guard let press = virtual(virtualKey) ?? fromCode(unicode) else {
            return nil
        }
        if down == 0 {
            return .released(press)
        }
        return .pressed(press)
    }

    static func value(_ values: [Int], at index: Int) -> Int {
        if index < values.count {
            return values[index]
        }
        return 0
    }

    static func fields(_ body: [UInt8]) -> [Int] {
        var values: [Int] = []
        var current = 0
        var seen = false
        for byte in body {
            if byte == UInt8(ascii: ";") {
                values.append(seen ? current : 0)
                current = 0
                seen = false
            } else if let number = digit(byte) {
                current = widen(current, digit: number)
                seen = true
            }
        }
        values.append(seen ? current : 0)
        return values
    }

    static func widen(_ current: Int, digit: Int) -> Int {
        if current > 100_000 {
            return current
        }
        return current * 10 + digit
    }

    static func eventNumber(_ body: [UInt8]) -> Int? {
        guard let colon = body.firstIndex(of: UInt8(ascii: ":")) else {
            return nil
        }
        return leading(Array(body[(colon + 1)...]))
    }

    static func leading(_ body: [UInt8]) -> Int? {
        var value = 0
        var seen = false
        for byte in body {
            guard let number = digit(byte) else {
                break
            }
            value = widen(value, digit: number)
            seen = true
        }
        if seen {
            return value
        }
        return nil
    }

    static func digit(_ byte: UInt8) -> Int? {
        let zero = UInt8(ascii: "0")
        if byte < zero || byte > UInt8(ascii: "9") {
            return nil
        }
        return Int(byte - zero)
    }

    static func fromCode(_ code: Int) -> Press? {
        if code < 0 || code > 127 {
            return nil
        }
        return plain(UInt8(code))
    }

    static func plain(_ byte: UInt8) -> Press? {
        let table: [(UInt8, Press)] = [
            (UInt8(ascii: "a"), .left), (UInt8(ascii: "A"), .left),
            (UInt8(ascii: "d"), .right), (UInt8(ascii: "D"), .right),
            (UInt8(ascii: "w"), .up), (UInt8(ascii: "W"), .up),
            (UInt8(ascii: "s"), .down), (UInt8(ascii: "S"), .down),
            (UInt8(ascii: " "), .jump),
            (UInt8(ascii: "k"), .dash), (UInt8(ascii: "K"), .dash),
            (UInt8(ascii: "q"), .quit), (UInt8(ascii: "Q"), .quit),
        ]
        return table.first { $0.0 == byte }?.1
    }

    static func arrowPress(_ final: UInt8) -> Press? {
        let table: [(UInt8, Press)] = [
            (UInt8(ascii: "A"), .up),
            (UInt8(ascii: "B"), .down),
            (UInt8(ascii: "C"), .right),
            (UInt8(ascii: "D"), .left),
        ]
        return table.first { $0.0 == final }?.1
    }

    static func virtual(_ code: Int) -> Press? {
        let table: [(Int, Press)] = [
            (0x25, .left),
            (0x26, .up),
            (0x27, .right),
            (0x28, .down),
        ]
        return table.first { $0.0 == code }?.1
    }
}
