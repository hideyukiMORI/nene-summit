import NeNeSummitCore

public struct Watch: Equatable, Sendable {
    public let state: SummitState
    public let notice: Notice
    let spent: Int
    let rest: Int

    static let budget = 500
    static let pause = 40

    public static func begin(in room: Room, gleams: GleamBag = .empty) -> Watch {
        Watch(
            state: SummitState.begin(in: room, gleams: gleams),
            notice: Notice(events: [], opened: true),
            spent: 0,
            rest: 0
        )
    }

    public func advance(human: Input, attendance: Attendance = .automatic) -> Watch {
        if state.progress.expedition == .summited {
            return finished(human, attendance: attendance)
        }
        if attendance == .manual || human != .idle {
            return played(state.advance(input: human))
        }
        return guided()
    }

    private func finished(_ human: Input, attendance: Attendance) -> Watch {
        if attendance == .manual && human == .idle {
            return Watch(state: state, notice: Notice(events: [], opened: false), spent: 0, rest: rest)
        }
        if human != .idle || rest + 1 >= Watch.pause {
            return Watch.begin(in: Trail.after(state.room), gleams: state.bag().carried())
        }
        return Watch(state: state, notice: Notice(events: [], opened: false), spent: 0, rest: rest + 1)
    }

    private func played(_ outcome: StepOutcome) -> Watch {
        if let next = crossed(outcome) {
            return next
        }
        return stepped(outcome, spent: 0)
    }

    private func guided() -> Watch {
        let outcome = state.advance(input: Guide.choose(state))
        if let next = crossed(outcome) {
            return next
        }
        if outcome.state.progress.expedition == .summited {
            return stepped(outcome, spent: 0)
        }
        let spent = self.spent + 1
        if spent >= Watch.budget {
            return Watch.begin(in: state.room, gleams: state.bag())
        }
        return stepped(outcome, spent: spent)
    }

    private func crossed(_ outcome: StepOutcome) -> Watch? {
        if outcome.events.contains(.departed) {
            return Watch.begin(in: Trail.after(state.room), gleams: state.bag().carried())
        }
        return nil
    }

    private func stepped(_ outcome: StepOutcome, spent: Int) -> Watch {
        Watch(state: outcome.state, notice: Notice(events: outcome.events, opened: false), spent: spent, rest: 0)
    }
}
