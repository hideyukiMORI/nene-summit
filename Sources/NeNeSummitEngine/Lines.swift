enum Lines {
    static func say(_ cue: Cue, index: Int) -> String {
        let book = lines(cue)
        return Speaker.mark() + book[index % book.count]
    }

    static func lines(_ cue: Cue) -> [String] {
        switch cue {
        case .trail:
            return ["ここ、地図より急だね", "風が下から来てる", "休むなら今のうち"]
        case .jump:
            return ["その高さ、好きだよ", "着地、見てるから", "もう一回、右上"]
        case .dash:
            return ["速い。息、して", "隙間は、勢いだね", "今の、ちょっと格好よかった"]
        case .fall:
            return ["棘は棘だよ", "戻れた。もう一回", "痛そう。でも立ってる"]
        case .crest:
            return ["着いた。ちゃんと見てた", "頂上。次もいける", "やったね。風が違う"]
        }
    }
}
