import Testing

@testable import NeNeSummitTerminal

@Test func parsesArrowsAndThePlayKeys() {
    let bytes = [UInt8]("\u{1B}[D\u{1B}[C\u{1B}[A\u{1B}[B kq".utf8)
    #expect(PressParser.parse(bytes) == [.left, .right, .up, .down, .jump, .dash, .quit])
}

@Test func anUnknownKeyIsIgnored() {
    #expect(PressParser.parse([UInt8(ascii: "x")]) == [])
}
