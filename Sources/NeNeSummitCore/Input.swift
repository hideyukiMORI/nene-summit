public struct Input: Equatable, Sendable {
    public enum Jump: Equatable, Sendable {
        case off
        case pressed
        case held
        case released
    }

    public enum Dash: Equatable, Sendable {
        case off
        case pressed
    }

    public let horizontal: Horizontal
    public let vertical: Vertical
    public let jump: Jump
    public let dash: Dash

    public init(horizontal: Horizontal, vertical: Vertical, jump: Jump, dash: Dash) {
        self.horizontal = horizontal
        self.vertical = vertical
        self.jump = jump
        self.dash = dash
    }

    public static let idle = Input(horizontal: .none, vertical: .none, jump: .off, dash: .off)

    public static func moving(_ horizontal: Horizontal) -> Input {
        Input(horizontal: horizontal, vertical: .none, jump: .off, dash: .off)
    }

    public static func hopping(_ horizontal: Horizontal) -> Input {
        Input(horizontal: horizontal, vertical: .none, jump: .pressed, dash: .off)
    }
}
