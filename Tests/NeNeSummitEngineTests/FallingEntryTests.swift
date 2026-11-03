import Testing

@testable import NeNeSummitCore
@testable import NeNeSummitEngine

@Test func fallingBackArrivesInTheAir() {
    let room = LanePitch.make(0)
    let next = SummitState.begin(in: LanePitch.make(1)).carry(into: room, toward: .down)
    #expect(next.action.phase == .air)
    #expect(next.paceY() < 0)
    #expect(next.portrait().y >= room.height - 3)
    #expect(next.portrait().x <= 2)
}

@Test func fallingArrivesFromTheTopStillFalling() {
    var watch = Watch.begin(in: LanePitch.make(2))
    var tick = 0
    let home = watch.state.room.ascent
    while tick < Watch.budget && watch.state.room.ascent == home {
        watch = watch.advance(human: .idle)
        tick += 1
    }
    let arrived = watch.state
    let room = arrived.room
    #expect(room.ascent == .lane(3))
    #expect(arrived.action.phase == .air)
    #expect(arrived.paceY() < 0)
    #expect(arrived.portrait().y >= room.height - 4)
    #expect(arrived.portrait().x >= 6)
    let later = watch.advance(human: .idle, attendance: .manual)
    #expect(later.state.portrait().y < arrived.portrait().y)
}
