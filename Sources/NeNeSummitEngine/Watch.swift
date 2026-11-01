import NeNeSummitCore

public struct Watch: Equatable, Sendable {
    public let state: SummitState
    let spent: Int
    let rest: Int

    static let budget = 500
    static let pause = 40

    public static func begin(in room: Room) -> Watch {
        Watch(state: SummitState.begin(in: room), spent: 0, rest: 0)
    }

    public func advance(human: Input) -> Watch {
        if state.progress.expedition == .summited {
            return finished(human)
        }
        if human != .idle {
            return stepped(state.advance(input: human).state, spent: 0)
        }
        return guided()
    }

    private func finished(_ human: Input) -> Watch {
        if human != .idle || rest + 1 >= Watch.pause {
            return Watch.begin(in: state.room)
        }
        return Watch(state: state, spent: 0, rest: rest + 1)
    }

    private func guided() -> Watch {
        let next = state.advance(input: Guide.choose(state)).state
        if next.progress.expedition == .summited {
            return stepped(next, spent: 0)
        }
        let spent = self.spent + 1
        if spent >= Watch.budget {
            return Watch.begin(in: state.room)
        }
        return stepped(next, spent: spent)
    }

    private func stepped(_ state: SummitState, spent: Int) -> Watch {
        Watch(state: state, spent: spent, rest: 0)
    }
}
