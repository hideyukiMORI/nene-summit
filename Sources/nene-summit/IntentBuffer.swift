import NeNeSummitCore
import NeNeSummitTerminal

struct IntentBuffer {
    var horizontal = Horizontal.none
    var vertical = Vertical.none
    var horizontalLeft = 0
    var verticalLeft = 0

    mutating func take(_ presses: [Press]) -> Input {
        var jump = Input.Jump.off
        var dash = Input.Dash.off
        for press in presses {
            absorb(press, jump: &jump, dash: &dash)
        }
        let input = Input(
            horizontal: horizontalLeft > 0 ? horizontal : .none,
            vertical: verticalLeft > 0 ? vertical : .none,
            jump: jump,
            dash: dash
        )
        if horizontalLeft > 0 {
            horizontalLeft -= 1
        }
        if verticalLeft > 0 {
            verticalLeft -= 1
        }
        return input
    }

    mutating func absorb(_ press: Press, jump: inout Input.Jump, dash: inout Input.Dash) {
        switch press {
        case .left:
            horizontal = .left
            horizontalLeft = 10
        case .right:
            horizontal = .right
            horizontalLeft = 10
        case .up:
            vertical = .up
            verticalLeft = 6
            jump = .pressed
        case .down:
            vertical = .down
            verticalLeft = 6
        case .jump:
            jump = .pressed
        case .dash:
            dash = .pressed
        case .quit:
            break
        }
    }
}
