import NeNeSummitCore

enum Guide {
    static func choose(_ state: SummitState) -> Input {
        switch state.action.phase {
        case .wall(.left):
            return kick(.left)
        case .wall(.right):
            return kick(.right)
        case .grounded:
            return alongGround(state)
        case .air, .wall(.up), .wall(.down):
            return .moving(.right)
        }
    }

    static func kick(_ horizontal: Horizontal) -> Input {
        Input(horizontal: horizontal, vertical: .none, jump: .pressed, dash: .off)
    }

    static func alongGround(_ state: SummitState) -> Input {
        if state.action.charges.remaining > 0 && lip(state) {
            return Input(horizontal: .right, vertical: .none, jump: .off, dash: .pressed)
        }
        if step(state) {
            return .hopping(.right)
        }
        if approach(state) {
            return .moving(.right)
        }
        return .hopping(.right)
    }

    static func lip(_ state: SummitState) -> Bool {
        missing(state, ahead: 1)
    }

    static func approach(_ state: SummitState) -> Bool {
        missing(state, ahead: 2) || missing(state, ahead: 3)
    }

    static func step(_ state: SummitState) -> Bool {
        let here = state.portrait()
        let near = state.room.kind(x: here.x + 1, y: here.y + 1)
        let next = state.room.kind(x: here.x + 2, y: here.y + 1)
        return near == .solid || next == .solid
    }

    static func missing(_ state: SummitState, ahead: Int) -> Bool {
        let here = state.portrait()
        return state.room.kind(x: here.x + ahead, y: here.y - 1) != .solid
    }
}
