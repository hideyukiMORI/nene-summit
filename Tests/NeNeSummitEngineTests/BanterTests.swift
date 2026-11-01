import Testing

@testable import NeNeSummitCore
@testable import NeNeSummitEngine

@Test func anOpeningLineWaitsBeforeTheNextJump() {
    var banter = Banter()
    banter.listen([], at: 0, opened: true)
    #expect(banter.line == "ミオ (^^) ここ、地図より急だね")
    banter.listen([.jumped], at: 1, opened: false)
    #expect(banter.line == "ミオ (^^) ここ、地図より急だね")
    banter.listen([.jumped], at: 1 + Banter.gap, opened: false)
    #expect(banter.line == "ミオ (^^) その高さ、好きだよ")
}

@Test func aFallAndASummitSpeakImmediately() {
    var banter = Banter()
    banter.listen([.jumped], at: 3, opened: false)
    banter.listen([.fell, .returned], at: 4, opened: false)
    #expect(banter.line == "ミオ (^^) 棘は棘だよ")
    banter.listen([.summited], at: 5, opened: false)
    #expect(banter.line == "ミオ (^^) 着いた。ちゃんと見てた")
}

@Test func aResetTickLetsTheNextGreetingOut() {
    var banter = Banter()
    banter.listen([], at: 0, opened: true)
    banter.listen([.summited], at: 20, opened: false)
    banter.listen([], at: 0, opened: true)
    #expect(banter.line == "ミオ (^^) 風が下から来てる")
}
