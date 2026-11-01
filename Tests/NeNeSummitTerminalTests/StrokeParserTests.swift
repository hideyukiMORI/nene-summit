import Testing

@testable import NeNeSummitTerminal

@Test func parsesArrowsAndThePlayKeys() {
    let bytes = [UInt8]("\u{1B}[D\u{1B}[C\u{1B}[A\u{1B}[B kq".utf8)
    let strokes: [Stroke] = [
        .typed(.left), .typed(.right), .typed(.up), .typed(.down), .typed(.jump), .typed(.dash), .typed(.quit),
    ]
    #expect(StrokeParser.parse(bytes).strokes == strokes)
}

@Test func anUnknownKeyIsIgnored() {
    #expect(StrokeParser.parse([UInt8(ascii: "x")]).strokes.isEmpty)
}

@Test func oneReadKeepsTwoKeys() {
    let read = StrokeParser.parse([UInt8]("d ".utf8))
    #expect(read.strokes == [.typed(.right), .typed(.jump)])
}

@Test func win32PressAndRelease() {
    let down = [UInt8]("\u{1B}[39;0;100;1;0;1_".utf8)
    let up = [UInt8]("\u{1B}[39;0;100;0;0;1_".utf8)
    #expect(StrokeParser.parse(down).strokes == [.pressed(.right)])
    #expect(StrokeParser.parse(up).strokes == [.released(.right)])
}

@Test func kittyPressRepeatAndRelease() {
    let press = [UInt8]("\u{1B}[100;1:1u".utf8)
    let again = [UInt8]("\u{1B}[100;1:2u".utf8)
    let release = [UInt8]("\u{1B}[100;1:3u".utf8)
    #expect(StrokeParser.parse(press).strokes == [.pressed(.right)])
    #expect(StrokeParser.parse(again).strokes == [.pressed(.right)])
    #expect(StrokeParser.parse(release).strokes == [.released(.right)])
}

@Test func kittyArrowRelease() {
    let bytes = [UInt8]("\u{1B}[1;1:3D".utf8)
    #expect(StrokeParser.parse(bytes).strokes == [.released(.left)])
}

@Test func anUnfinishedSequenceStaysUnread() {
    let read = StrokeParser.parse([UInt8]("\u{1B}[100;1:1".utf8))
    #expect(read.strokes.isEmpty)
    #expect(read.consumed == 0)
}

@Test func aTypedKeyStaysUntilTheRepeatWindow() {
    var held = HeldPresses()
    held.apply(.typed(.right), at: 0)
    #expect(held.take(at: 599) == [.right])
    #expect(held.take(at: 600).isEmpty)
}

@Test func aRepeatRefreshesTheShortWindow() {
    var held = HeldPresses()
    held.apply(.typed(.right), at: 0)
    _ = held.take(at: 0)
    held.apply(.typed(.right), at: 500)
    #expect(held.take(at: 619) == [.right])
    #expect(held.take(at: 620).isEmpty)
}

@Test func aPressLastsUntilReleaseAndATapIsLatched() {
    var held = HeldPresses()
    held.apply(.pressed(.jump), at: 0)
    held.apply(.released(.jump), at: 5)
    #expect(held.take(at: 5) == [.jump])
    #expect(held.take(at: 6).isEmpty)
    held.apply(.pressed(.left), at: 10)
    #expect(held.take(at: 1_009) == [.left])
    #expect(held.take(at: 1_010).isEmpty)
}
