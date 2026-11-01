enum Cast {
    static func say(_ voice: Int, cue: Cue, index: Int) -> String {
        let who = Voice.at(voice)
        return who.name + " " + who.face + " " + text(who, cue: cue, index: index)
    }

    static func text(_ voice: Voice, cue: Cue, index: Int) -> String {
        switch voice {
        case .mio:
            return Mio.line(cue, index: index)
        case .rue:
            return Rue.line(cue, index: index)
        case .nib:
            return Nib.line(cue, index: index)
        case .bram:
            return Bram.line(cue, index: index)
        }
    }
}
