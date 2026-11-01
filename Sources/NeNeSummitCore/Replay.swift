enum Replay {
    static func states(from start: SummitState, inputs: [Input]) -> [SummitState] {
        var current = start
        var produced = [start]
        for input in inputs {
            current = current.advance(input: input).state
            produced.append(current)
        }
        return produced
    }
}
