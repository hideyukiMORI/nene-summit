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
        var best = Input.moving(.right)
        var bestMark = mark(state, opening: best, goal: goal)
        for opening in extras(state) {
            let next = mark(state, opening: opening, goal: goal)
            if next > bestMark {
                best = opening
                bestMark = next
            }
        }
        return best
    }

    static func extras(_ state: SummitState) -> [Input] {
        var options = [Input.idle, Input.hopping(.right), Input.moving(.left), Input.hopping(.left)]
        if state.action.charges.remaining > 0 {
            options.append(dash)
        }
        switch state.action.phase {
        case .wall(.left):
            options.append(kick(.left))
        case .wall(.right):
            options.append(kick(.right))
        default:
            break
        }
        return options
    }

    static func mark(_ state: SummitState, opening: Input, goal: CellPoint?) -> Int {
        let end = glimpse(state, opening: opening)
        if end.fell {
            return -1_000_000 + end.place.x
        }
        if end.summited {
            return 1_000_000
        }
        guard let goal else {
            return end.place.y * 100 + end.place.x
        }
        return end.place.y * 100 - gap(end.place.x, goal.x)
    }

    static func glimpse(_ state: SummitState, opening: Input) -> End {
        var copy = state
        var index = 0
        while index < horizon {
            let input = index == 0 ? opening : hold(opening)
            let outcome = copy.advance(input: input)
            copy = outcome.state
            if stopped(outcome.events) {
                return End(place: copy.portrait(), fell: true, summited: false)
            }
            if copy.progress.expedition == .summited {
                return End(place: copy.portrait(), fell: false, summited: true)
            }
            if outcome.events.contains(.departed) {
                if copy.crossing() == .left {
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
