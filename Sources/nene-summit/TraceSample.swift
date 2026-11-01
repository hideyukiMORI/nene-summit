import NeNeSummitCore
import NeNeSummitTerminal

struct TraceSample {
    let now: Int
    let keys: TraceKeys
    let before: SummitState
    let after: SummitState

    func line() -> String? {
        let airborne = before.action.phase != .grounded || after.action.phase != .grounded
        if keys.arrival.bytes.isEmpty && keys.human == .idle && !airborne {
            return nil
        }
        return joined()
    }

    func joined() -> String {
        let cell = after.portrait()
        return [
            "ms=\(now)",
            "tick=\(after.elapsed())",
            "bytes=\(TraceText.bytes(keys.arrival.bytes))",
            "strokes=\(TraceText.strokes(keys.arrival.strokes))",
            "held=\(TraceText.presses(keys.presses))",
            "human=\(humanText())",
            "mode=\(modeText())",
            "hands=\(hands())",
            "from=\(phaseText(before.action.phase))",
            "phase=\(phaseText(after.action.phase))",
            "cell=\(cell.x),\(cell.y)",
            "vx=\(after.paceX())",
            "vy=\(after.paceY())",
            "charges=\(after.action.charges.remaining)",
        ].joined(separator: " ")
    }

    func hands() -> String {
        if keys.attendance == .manual || keys.human != .idle {
            return "human"
        }
        if before.progress.expedition == .summited {
            return "rest"
        }
        return "guide"
    }

    func humanText() -> String {
        let input = keys.human
        let across = horizontalText(input.horizontal)
        let along = verticalText(input.vertical)
        return "h=\(across) v=\(along) jump=\(jumpText(input.jump)) dash=\(dashText(input.dash))"
    }

    func modeText() -> String {
        switch keys.attendance {
        case .automatic:
            return "automatic"
        case .manual:
            return "manual"
        }
    }

    func phaseText(_ phase: Phase) -> String {
        switch phase {
        case .grounded:
            return "grounded"
        case .air:
            return "air"
        case .wall(let side):
            return "wall(\(directionText(side)))"
        }
    }

    func horizontalText(_ horizontal: Horizontal) -> String {
        switch horizontal {
        case .none:
            return "none"
        case .left:
            return "left"
        case .right:
            return "right"
        }
    }

    func verticalText(_ vertical: Vertical) -> String {
        switch vertical {
        case .none:
            return "none"
        case .up:
            return "up"
        case .down:
            return "down"
        }
    }

    func jumpText(_ jump: Input.Jump) -> String {
        switch jump {
        case .off:
            return "off"
        case .pressed:
            return "pressed"
        case .held:
            return "held"
        case .released:
            return "released"
        }
    }

    func dashText(_ dash: Input.Dash) -> String {
        switch dash {
        case .off:
            return "off"
        case .pressed:
            return "pressed"
        }
    }

    func directionText(_ direction: Direction) -> String {
        switch direction {
        case .up:
            return "up"
        case .down:
            return "down"
        case .left:
            return "left"
        case .right:
            return "right"
        }
    }
}
