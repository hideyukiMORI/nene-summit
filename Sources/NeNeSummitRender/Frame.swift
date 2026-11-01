public struct Frame: Equatable, Sendable {
    public let lines: [[Glyph]]

    public init(lines: [[Glyph]]) {
        self.lines = lines
    }
}
