import NeNeSummitCore

enum Guide {
    static func choose(_ state: SummitState) -> Input {
        Lookahead.choose(state)
    }
}
