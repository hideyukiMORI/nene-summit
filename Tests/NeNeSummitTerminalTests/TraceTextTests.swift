import Testing

@testable import NeNeSummitTerminal

@Test func theTraceStaysOff() {
    #expect(PlayTrace.debug == false)
    #expect(PlayTrace.open() == nil)
}

@Test func bytesAndStrokesBecomeOneLine() {
    let bytes: [UInt8] = [0x64, 0x20]
    let strokes: [Stroke] = [.typed(.right), .typed(.jump)]
    #expect(TraceText.bytes(bytes) == "64 20")
    #expect(TraceText.strokes(strokes) == "typed(right),typed(jump)")
    #expect(TraceText.presses([.right, .jump]) == "right,jump")
    #expect(TraceText.bytes([]) == "-")
    #expect(TraceText.strokes([]) == "-")
}
