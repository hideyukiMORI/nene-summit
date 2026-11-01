enum Rue {
    static func line(_ cue: Cue, index: Int) -> String {
        let book = lines(cue)
        return book[index % book.count]
    }

    static func lines(_ cue: Cue) -> [String] {
        switch cue {
        case .trail:
            return ["Oh good. Another cliff.", "The mountain sends regards.", "I brought doubt. Welcome."]
        case .jump:
            return ["Ambitious. Adorable.", "Gravity called. It's patient.", "Up is a choice. Cute."]
        case .dash:
            return ["Blink and miss the mistake.", "Speed. My favorite excuse.", "Elegant. Accidentally."]
        case .fall:
            return ["The spikes send their love.", "Back so soon?", "Pain is a mean teacher."]
        case .crest:
            return ["The top. Try not to wave.", "Finished. Almost impressed.", "Enjoy it. It won't clap."]
        }
    }
}
