import NeNeSummitCore

enum Cue: Equatable, Sendable {
    case trail
    case jump
    case dash
    case fall
    case crest

    var rank: Int {
        switch self {
        case .jump:
            return 1
        case .dash:
            return 2
        case .trail:
            return 3
        case .fall:
            return 4
        case .crest:
            return 5
        }
    }

    var interrupts: Bool {
        switch self {
        case .fall, .crest:
            return true
        case .trail, .jump, .dash:
            return false
        }
    }

    static func choose(_ events: [StepEvent], opened: Bool) -> Cue? {
        var best: Cue?
        for event in events {
            if let cue = heard(event) {
                best = higher(best, cue)
            }
        }
        if opened {
            best = higher(best, .trail)
        }
        return best
    }

    static func heard(_ event: StepEvent) -> Cue? {
        switch event {
        case .jumped:
            return .jump
        case .dashed:
            return .dash
        case .fell:
            return .fall
        case .summited:
            return .crest
        case .tick, .faced, .returned:
            return nil
        }
    }

    static func higher(_ left: Cue?, _ right: Cue) -> Cue {
        guard let left else {
            return right
        }
        if right.rank > left.rank {
            return right
        }
        return left
    }
}
