import NeNeSummitCore

enum CellMark {
    static let sky = "  "
    static let spike = "/\\"
    static let flag = "|+"
    static let crest = "|>"
    static let spring = "\\/"
    static let berry = "*'"
    static let coin = "(o"
    static let crusher = "[]"
    static let crumble = ".:"
    static let refill = "<>"
    static let cloud = "~~"
    static let spark = ". "

    static func stone(capped: Bool) -> String {
        if capped {
            return "~~"
        }
        return "││"
    }

    static func climber(_ phase: Phase) -> String {
        switch phase {
        case .wall(.left):
            return "/o"
        case .wall(.right):
            return "o\\"
        case .air:
            return "o/"
        case .grounded, .wall(.up), .wall(.down):
            return "o>"
        }
    }

    static func slope(_ far: Int) -> String {
        let local = positive(far) % 8
        if local == 4 {
            return "~~"
        }
        if local < 4 {
            return "//"
        }
        return "\\\\"
    }

    static func positive(_ value: Int) -> Int {
        if value >= 0 {
            return value
        }
        return -value
    }
}
