import Testing

@testable import NeNeSummitCore

@Test func aGleamIsGatheredOnceAndSurvivesAFall() {
    var state = SummitState.begin(in: FirstAscent.make())
    var gathered = 0
    var fell = false
    var tick = 0
    while tick < 80 && !fell {
        let step = state.advance(input: .moving(.right))
        if step.events.contains(.gathered) {
            gathered += 1
        }
        if step.events.contains(.fell) {
            fell = true
        }
        state = step.state
        tick += 1
    }
    #expect(gathered == 1)
    #expect(fell)
    #expect(state.finds() == 1)
    let again = state.advance(input: .idle)
    #expect(again.events.contains(.gathered) == false)
    #expect(again.state.finds() == 1)
}

@Test func aCoinIsGatheredOnceBesideABerry() {
    var state = SummitState.begin(in: SecondPitch.make())
    var gathered = 0
    var tick = 0
    while tick < 40 && state.coins() < 1 {
        let step = state.advance(input: .moving(.right))
        if step.events.contains(.gathered) {
            gathered += 1
        }
        state = step.state
        tick += 1
    }
    #expect(gathered == 2)
    #expect(state.berries() == 1)
    #expect(state.coins() == 1)
    let again = state.advance(input: .idle)
    #expect(again.events.contains(.gathered) == false)
}
