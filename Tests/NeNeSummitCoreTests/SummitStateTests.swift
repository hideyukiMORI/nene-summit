import Testing

@testable import NeNeSummitCore

@Test func beginsAtTheSpawnFacingUp() {
    let state = SummitState.begin(in: openedRoom())
    #expect(state.position == CellPoint(x: 1, y: 0))
    #expect(state.facing == .up)
    #expect(state.tick == .zero)
}

@Test func advancesOneTickWithoutMoving() {
    let start = SummitState.begin(in: openedRoom())
    let outcome = start.advance(input: .idle)
    #expect(outcome.state.tick.count == 1)
    #expect(outcome.state.position == start.position)
    #expect(outcome.state.facing == .up)
    #expect(outcome.events == [.tick])
}

@Test func faceInputRecordsTheDirectionAfterTheTick() {
    let outcome = SummitState.begin(in: openedRoom()).advance(input: .face(.left))
    #expect(outcome.state.facing == .left)
    #expect(outcome.events == [.tick, .faced(.left)])
}

@Test func theSameInputsProduceTheSameStates() {
    let inputs: [Input] = [.idle, .face(.left), .face(.left), .idle, .face(.down)]
    let room = openedRoom()
    let first = Replay.states(from: SummitState.begin(in: room), inputs: inputs)
    let second = Replay.states(from: SummitState.begin(in: room), inputs: inputs)
    #expect(first == second)
    #expect(first.map(\.tick.count) == [0, 1, 2, 3, 4, 5])
    #expect(first.map(\.position) == Array(repeating: room.spawn, count: first.count))
}

@Test func differentInputsDivergeByFacing() {
    let room = openedRoom()
    let left = Replay.states(from: SummitState.begin(in: room), inputs: [.face(.left)])
    let right = Replay.states(from: SummitState.begin(in: room), inputs: [.face(.right)])
    #expect(left != right)
    #expect(left.last?.facing == .left)
    #expect(right.last?.facing == .right)
}

private func openedRoom() -> Room {
    switch RoomId.make(value: "first-ascent") {
    case .success(let id):
        switch Room.make(id: id, width: 3, height: 2, spawn: CellPoint(x: 1, y: 0)) {
        case .success(let room):
            return room
        case .failure:
            preconditionFailure("テストの部屋が拒否された")
        }
    case .failure:
        preconditionFailure("テストの部屋名が空")
    }
}
