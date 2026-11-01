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
            return overHazard(state)
        }
    }

    static func overHazard(_ state: SummitState) -> Input {
        let clear = state.portrait().y >= 3
        if state.action.charges.remaining > 0 && clear && spikeNear(state) {
            return Input(horizontal: .right, vertical: .none, jump: .off, dash: .pressed)
        }
        return .moving(.right)
    }

    static func spikeNear(_ state: SummitState) -> Bool {
        let here = state.portrait()
        var ahead = 1
        while ahead <= 3 {
            if spiked(state, x: here.x + ahead, y: here.y) {
                return true
            }
            ahead += 1
        }
        return false
    }

    static func spiked(_ state: SummitState, x: Int, y: Int) -> Bool {
        var drop = 0
        while drop <= 2 {
            if state.room.kind(x: x, y: y - drop) == .spike {
                return true
            }
            drop += 1
        }
        return false
    }

    static func kick(_ horizontal: Horizontal) -> Input {
        Input(horizontal: horizontal, vertical: .none, jump: .pressed, dash: .off)
    }

    static func alongGround(_ state: SummitState) -> Input {
        if state.action.charges.remaining > 0 && lip(state) {
            return Input(horizontal: .right, vertical: .none, jump: .off, dash: .pressed)
        }
        if step(state) || hazard(state) {
            return .hopping(.right)
        }
        return .moving(.right)
    }

    static func hazard(_ state: SummitState) -> Bool {
        let here = state.portrait()
        let near = state.room.kind(x: here.x + 1, y: here.y)
        let next = state.room.kind(x: here.x + 2, y: here.y)
        return near == .spike || next == .spike
    }

    static func lip(_ state: SummitState) -> Bool {
        missing(state, ahead: 1)
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
