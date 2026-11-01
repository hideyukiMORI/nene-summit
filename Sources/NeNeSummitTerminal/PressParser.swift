enum PressParser {
    static func parse(_ bytes: [UInt8]) -> [Press] {
        var presses: [Press] = []
        var index = 0
        while index < bytes.count {
            if bytes[index] == 0x1B {
                let arrow = arrow(bytes, index: index)
                if let press = arrow.press {
                    presses.append(press)
                }
                index += arrow.consumed
            } else {
                if let press = plain(bytes[index]) {
                    presses.append(press)
                }
                index += 1
            }
        }
        return presses
    }

    static func arrow(_ bytes: [UInt8], index: Int) -> ArrowRead {
        if index + 2 >= bytes.count || bytes[index + 1] != UInt8(ascii: "[") {
            return ArrowRead(press: nil, consumed: 1)
        }
        switch bytes[index + 2] {
        case UInt8(ascii: "A"):
            return ArrowRead(press: .up, consumed: 3)
        case UInt8(ascii: "B"):
            return ArrowRead(press: .down, consumed: 3)
        case UInt8(ascii: "C"):
            return ArrowRead(press: .right, consumed: 3)
        case UInt8(ascii: "D"):
            return ArrowRead(press: .left, consumed: 3)
        default:
            return ArrowRead(press: nil, consumed: 1)
        }
    }

    static func plain(_ byte: UInt8) -> Press? {
        switch byte {
        case UInt8(ascii: "a"), UInt8(ascii: "A"):
            return .left
        case UInt8(ascii: "d"), UInt8(ascii: "D"):
            return .right
        case UInt8(ascii: "w"), UInt8(ascii: "W"):
            return .up
        case UInt8(ascii: "s"), UInt8(ascii: "S"):
            return .down
        case UInt8(ascii: " "):
            return .jump
        case UInt8(ascii: "k"), UInt8(ascii: "K"):
            return .dash
        case UInt8(ascii: "q"), UInt8(ascii: "Q"):
            return .quit
        default:
            return nil
        }
    }
}
