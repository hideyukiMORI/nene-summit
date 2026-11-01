import NeNeSummitCore

enum CellMark {
    static let sky = "  "
    static let spike = "/\\"
    static let flag = "+|"
    static let crest = "F>"
    static let spring = "\\/"
    static let berry = "q*"
    static let coin = "()"
    static let ridge = "│ "
    static let chip = ": "

    static func stone(capped: Bool) -> String {
        if capped {
            return "══"
        }
        return "║║"
    }

    static func climber(_ phase: Phase) -> String {
        switch phase {
        case .wall(.left):
            return "<|"
        case .wall(.right):
            return "|>"
        case .air:
            return "/>"
        case .grounded, .wall(.up), .wall(.down):
            return "A>"
        }
    }
}
