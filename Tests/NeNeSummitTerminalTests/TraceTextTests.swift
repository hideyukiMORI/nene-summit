import Testing

@testable import NeNeSummitTerminal

@Test func anUnsetTraceUsesTheDefaultFile() {
    #expect(PlayTrace.destination(nil) == PlayTrace.defaultPath)
    #expect(PlayTrace.destination("") == PlayTrace.defaultPath)
    #expect(PlayTrace.destination("1") == PlayTrace.defaultPath)
}

@Test func zeroTurnsTheTraceOff() {
    #expect(PlayTrace.destination("0") == nil)
}

@Test func aPathBecomesTheTraceFile() {
    #expect(PlayTrace.destination("/tmp/summit-custom.log") == "/tmp/summit-custom.log")
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
