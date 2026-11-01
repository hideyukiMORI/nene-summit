import Testing

@testable import NeNeSummitCore
@testable import NeNeSummitEngine

@Test func anUnattendedWatchSummitsAndStartsAgain() {
    var watch = Watch.begin(in: FirstAscent.make())
    watch = climb(watch)
    #expect(watch.state.progress.expedition == .summited)
    var rest = 0
    while rest < Watch.pause - 1 {
        watch = watch.advance(human: .idle)
        #expect(watch.state.progress.expedition == .summited)
        rest += 1
    }
    watch = watch.advance(human: .idle)
    #expect(watch.state.progress.expedition == .climbing)
    #expect(watch.state.room.ascent == .second)
    watch = climb(watch)
    #expect(watch.state.progress.expedition == .summited)
    #expect(watch.state.room.ascent == .second)
}

@Test func aLaterRoomKeepsTheGleamsAlreadyFound() {
    let held = GleamBag.empty.taking(CellPoint(x: 4, y: 1))
    let next = Watch.begin(in: SecondPitch.make(), gleams: held.carried())
    #expect(next.state.finds() == 1)
    #expect(next.state.gathered(x: 4, y: 1) == false)
    let same = Watch.begin(in: FirstAscent.make(), gleams: held)
    #expect(same.state.gathered(x: 4, y: 1))
    #expect(same.state.finds() == 1)
}

@Test func theSecondSummitOpensTheSpring() {
    var watch = rest(climb(Watch.begin(in: FirstAscent.make())))
    #expect(watch.state.room.ascent == .second)
    watch = rest(climb(watch))
    #expect(watch.state.room.ascent == .spring)
    #expect(watch.state.progress.expedition == .climbing)
}

@Test func theLiftOpensTheWell() {
    let watch = rest(climb(Watch.begin(in: LiftPitch.make())))
    #expect(watch.state.room.ascent == .well)
    #expect(watch.state.progress.expedition == .climbing)
}

@Test func theWellOpensTheSlot() {
    let watch = rest(climb(Watch.begin(in: WellPitch.make())))
    #expect(watch.state.room.ascent == .slot)
    #expect(watch.state.progress.expedition == .climbing)
}

@Test func theSlotReturnsToTheFirstRoom() {
    let watch = rest(climb(Watch.begin(in: SlotPitch.make())))
    #expect(watch.state.room.ascent == .first)
    #expect(watch.state.progress.expedition == .climbing)
}

@Test func anUnattendedWatchSummitsTheNewRooms() {
    let spring = climb(Watch.begin(in: SpringPitch.make()))
    #expect(spring.state.progress.expedition == .summited)
    let raft = climb(Watch.begin(in: RaftPitch.make()))
    #expect(raft.state.progress.expedition == .summited)
    let lift = climb(Watch.begin(in: LiftPitch.make()))
    #expect(lift.state.progress.expedition == .summited)
    let well = climb(Watch.begin(in: WellPitch.make()))
    #expect(well.state.progress.expedition == .summited)
    let slot = climb(Watch.begin(in: SlotPitch.make()))
    #expect(slot.state.progress.expedition == .summited)
}

@Test func theSlotIsCrossedByADash() {
    var watch = Watch.begin(in: SlotPitch.make())
    var dashed = false
    var tick = 0
    while tick < Watch.budget && watch.state.progress.expedition != .summited {
        let before = watch.state.action.charges.remaining
        watch = watch.advance(human: .idle)
        if watch.state.action.charges.remaining < before {
            dashed = true
        }
        tick += 1
    }
    #expect(dashed)
    #expect(watch.state.progress.expedition == .summited)
}

@Test func theWellIsClimbedAlongTheWall() {
    var watch = Watch.begin(in: WellPitch.make())
    var along = false
    var tick = 0
    while tick < Watch.budget && watch.state.progress.expedition != .summited {
        watch = watch.advance(human: .idle)
        if case .wall = watch.state.action.phase {
            along = true
        }
        tick += 1
    }
    #expect(along)
    #expect(watch.state.progress.expedition == .summited)
}

@Test func aBlockedGuideStartsAgain() {
    let room = deadEnd()
    let start = Watch.begin(in: room).state.portrait()
    var watch = Watch.begin(in: room)
    var tick = 0
    while tick < 30 {
        watch = watch.advance(human: .idle)
        tick += 1
    }
    #expect(watch.state.portrait() != start)
    while tick < Watch.budget {
        watch = watch.advance(human: .idle)
        tick += 1
    }
    #expect(watch.state.portrait() == start)
    #expect(watch.state.progress.expedition == .climbing)
}

@Test func aManualIdleStaysPut() {
    let start = Watch.begin(in: FirstAscent.make()).state.portrait()
    var watch = Watch.begin(in: FirstAscent.make())
    var tick = 0
    while tick < 30 {
        watch = watch.advance(human: .idle, attendance: .manual)
        tick += 1
    }
    #expect(watch.state.portrait() == start)
    #expect(watch.state.progress.expedition == .climbing)
}

@Test func aManualSummitWaits() {
    var watch = climb(Watch.begin(in: FirstAscent.make()))
    #expect(watch.state.progress.expedition == .summited)
    var tick = 0
    while tick < Watch.pause + 5 {
        watch = watch.advance(human: .idle, attendance: .manual)
        tick += 1
    }
    #expect(watch.state.progress.expedition == .summited)
}

@Test func aPersonIsNotCutOffByTheBudget() {
    let room = deadEnd()
    var watch = Watch.begin(in: room)
    var tick = 0
    while tick < Watch.budget + 20 {
        watch = watch.advance(human: .moving(.right))
        tick += 1
    }
    #expect(watch.state.portrait().x > Watch.begin(in: room).state.portrait().x)
}

private func rest(_ watch: Watch) -> Watch {
    var watch = watch
    var tick = 0
    while tick < Watch.pause {
        watch = watch.advance(human: .idle)
        tick += 1
    }
    return watch
}

private func climb(_ watch: Watch) -> Watch {
    var watch = watch
    var tick = 0
    while tick < Watch.budget && watch.state.progress.expedition != .summited {
        watch = watch.advance(human: .idle)
        tick += 1
    }
    return watch
}

private func deadEnd() -> Room {
    let width = 8
    let height = 6
    var cells = [CellKind](repeating: .open, count: width * height)
    var x = 0
    while x < width {
        cells[x] = .solid
        cells[2 * width + x] = .solid
        x += 1
    }
    cells[1 * width + 1] = .open
    switch RoomId.make(value: "dead-end") {
    case .success(let id):
        let grid = RoomGrid(width: width, height: height, cells: cells)
        switch Room.make(RoomSpec(id: id, spawn: CellPoint(x: 1, y: 1), grid: grid, ascent: .aside)) {
        case .success(let room):
            return room
        case .failure:
            preconditionFailure("袋小路が作れない")
        }
    case .failure:
        preconditionFailure("部屋名が空")
    }
}
