import NeNeSummitCore
import NeNeSummitTerminal

enum HeldBits {
    static func play(_ presses: [Press]) -> HeldPlay {
        var held = HeldPlay()
        for press in presses {
            if let bit = bit(press) {
                held = held.with(bit)
            }
        }
        return held
    }

    static func bit(_ press: Press) -> Int? {
        switch press {
        case .left:
            return HeldPlay.left
        case .right:
            return HeldPlay.right
        case .up:
            return HeldPlay.up
        case .down:
            return HeldPlay.down
        case .jump:
            return HeldPlay.jump
        case .dash:
            return HeldPlay.dash
        case .quit:
            return nil
        }
    }
}
