import Testing

@testable import NeNeSummitTerminal

@Test func aFreshTickWaitsTheWholeSlot() {
    #expect(FramePace.remaining(started: 10, now: 10) == FramePace.milliseconds)
}

@Test func aPartialTickWaitsTheRest() {
    #expect(FramePace.remaining(started: 10, now: 10 + 15) == FramePace.milliseconds - 15)
}

@Test func aLateTickDoesNotCatchUp() {
    #expect(FramePace.remaining(started: 10, now: 10 + FramePace.milliseconds) == 0)
    #expect(FramePace.remaining(started: 10, now: 10 + FramePace.milliseconds + 8) == 0)
}

@Test func aBackwardClockWaitsTheWholeSlot() {
    #expect(FramePace.remaining(started: 20, now: 5) == FramePace.milliseconds)
}
