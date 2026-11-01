public struct PlayChord: Equatable, Sendable {
    var jumpWas: Bool
    var dashWas: Bool

    public init() {
        jumpWas = false
        dashWas = false
    }

    public mutating func make(_ held: HeldPlay) -> Input {
        let jumpDown = held.contains(HeldPlay.jump) || held.contains(HeldPlay.up)
        let dash = Self.dashEdge(&dashWas, down: held.contains(HeldPlay.dash))
        return Input(
            horizontal: Self.horizontal(held),
            vertical: Self.vertical(held),
            jump: Self.jumpEdge(&jumpWas, down: jumpDown),
            dash: dash
        )
    }

    static func horizontal(_ held: HeldPlay) -> Horizontal {
        let left = held.contains(HeldPlay.left)
        let right = held.contains(HeldPlay.right)
        if left == right {
            return .none
        }
        if left {
            return .left
        }
        return .right
    }

    static func vertical(_ held: HeldPlay) -> Vertical {
        let up = held.contains(HeldPlay.up)
        let down = held.contains(HeldPlay.down)
        if up == down {
            return .none
        }
        if up {
            return .up
        }
        return .down
    }

    static func jumpEdge(_ wasDown: inout Bool, down: Bool) -> Input.Jump {
        let jump = jumpKind(wasDown: wasDown, down: down)
        wasDown = down
        return jump
    }

    static func jumpKind(wasDown: Bool, down: Bool) -> Input.Jump {
        if down && !wasDown {
            return .pressed
        }
        if down {
            return .held
        }
        if wasDown {
            return .released
        }
        return .off
    }

    static func dashEdge(_ wasDown: inout Bool, down: Bool) -> Input.Dash {
        let pressed = down && !wasDown
        wasDown = down
        if pressed {
            return .pressed
        }
        return .off
    }
}
