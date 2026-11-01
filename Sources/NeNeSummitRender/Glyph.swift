public struct Glyph: Equatable, Sendable {
    public enum Tone: Equatable, Sendable {
        case sky
        case stone
        case hazard
        case flag
        case crest
        case mark
        case climber
        case banner
        case quiet
    }

    public let symbol: Character
    public let tone: Tone

    public init(symbol: Character, tone: Tone) {
        self.symbol = symbol
        self.tone = tone
    }
}
