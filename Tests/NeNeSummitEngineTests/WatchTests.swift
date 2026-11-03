import Testing

@testable import NeNeSummitCore
@testable import NeNeSummitEngine

@Test func anUnattendedWatchSummitsAndStartsAgain() {
    var watch = Watch.begin(in: RiftPitch.make())
    watch = climb(watch)
    #expect(watch.state.progress.expedition == .summited)
    #expect(watch.state.room.ascent == .rift)
    var rest = 0
    while rest < Watch.pause - 1 {
        watch = watch.advance(human: .idle)
        #expect(watch.state.progress.expedition == .summited)
        rest += 1
    }
    watch = watch.advance(human: .idle)
    #expect(watch.state.progress.expedition == .climbing)
    #expect(watch.state.room.ascent == .lane(0))
    watch = climb(watch)
    #expect(watch.state.progress.expedition == .climbing)
    #expect(watch.state.room.ascent == .lane(1))
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
    var watch = climb(Watch.begin(in: FirstAscent.make()))
    #expect(watch.state.room.ascent == .second)
    #expect(watch.state.progress.expedition == .climbing)
    watch = climb(watch)
    #expect(watch.state.room.ascent == .spring)
    #expect(watch.state.progress.expedition == .climbing)
}

@Test func theLiftOpensTheWell() {
    let watch = climb(Watch.begin(in: LiftPitch.make()))
    #expect(watch.state.room.ascent == .well)
    #expect(watch.state.progress.expedition == .climbing)
}

@Test func theWellOpensTheSlot() {
    let watch = climb(Watch.begin(in: WellPitch.make()))
    #expect(watch.state.room.ascent == .slot)
    #expect(watch.state.progress.expedition == .climbing)
}

@Test func theSlotOpensTheSpan() {
    let watch = climb(Watch.begin(in: SlotPitch.make()))
    #expect(watch.state.room.ascent == .span)
    #expect(watch.state.progress.expedition == .climbing)
}

@Test func theGuideCrossesUnderTheCrystal() {
    var watch = Watch.begin(in: SpanPitch.make())
    var caught = false
    var tick = 0
    let home = watch.state.room.ascent
    while tick < Watch.budget && watch.state.room.ascent == home {
        watch = watch.advance(human: .idle)
        if watch.state.room.ascent != home {
            break
        }
        let here = watch.state.portrait()
        if watch.state.room.kind(x: here.x, y: here.y) == .refill {
            caught = true
        }
        tick += 1
    }
    #expect(watch.state.room.ascent == .fall)
    #expect(watch.state.progress.expedition == .climbing)
    #expect(caught)
}

@Test func theGuideCrossesWhileTheMassDrops() {
    var watch = Watch.begin(in: FallPitch.make())
    var crossed = false
    var dropped = false
    var tick = 0
    let home = watch.state.room.ascent
    while tick < Watch.budget && watch.state.room.ascent == home {
        watch = watch.advance(human: .idle)
        if watch.state.room.ascent != home {
            break
        }
        if watch.state.portrait().x >= 4 && watch.state.portrait().x <= 6 {
            crossed = true
        }
        if watch.state.room.crushing(x: 5, y: 3, tick: watch.state.elapsed()) {
            dropped = true
        }
        tick += 1
    }
    #expect(watch.state.room.ascent == .bridge)
    #expect(crossed)
    #expect(dropped)
}

@Test func theGuideStandsOnTheCrumble() {
    var watch = Watch.begin(in: RiftPitch.make())
    var stood = false
    var tick = 0
    while tick < Watch.budget && watch.state.progress.expedition != .summited {
        watch = watch.advance(human: .idle)
        let here = watch.state.portrait()
        let room = watch.state.room
        if onDeck(room, x: here.x, y: here.y) {
            stood = true
        }
        tick += 1
    }
    #expect(watch.state.progress.expedition == .summited)
    #expect(stood)
}

@Test func theFallOpensTheArch() {
    let watch = climb(Watch.begin(in: FallPitch.make()))
    #expect(watch.state.room.ascent == .bridge)
    #expect(watch.state.progress.expedition == .climbing)
}

@Test func aManualStepBackReturnsToThePreviousRoom() {
    var watch = climb(Watch.begin(in: FirstAscent.make()))
    #expect(watch.state.room.ascent == .second)
    var tick = 0
    while tick < 80 && watch.state.room.ascent == .second {
        watch = watch.advance(human: Input.moving(.left), attendance: .manual)
        tick += 1
    }
    #expect(watch.state.room.ascent == .first)
    #expect(watch.state.portrait().x > 20)
}

@Test func theLanesReachTheBridge() {
    var watch = Watch.begin(in: LanePitch.make(0))
    var index = 0
    while index < LanePitch.count {
        watch = climb(watch)
        index += 1
    }
    #expect(watch.state.room.ascent == .rift)
    #expect(watch.state.berries() >= 1)
    #expect(watch.state.coins() >= 1)
}

@Test func theRiseLeavesUpward() {
    let watch = climb(Watch.begin(in: LanePitch.make(0)))
    #expect(watch.state.room.ascent == .lane(1))
}

@Test func theRidgeLeavesByAWallKick() {
    var watch = Watch.begin(in: LanePitch.make(1))
    var along = false
    var tick = 0
    let home = watch.state.room.ascent
    while tick < Watch.budget && watch.state.room.ascent == home {
        watch = watch.advance(human: .idle)
        if watch.state.room.ascent != home {
            break
        }
        if case .wall = watch.state.action.phase {
            along = true
        }
        tick += 1
    }
    #expect(along)
    #expect(watch.state.room.ascent == .lane(2))
}

@Test func theSecondWellLeavesByAWallKick() {
    var watch = Watch.begin(in: LanePitch.make(5))
    var along = false
    var tick = 0
    let home = watch.state.room.ascent
    while tick < Watch.budget && watch.state.room.ascent == home {
        watch = watch.advance(human: .idle)
        if watch.state.room.ascent != home {
            break
        }
        if case .wall = watch.state.action.phase {
            along = true
        }
        tick += 1
    }
    #expect(along)
    #expect(watch.state.room.ascent == .lane(6))
}

@Test func theWestLeavesLeft() {
    let watch = climb(Watch.begin(in: LanePitch.make(3)))
    #expect(watch.state.room.ascent == .lane(4))
}

@Test func theDropLeavesDownward() {
    let watch = climb(Watch.begin(in: LanePitch.make(4)))
    #expect(watch.state.room.ascent == .lane(5))
}

@Test func theVaultIsCrossedByADash() {
    var watch = Watch.begin(in: LanePitch.make(6))
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
    #expect(watch.state.room.ascent == .rift)
}

@Test func theRiftReturnsToTheRise() {
    let watch = rest(climb(Watch.begin(in: RiftPitch.make())))
    #expect(watch.state.room.ascent == .lane(0))
    #expect(watch.state.progress.expedition == .climbing)
}

@Test func anUnattendedWatchSummitsTheNewRooms() {
    let spring = climb(Watch.begin(in: SpringPitch.make()))
    #expect(spring.state.room.ascent == .raft)
    let raft = climb(Watch.begin(in: RaftPitch.make()))
    #expect(raft.state.room.ascent == .lift)
    let lift = climb(Watch.begin(in: LiftPitch.make()))
    #expect(lift.state.room.ascent == .well)
    let well = climb(Watch.begin(in: WellPitch.make()))
    #expect(well.state.room.ascent == .slot)
    let slot = climb(Watch.begin(in: SlotPitch.make()))
    #expect(slot.state.room.ascent == .span)
    let fall = climb(Watch.begin(in: FallPitch.make()))
    #expect(fall.state.room.ascent == .bridge)
    let rift = climb(Watch.begin(in: RiftPitch.make()))
    #expect(rift.state.progress.expedition == .summited)
    #expect(rift.state.room.ascent == .rift)
}

@Test func theSlotIsCrossedByADash() {
    var watch = Watch.begin(in: SlotPitch.make())
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
    #expect(watch.state.room.ascent == .span)
}

@Test func theWellIsClimbedAlongTheWall() {
    var watch = Watch.begin(in: WellPitch.make())
    var along = false
    var tick = 0
    let home = watch.state.room.ascent
    while tick < Watch.budget && watch.state.room.ascent == home {
        watch = watch.advance(human: .idle)
        if watch.state.room.ascent != home {
            break
        }
        if case .wall = watch.state.action.phase {
            along = true
        }
        tick += 1
    }
    #expect(along)
    #expect(watch.state.room.ascent == .slot)
}

@Test func theArchIsCrossedWhileItHolds() {
    var watch = Watch.begin(in: BridgePitch.make())
    var stood = false
    var tick = 0
    let home = watch.state.room.ascent
    while tick < Watch.budget && watch.state.room.ascent == home {
        watch = watch.advance(human: .idle)
        if watch.state.room.ascent != home {
            break
        }
        let here = watch.state.portrait()
        if onDeck(watch.state.room, x: here.x, y: here.y) {
            stood = true
        }
        tick += 1
    }
    #expect(stood)
    #expect(watch.state.room.ascent == .lane(0))
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
    var watch = climb(Watch.begin(in: RiftPitch.make()))
    #expect(watch.state.progress.expedition == .summited)
    #expect(watch.state.room.ascent == .rift)
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

private func onDeck(_ room: Room, x: Int, y: Int) -> Bool {
    if y - 1 >= 0 && room.kind(x: x, y: y - 1) == .crumble {
        return true
    }
    if y - 2 >= 0 && room.kind(x: x, y: y - 2) == .crumble {
        return true
    }
    return false
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
    let home = watch.state.room.ascent
    var watch = watch
    var tick = 0
    while tick < Watch.budget && watch.state.room.ascent == home
        && watch.state.progress.expedition != .summited
    {
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
