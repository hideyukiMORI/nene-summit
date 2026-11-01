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

@Test func theAuthoredRoomCanBeClimbed() {
    var state = SummitState.begin(in: FirstAscent.make())
    var tick = 0
    while tick < 500 && state.progress.expedition != .summited {
        state = state.advance(input: hop(state)).state
        tick += 1
    }
    #expect(state.progress.expedition == .summited)
    let again = Replay.states(from: SummitState.begin(in: FirstAscent.make()), inputs: recordedHop())
    #expect(again.last?.progress.expedition == .summited)
}

private func hop(_ state: SummitState) -> Input {
    if state.action.phase == .grounded {
        return .hopping(.right)
    }
    return .moving(.right)
}

private func recordedHop() -> [Input] {
    var state = SummitState.begin(in: FirstAscent.make())
    var inputs: [Input] = []
    var tick = 0
    while tick < 500 && state.progress.expedition != .summited {
        let input = hop(state)
        inputs.append(input)
        state = state.advance(input: input).state
        tick += 1
    }
    return inputs
}

private func chamber(width: Int, height: Int, spawn: CellPoint, cells: [CellKind]) -> Room {
    switch RoomId.make(value: "chamber") {
    case .success(let id):
        let grid = RoomGrid(width: width, height: height, cells: cells)
        switch Room.make(RoomSpec(id: id, spawn: spawn, grid: grid)) {
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
