import Testing

@testable import NeNeSummitCore
@testable import NeNeSummitEngine

@Test func anOpeningLineWaitsBeforeTheNextJump() {
    var banter = Banter()
    banter.listen([], at: 0, opened: true)
    #expect(banter.line == "MIO (^^) Steeper than the map.")
    banter.listen([.jumped], at: 1, opened: false)
    #expect(banter.line == "MIO (^^) Steeper than the map.")
    banter.listen([.jumped], at: 1 + Banter.gap, opened: false)
    #expect(banter.line == "MIO (^^) That height. I like it.")
}

@Test func aFallAndASummitSpeakImmediately() {
    var banter = Banter()
    banter.listen([.jumped], at: 3, opened: false)
    banter.listen([.fell, .returned], at: 4, opened: false)
    #expect(banter.line == "MIO (^^) Spikes are spikes.")
    banter.listen([.summited], at: 5, opened: false)
    #expect(banter.line == "MIO (^^) You made it. I watched.")
}

@Test func aResetTickLetsTheNextGreetingOut() {
    var banter = Banter()
    banter.listen([], at: 0, opened: true)
    banter.listen([.summited], at: 20, opened: false)
    banter.listen([], at: 0, opened: true)
    #expect(banter.line == "RUE (-_-) The mountain sends regards.")
}

@Test func fourVoicesTakeTurns() {
    var banter = Banter()
    banter.listen([], at: 0, opened: true)
    #expect(banter.line.hasPrefix("MIO "))
    banter.listen([], at: 0, opened: true)
    #expect(banter.line.hasPrefix("RUE "))
    banter.listen([], at: 0, opened: true)
    #expect(banter.line.hasPrefix("NIB "))
    banter.listen([], at: 0, opened: true)
    #expect(banter.line.hasPrefix("BRAM "))
}
