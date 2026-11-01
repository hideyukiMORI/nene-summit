import Testing

@testable import NeNeSummitCore

@Test func aFallingBlockCrushesWhoeverItLandsOn() {
    let room = RoomSketch.room(named: "crush-probe", rows: ["D.", "@.", "##"], ascent: .aside)
    var state = SummitState.begin(in: room)
    var fell = false
    var tick = 0
    while tick < 80 && !fell {
        let step = state.advance(input: .idle)
        if step.events.contains(.fell) {
            fell = true
        }
        state = step.state
        tick += 1
    }
    #expect(fell)
}

@Test func aCrumbleIsSolidThenGone() {
    let room = RoomSketch.room(named: "crumble-probe", rows: ["@f", "##"], ascent: .aside)
    #expect(Matter(room: room, tick: 0).kind(x: 1, y: 1) == .solid)
    #expect(Matter(room: room, tick: MotionPolicy.crumbleOn).kind(x: 1, y: 1) == .open)
    let again = MotionPolicy.crumbleOn + MotionPolicy.crumbleOff
    #expect(Matter(room: room, tick: again).kind(x: 1, y: 1) == .solid)
}

@Test func aRefillRestoresTheDash() {
    let room = RoomSketch.room(named: "refill-probe", rows: ["@R", "##"], ascent: .aside)
    let dash = Input(horizontal: .right, vertical: .none, jump: .off, dash: .pressed)
    let step = SummitState.begin(in: room).advance(input: dash)
    #expect(step.state.paceX() != 0)
    #expect(step.state.action.charges.remaining == MotionPolicy.maxCharges)
}
