enum Nib {
    static func line(_ cue: Cue, index: Int) -> String {
        let book = lines(cue)
        return book[index % book.count]
    }

    static func lines(_ cue: Cue) -> [String] {
        switch cue {
        case .trail:
            return ["Up? On purpose?", "I counted the drops. I stopped.", "If I faint, keep going."]
        case .jump:
            return ["Nope. Nice arc, though.", "My stomach filed a complaint.", "Higher. Why higher."]
        case .dash:
            return ["Eyes shut. Professionally.", "That gap had opinions.", "Still alive. How rude."]
        case .fall:
            return ["I knew that spike. Personally.", "We're fine. I am not.", "Again? I just sat down."]
        case .crest:
            return ["Top. I might unclench.", "We lived. Write that down.", "Don't look down. I did."]
        }
    }
}
