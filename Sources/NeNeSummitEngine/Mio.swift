enum Mio {
    static func line(_ cue: Cue, index: Int) -> String {
        let book = lines(cue)
        return book[index % book.count]
    }

    static func lines(_ cue: Cue) -> [String] {
        switch cue {
        case .trail:
            return ["Steeper than the map.", "Wind from below.", "Rest now, or regret it."]
        case .jump:
            return ["That height. I like it.", "I'm watching the landing.", "Again. Up and right."]
        case .dash:
            return ["Fast. Breathe.", "The gap likes nerve.", "Okay. That one looked good."]
        case .fall:
            return ["Spikes are spikes.", "Back already. Cute.", "That looked expensive."]
        case .crest:
            return ["You made it. I watched.", "Top. The wind changed.", "Don't get used to praise."]
        }
    }
}
