import Testing

@testable import NeNeSummitRender
@testable import NeNeSummitTerminal

@Test func aSmallerPictureErasesTheLeftover() {
    let narrow = Frame(lines: [[Glyph(symbol: "A", tone: .climber)]])
    let text = Picture.text(narrow)
    #expect(text.hasPrefix("\u{001B}[H"))
    #expect(text.contains("A\u{001B}[0m\u{001B}[K\r\n"))
    #expect(text.hasSuffix("\u{001B}[J"))
}
