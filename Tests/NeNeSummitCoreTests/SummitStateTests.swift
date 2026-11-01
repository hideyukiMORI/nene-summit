import Testing

@testable import NeNeSummitCore

@Test func beginsOnTheSpawnFacingRight() {
    let state = SummitState.begin(in: openedRoom())
    #expect(state.foot == CellPoint(x: 1, y: 1))
    #expect(state.action.facing == .right)
    #expect(state.progress.tick == .zero)
    #expect(state.action.charges == .full)
}

@Test func idleStaysOnTheFloor() {
    let start = SummitState.begin(in: openedRoom())
    let outcome = start.advance(input: .idle)
    #expect(outcome.state.progress.tick.count == 1)
    #expect(outcome.state.kinematics.place == start.kinematics.place)
    #expect(outcome.events == [.tick])
}

@Test func theSameInputsProduceTheSameStates() {
    let inputs = [Input](repeating: .moving(.right), count: 5)
    let room = openedRoom()
    let first = Replay.states(from: SummitState.begin(in: room), inputs: inputs)
    let second = Replay.states(from: SummitState.begin(in: room), inputs: inputs)
    #expect(first == second)
    #expect(first.map(\.progress.tick.count) == [0, 1, 2, 3, 4, 5])
    #expect(first.last?.kinematics.place.x ?? 0 > first[0].kinematics.place.x)
}

@Test func differentInputsDiverge() {
    let room = openedRoom()
    let left = Replay.states(from: SummitState.begin(in: room), inputs: [.moving(.left)])
    let right = Replay.states(from: SummitState.begin(in: room), inputs: [.moving(.right)])
    #expect(left != right)
}

private func openedRoom() -> Room {
    let cells = [CellKind.solid, .solid, .solid, .open, .open, .open]
    switch RoomId.make(value: "first-ascent") {
    case .success(let id):
        let grid = RoomGrid(width: 3, height: 2, cells: cells)
        switch Room.make(RoomSpec(id: id, spawn: CellPoint(x: 1, y: 1), grid: grid)) {
        case .success(let room):
            return room
        case .failure:
            preconditionFailure("テストの部屋が拒否された")
        }
    case .failure:
        preconditionFailure("テストの部屋名が空")
    }
}
