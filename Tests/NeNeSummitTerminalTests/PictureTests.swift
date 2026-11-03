import Testing

@testable import NeNeSummitRender
@testable import NeNeSummitTerminal

@Test func aSmallerPictureErasesTheLeftover() {
    let narrow = Frame(lines: [[Glyph(symbol: "A", tone: .climber)]])
    let text = Picture.text(narrow)
    #expect(text.hasPrefix("\u{001B}[1;1H"))
    #expect(text.contains("A\u{001B}[0m\u{001B}[K"))
    #expect(text.contains("\n") == false)
    #expect(text.hasSuffix("\u{001B}[J"))
}

@Test func aWideFrameKeepsOneColorAndDoesNotFeed() {
    let sky = Glyph(symbol: " ", tone: .sky)
    let stone = Glyph(symbol: " ", tone: .stone)
    var line = Array(repeating: sky, count: 3)
    line.append(stone)
    var lines: [[Glyph]] = []
    var index = 0
    while index < 24 {
        lines.append(line)
        index += 1
    }
    let text = Picture.text(Frame(lines: lines))
    #expect(text.contains("\n") == false)
    #expect(text.contains("\u{001B}[24;1H"))
    let marks = text.split(separator: "0;48;5;16m").count - 1
    #expect(marks == 24)
}

@Test func aBerryAndACoinUseDifferentGrounds() {
    let berry = Painter.style(.gleam)
    let coin = Painter.style(.coin)
    #expect(berry != coin)
    #expect(berry != Painter.style(.sky))
    #expect(coin != Painter.style(.sky))
    #expect(berry != Painter.style(.spark))
    #expect(berry.contains("201"))
    #expect(coin.contains("226"))
}
