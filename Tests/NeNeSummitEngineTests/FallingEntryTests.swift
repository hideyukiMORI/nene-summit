import Testing

@testable import NeNeSummitCore
@testable import NeNeSummitEngine

@Test func fallingBackArrivesInTheAir() {
    let room = LanePitch.make(0)
    let next = SummitState.begin(in: LanePitch.make(1)).carry(into: room, toward: .down)
    #expect(next.action.phase == .air)
    #expect(next.paceY() < 0)
    #expect(next.portrait().y >= room.height - 4)
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

@Test func theBloomLeavesByASpring() {
    var watch = Watch.begin(in: LanePitch.make(10))
    var sprung = false
    var tick = 0
    let home = watch.state.room.ascent
    while tick < Watch.budget && watch.state.room.ascent == home {
        watch = watch.advance(human: .idle)
        if watch.notice.events.contains(.sprung) {
            sprung = true
        }
        tick += 1
    }
    #expect(sprung)
    #expect(watch.state.room.ascent == .lane(11))
}

@Test func theSpireArrivesOnTheLeft() {
    let room = LanePitch.make(9)
    let next = SummitState.begin(in: LanePitch.make(8)).carry(into: room, toward: .right)
    #expect(next.portrait().x <= 2)
    #expect(room.width > 26)
    #expect(room.height > 20)
}

@Test func theGulfIsCrossedByADash() {
    let room = LanePitch.make(12)
    var watch = Watch.begin(in: room)
    var dashed = false
    var tick = 0
    let home = watch.state.room.ascent
    while tick < Watch.budget && watch.state.room.ascent == home {
        let before = watch.state.action.charges.remaining
        watch = watch.advance(human: .idle)
        if watch.state.room.ascent != home {
            break
        }
        if watch.state.action.charges.remaining < before {
            dashed = true
        }
        tick += 1
    }
    #expect(dashed)
    #expect(room.width > 26)
    #expect(watch.state.room.ascent == .lane(13))
}
