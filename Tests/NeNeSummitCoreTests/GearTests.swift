import Testing

@testable import NeNeSummitCore

@Test func aSpringLaunchesUpward() {
    var state = SummitState.begin(in: SpringPitch.make())
    var sprung = false
    var tick = 0
    while tick < 20 {
        let outcome = state.advance(input: .moving(.right))
        if outcome.events.contains(.sprung) {
            #expect(outcome.state.paceY() == MotionPolicy.springSpeed)
            #expect(outcome.state.action.charges.remaining == MotionPolicy.maxCharges)
            sprung = true
            break
        }
        state = outcome.state
        tick += 1
    }
    #expect(sprung)
}

@Test func aRaftCarriesTheRider() {
    let room = RoomSketch.room(
        named: "raft",
        rows: [
            ".....",
            "..@..",
            ".MMM.",
        ],
        ascent: .aside
    )
    var state = SummitState.begin(in: room)
    let start = state.portrait().x
    var tick = 0
    while tick < MotionPolicy.deckTravel {
        state = state.advance(input: .idle).state
        tick += 1
    }
    #expect(state.portrait().x > start)
}

@Test func aVerticalDeckLiftsTheRider() {
    let room = RoomSketch.room(
        named: "lift",
        rows: [
            "....",
            "..@.",
            ".VV.",
        ],
        ascent: .aside
    )
    var state = SummitState.begin(in: room)
    let start = state.portrait().y
    var tick = 0
    while tick < MotionPolicy.deckTravel {
        state = state.advance(input: .idle).state
        tick += 1
    }
    #expect(state.portrait().y > start)
}

@Test func aBodyBesideARisingDeckIsCarried() {
    let room = RoomSketch.room(
        named: "cling",
        rows: [
            "....",
            "@V..",
            "####",
        ],
        ascent: .aside
    )
    var state = SummitState.begin(in: room)
    let start = state.portrait().y
    var tick = 0
    while tick < MotionPolicy.deckTravel {
        state = state.advance(input: .idle).state
        tick += 1
    }
    #expect(state.portrait().y > start)
}
