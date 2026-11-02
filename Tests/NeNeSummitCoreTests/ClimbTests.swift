import Testing

@testable import NeNeSummitCore

@Test func aDashStopsAtAOneCellWall() {
    let room = chamber(width: 8, height: 4, spawn: CellPoint(x: 2, y: 1), cells: columnCells(x: 6, height: 4))
    var state = SummitState.begin(in: room)
    let dash = Input(horizontal: .right, vertical: .none, jump: .off, dash: .pressed)
    var tick = 0
    while tick < 12 {
        state = state.advance(input: tick == 0 ? dash : .moving(.right)).state
        #expect(!Probe.hitsSolid(place: state.kinematics.place, room: room))
        tick += 1
    }
    #expect(state.kinematics.place.x + MotionPolicy.bodyWidth <= 6 * MotionPolicy.scale)
}

@Test func spikesReturnToTheCheckpoint() {
    var cells = floorCells(width: 12, height: 3)
    cells[1 * 12 + 4] = .checkpoint
    cells[1 * 12 + 8] = .spike
    let room = chamber(width: 12, height: 3, spawn: CellPoint(x: 1, y: 1), cells: cells)
    var state = SummitState.begin(in: room)
    var tick = 0
    var fell = false
    while tick < 80 && !fell {
        let outcome = state.advance(input: .moving(.right))
        state = outcome.state
        fell = outcome.events.contains(.returned)
        tick += 1
    }
    #expect(fell)
    #expect(state.foot == CellPoint(x: 4, y: 1))
    #expect(state.action.charges == .full)
}

@Test func landingRestoresASpentDash() {
    let room = chamber(width: 8, height: 6, spawn: CellPoint(x: 2, y: 1), cells: floorCells(width: 8, height: 6))
    var state = SummitState.begin(in: room)
    let dash = Input(horizontal: .none, vertical: .up, jump: .off, dash: .pressed)
    state = state.advance(input: dash).state
    #expect(state.action.charges == .empty)
    var tick = 0
    while tick < 80 && state.action.phase != .grounded {
        state = state.advance(input: .idle).state
        tick += 1
    }
    #expect(state.action.phase == .grounded)
    #expect(state.action.charges == .full)
}

@Test func aWallKickLeavesTheWall() {
    let room = chamber(width: 6, height: 20, spawn: CellPoint(x: 2, y: 1), cells: floorCells(width: 6, height: 20))
    var state = SummitState.begin(in: room).advance(input: .hopping(.left)).state
    var tick = 0
    while tick < 40 && state.action.phase != .wall(.left) {
        state = state.advance(input: .moving(.left)).state
        tick += 1
    }
    #expect(state.action.phase == .wall(.left))
    let kicked = state.advance(input: Input(horizontal: .left, vertical: .none, jump: .pressed, dash: .off))
    #expect(kicked.events.contains(.jumped))
    #expect(kicked.state.kinematics.velocity.x > 0)
    #expect(kicked.state.kinematics.velocity.y > 0)
}

@Test func releasingAJumpCutsTheRise() {
    let room = chamber(width: 8, height: 8, spawn: CellPoint(x: 2, y: 1), cells: floorCells(width: 8, height: 8))
    var state = SummitState.begin(in: room)
    state = state.advance(input: .hopping(.none)).state
    #expect(state.kinematics.velocity.y == MotionPolicy.jumpSpeed)
    let cut = Input(horizontal: .none, vertical: .none, jump: .released, dash: .off)
    #expect(state.advance(input: cut).state.kinematics.velocity.y == MotionPolicy.jumpCut)
}

@Test func holdingAJumpDoesNotCutOrRetrigger() {
    let room = chamber(width: 8, height: 8, spawn: CellPoint(x: 2, y: 1), cells: floorCells(width: 8, height: 8))
    let held = Input(horizontal: .none, vertical: .none, jump: .held, dash: .off)
    let stayed = SummitState.begin(in: room).advance(input: held)
    #expect(stayed.events.contains(.jumped) == false)
    #expect(stayed.state.kinematics.velocity.y == 0)
    let rising = SummitState.begin(in: room).advance(input: .hopping(.none)).state
    let next = rising.advance(input: held).state.kinematics.velocity.y
    #expect(next == MotionPolicy.jumpSpeed - MotionPolicy.gravity)
}

@Test func aJumpCarriesTheHeldDirection() {
    let room = chamber(width: 12, height: 8, spawn: CellPoint(x: 2, y: 1), cells: floorCells(width: 12, height: 8))
    let origin = SummitState.begin(in: room).kinematics.place.x
    let leap = Input(horizontal: .right, vertical: .none, jump: .pressed, dash: .off)
    var state = SummitState.begin(in: room).advance(input: leap).state
    #expect(state.kinematics.velocity.x == MotionPolicy.leapSpeed)
    #expect(state.paceX() == MotionPolicy.leapSpeed)
    #expect(state.kinematics.velocity.y == MotionPolicy.jumpSpeed)
    #expect(state.paceY() == MotionPolicy.jumpSpeed)
    #expect(state.elapsed() == 1)
    let cut = Input(horizontal: .right, vertical: .none, jump: .released, dash: .off)
    state = state.advance(input: cut).state
    #expect(state.kinematics.velocity.y == MotionPolicy.jumpCut)
    #expect(state.kinematics.velocity.x == MotionPolicy.leapSpeed)
    var tick = 0
    while tick < 8 && state.action.phase != .grounded {
        state = state.advance(input: .moving(.right)).state
        tick += 1
    }
    #expect(state.kinematics.place.x - origin >= MotionPolicy.scale)
}

@Test func aJumpWithoutADirectionKeepsMomentum() {
    let room = chamber(width: 12, height: 8, spawn: CellPoint(x: 2, y: 1), cells: floorCells(width: 12, height: 8))
    var state = SummitState.begin(in: room)
    var tick = 0
    while tick < 4 {
        state = state.advance(input: .moving(.right)).state
        tick += 1
    }
    let carried = state.kinematics.velocity.x
    #expect(carried == MotionPolicy.runSpeed)
    let leap = Input(horizontal: .none, vertical: .none, jump: .pressed, dash: .off)
    let jumped = state.advance(input: leap).state
    #expect(jumped.kinematics.velocity.x == carried)
    #expect(jumped.kinematics.velocity.y == MotionPolicy.jumpSpeed)
}

@Test func airSteersTowardTheLeapInOneTick() {
    let room = chamber(width: 12, height: 8, spawn: CellPoint(x: 2, y: 1), cells: floorCells(width: 12, height: 8))
    let leap = Input(horizontal: .none, vertical: .none, jump: .pressed, dash: .off)
    let state = SummitState.begin(in: room).advance(input: leap).state
    #expect(state.kinematics.velocity.x == 0)
    let steered = state.advance(input: .moving(.right)).state
    #expect(steered.kinematics.velocity.x == MotionPolicy.leapSpeed)
}

@Test func twoRightJumpsReachTheLowerIsland() {
    var state = SummitState.begin(in: FirstAscent.make())
    state = rightLeap(state)
    state = rightLeap(state)
    let here = state.portrait()
    #expect(here.x >= 22)
    #expect(here.y >= 3)
}

@Test func aFullJumpStaysNearThreeBodies() {
    let rise = MotionPolicy.jumpSpeed * MotionPolicy.jumpSpeed / (2 * MotionPolicy.gravity)
    #expect(rise >= MotionPolicy.bodyHeight * 2)
    #expect(rise <= MotionPolicy.bodyHeight * 4)
}

@Test func theTrailContinuesAndAsideStays() {
    let first = Trail.opening()
    #expect(first.ascent == .first)
    let second = Trail.after(first)
    #expect(second.ascent == .second)
    let spring = Trail.after(second)
    #expect(spring.ascent == .spring)
    let raft = Trail.after(spring)
    #expect(raft.ascent == .raft)
    let lift = Trail.after(raft)
    #expect(lift.ascent == .lift)
    let well = Trail.after(lift)
    #expect(well.ascent == .well)
    let slot = Trail.after(well)
    #expect(slot.ascent == .slot)
    let span = Trail.after(slot)
    #expect(span.ascent == .span)
    let fall = Trail.after(span)
    #expect(fall.ascent == .fall)
    let rift = Trail.after(fall)
    #expect(rift.ascent == .rift)
    #expect(Trail.after(rift).ascent == .first)
    let aside = chamber(
        width: 4,
        height: 3,
        spawn: CellPoint(x: 1, y: 1),
        cells: floorCells(width: 4, height: 3)
    )
    let stayed = Trail.after(aside)
    #expect(stayed.ascent == .aside)
    #expect(stayed.width == aside.width)
}

@Test func theSecondPitchCrossesBeforeTheMark() {
    let room = SecondPitch.make()
    let checkpoint = find(room, .checkpoint)
    let spike = find(room, .spike)
    let summit = find(room, .summit)
    #expect(room.height < FirstAscent.make().height)
    #expect(checkpoint.x > firstGap(room))
    #expect(checkpoint.x < spike.x)
    #expect(summit.y > spike.y)
    #expect(pitWidth(room) >= 3)
}

@Test func theAuthoredRoomTeachesOneScreen() {
    let room = FirstAscent.make()
    let checkpoint = find(room, .checkpoint)
    let spike = find(room, .spike)
    let summit = find(room, .summit)
    #expect(checkpoint.x < spike.x)
    #expect(checkpoint.y == spike.y)
    #expect(summit.y > spike.y)
    #expect(pitWidth(room) >= 3)
}

private func rightLeap(_ state: SummitState) -> SummitState {
    let leap = Input(horizontal: .right, vertical: .none, jump: .pressed, dash: .off)
    let held = Input(horizontal: .right, vertical: .none, jump: .held, dash: .off)
    var state = state.advance(input: leap).state
    var tick = 0
    while tick < 40 && state.action.phase != .grounded {
        state = state.advance(input: held).state
        tick += 1
    }
    return state
}

private func find(_ room: Room, _ kind: CellKind) -> CellPoint {
    var y = 0
    while y < room.height {
        var x = 0
        while x < room.width {
            if room.kind(x: x, y: y) == kind {
                return CellPoint(x: x, y: y)
            }
            x += 1
        }
        y += 1
    }
    preconditionFailure("印が無い")
}

private func firstGap(_ room: Room) -> Int {
    var x = 0
    while x < room.width {
        if room.kind(x: x, y: 0) != .solid {
            return x
        }
        x += 1
    }
    preconditionFailure("隙間が無い")
}

private func pitWidth(_ room: Room) -> Int {
    var best = 0
    var run = 0
    var x = 0
    while x < room.width {
        if room.kind(x: x, y: 0) == .solid {
            best = max(best, run)
            run = 0
        } else {
            run += 1
        }
        x += 1
    }
    return max(best, run)
}

private func chamber(width: Int, height: Int, spawn: CellPoint, cells: [CellKind]) -> Room {
    switch RoomId.make(value: "chamber") {
    case .success(let id):
        let grid = RoomGrid(width: width, height: height, cells: cells)
        switch Room.make(RoomSpec(id: id, spawn: spawn, grid: grid, ascent: .aside)) {
        case .success(let room):
            return room
        case .failure:
            preconditionFailure("試験室が拒否された")
        }
    case .failure:
        preconditionFailure("試験室の名前が空")
    }
}

private func floorCells(width: Int, height: Int) -> [CellKind] {
    var cells = [CellKind](repeating: .open, count: width * height)
    var x = 0
    while x < width {
        cells[x] = .solid
        x += 1
    }
    return cells
}

private func columnCells(x: Int, height: Int) -> [CellKind] {
    var cells = floorCells(width: 8, height: height)
    var y = 1
    while y < height {
        cells[y * 8 + x] = .solid
        y += 1
    }
    return cells
}
