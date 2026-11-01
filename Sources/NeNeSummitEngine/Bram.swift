enum Bram {
    static func line(_ cue: Cue, index: Int) -> String {
        let book = lines(cue)
        return book[index % book.count]
    }

    static func lines(_ cue: Cue) -> [String] {
        switch cue {
        case .trail:
            return ["A small mountain. Quaint.", "I already saw the ending.", "Do keep up."]
        case .jump:
            return ["Textbook. I wrote it.", "Height suits me.", "Again. I love an encore."]
        case .dash:
            return ["The gap moved. I didn't.", "Style is a kind of speed.", "You're welcome, gravity."]
        case .fall:
            return ["The spike was beneath me.", "Exit, then a better entrance.", "I allow one mistake."]
        case .crest:
            return ["The top, as ordered.", "I do look good up here.", "Next one. Be this cool."]
        }
    }
}
