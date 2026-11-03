import NeNeSummitCore

enum Lookahead {
    static let horizon = 24

    struct End {
        let place: CellPoint
        let fell: Bool
        let summited: Bool
    }

    static func choose(_ state: SummitState) -> Input {
        let goal = aim(state.room)
        let forward = glimpse(state, opening: .moving(.right), wait: 0)
        var best = Input.moving(.right)
        var bestMark = score(forward, goal: goal)
        var bestWait = 0
        for opening in extras(state) {
            let next = mark(state, opening: opening, goal: goal, wait: 0)
            if next > bestMark {
                best = opening
                bestMark = next
                bestWait = 0
            }
        }
        let clung = cling(state, goal: goal)
        if clung.mark > bestMark {
            best = clung.opening
            bestMark = clung.mark
            bestWait = 0
        }
        for wait in [4, 8, 12, 16] {
            let delayed = glimpse(state, opening: .moving(.right), wait: wait)
            let next = score(delayed, goal: goal)
            if forward.fell && !delayed.fell && next > bestMark {
                best = .idle
                bestMark = next
                bestWait = wait
            }
        }
        if bestWait > 0 {
            return .idle
        }
        return best
    }

    struct Cling {
        let opening: Input
        let mark: Int
    }

    static func cling(_ state: SummitState, goal: CellPoint?) -> Cling {
        let left = clingMark(state, toward: .left, goal: goal)
        let right = clingMark(state, toward: .right, goal: goal)
        if left >= right {
            return Cling(opening: .hopping(.left), mark: left)
        }
        return Cling(opening: .hopping(.right), mark: right)
    }

    static func clingMark(_ state: SummitState, toward: Horizontal, goal: CellPoint?) -> Int {
        var copy = state
        var index = 0
        var kicked = false
        while index < horizon {
            let input = clingInput(toward, index: index, phase: copy.action.phase, kicked: &kicked)
            let outcome = copy.advance(input: input)
            copy = outcome.state
            if stopped(outcome.events) {
                return -1_000_000
            }
            if index == 0 && !walled(copy.action.phase) {
                return -1_000_000
            }
            if copy.progress.expedition == .summited || outcome.events.contains(.departed) {
                if outcome.events.contains(.departed) && copy.turningBack() {
                    return -1_000_000
                }
                return kicked ? 1_000_000 : -1_000_000
            }
            index += 1
        }
        if !kicked {
            return -1_000_000
        }
        return mark(end: End(place: copy.portrait(), fell: false, summited: false), goal: goal)
    }

    static func walled(_ phase: Phase) -> Bool {
        if case .wall = phase {
            return true
        }
        return false
    }

    static func clingInput(
        _ toward: Horizontal, index: Int, phase: Phase, kicked: inout Bool
    ) -> Input {
        if !kicked, case .wall = phase {
            kicked = true
            return kick(toward)
        }
        if kicked {
            let away: Horizontal = toward == .left ? .right : .left
            return Input.moving(away)
        }
        if index == 0 {
            return Input.hopping(toward)
        }
        return Input(horizontal: toward, vertical: .none, jump: .off, dash: .off)
    }

    static func mark(end: End, goal: CellPoint?) -> Int {
        guard let goal else {
            return end.place.y * 100 + end.place.x
        }
        return end.place.y * 100 - gap(end.place.x, goal.x)
    }

    static func extras(_ state: SummitState) -> [Input] {
        var options = [Input.idle, Input.moving(.left)]
        if state.action.phase != .air {
            options.append(Input.hopping(.right))
            options.append(Input.hopping(.left))
        }
        if state.action.charges.remaining > 0 {
            options.append(dash)
        }
        switch state.action.phase {
        case .wall(.left):
            options.append(kick(.right))
        case .wall(.right):
            options.append(kick(.left))
        default:
            break
        }
        return options + aerial(state)
    }

    static func aerial(_ state: SummitState) -> [Input] {
        if state.room.place() < 0 || state.room.place() >= LanePitch.count {
            return []
        }
        if state.action.phase != .air || state.action.charges.hops == 0 {
            return []
        }
        guard let goal = aim(state.room) else {
            return []
        }
        if goal.y <= state.portrait().y + 1 {
            return []
        }
        return [Input.hopping(.right), Input.hopping(.left)]
    }

    static func mark(_ state: SummitState, opening: Input, goal: CellPoint?, wait: Int) -> Int {
        score(glimpse(state, opening: opening, wait: wait), goal: goal)
    }

    static func score(_ end: End, goal: CellPoint?) -> Int {
        if end.fell {
            return -1_000_000 + end.place.x
        }
        if end.summited {
            return 1_000_000
        }
        return mark(end: end, goal: goal)
    }

    static func glimpse(_ state: SummitState, opening: Input, wait: Int) -> End {
        var copy = state
        var index = 0
        while index < horizon {
            let input = paced(opening, index: index, wait: wait)
            let outcome = copy.advance(input: input)
            copy = outcome.state
            if stopped(outcome.events) {
                return End(place: copy.portrait(), fell: true, summited: false)
            }
            if copy.progress.expedition == .summited {
                return End(place: copy.portrait(), fell: false, summited: true)
            }
            if outcome.events.contains(.departed) {
                if copy.turningBack() {
                    return End(place: copy.portrait(), fell: true, summited: false)
                }
                return End(place: copy.portrait(), fell: false, summited: true)
            }
            index += 1
        }
        return End(place: copy.portrait(), fell: false, summited: false)
    }

    static func aim(_ room: Room) -> CellPoint? {
        spot(room, .summit) ?? Border.goal(room)
    }

    static func spot(_ room: Room, _ kind: CellKind) -> CellPoint? {
        var found: CellPoint?
        var y = 0
        while y < room.height {
            var x = 0
            while x < room.width {
                if room.kind(x: x, y: y) == kind {
                    found = CellPoint(x: x, y: y)
                }
                x += 1
            }
            y += 1
        }
        return found
    }

    static func stopped(_ events: [StepEvent]) -> Bool {
        events.contains(.fell) || events.contains(.returned)
    }

    static func paced(_ opening: Input, index: Int, wait: Int) -> Input {
        if index < wait {
            return .idle
        }
        if index == wait {
            return opening
        }
        return hold(opening)
    }

    static func hold(_ opening: Input) -> Input {
        Input(horizontal: opening.horizontal, vertical: .none, jump: .off, dash: .off)
    }

    static func kick(_ horizontal: Horizontal) -> Input {
        Input(horizontal: horizontal, vertical: .none, jump: .pressed, dash: .off)
    }

    static func gap(_ left: Int, _ right: Int) -> Int {
        if left > right {
            return left - right
        }
        return right - left
    }

    static let dash = Input(horizontal: .right, vertical: .none, jump: .off, dash: .pressed)
}
