import Testing

@testable import NeNeSummitCore

@Test func acceptsASpawnInsideTheRoom() {
    switch sampleRoom(width: 3, height: 2, spawn: CellPoint(x: 2, y: 1)) {
    case .success(let room):
        #expect(room.width == 3)
        #expect(room.height == 2)
        #expect(room.spawn == CellPoint(x: 2, y: 1))
    case .failure:
        Issue.record("内側の初期位置を拒否した")
    }
}

@Test func rejectsANonPositiveWidth() {
    switch sampleRoom(width: 0, height: 2, spawn: CellPoint(x: 0, y: 0)) {
    case .failure(.widthNotPositive):
        break
    case .failure(.heightNotPositive), .failure(.spawnOutside), .success:
        Issue.record("幅 0 の部屋を受け入れた")
    }
}

@Test func rejectsANonPositiveHeight() {
    switch sampleRoom(width: 3, height: -1, spawn: CellPoint(x: 0, y: 0)) {
    case .failure(.heightNotPositive):
        break
    case .failure(.widthNotPositive), .failure(.spawnOutside), .success:
        Issue.record("高さが正でない部屋を受け入れた")
    }
}

@Test func rejectsASpawnOnTheFarEdge() {
    switch sampleRoom(width: 3, height: 2, spawn: CellPoint(x: 3, y: 0)) {
    case .failure(.spawnOutside):
        break
    case .failure(.widthNotPositive), .failure(.heightNotPositive), .success:
        Issue.record("幅ちょうどを部屋の中にした")
    }
}

@Test func rejectsANegativeSpawn() {
    switch sampleRoom(width: 3, height: 2, spawn: CellPoint(x: -1, y: 0)) {
    case .failure(.spawnOutside):
        break
    case .failure(.widthNotPositive), .failure(.heightNotPositive), .success:
        Issue.record("負の座標を部屋の中にした")
    }
}

private func sampleRoom(width: Int, height: Int, spawn: CellPoint) -> Result<Room, Room.Rejection> {
    switch RoomId.make(value: "first-ascent") {
    case .success(let id):
        return Room.make(id: id, width: width, height: height, spawn: spawn)
    case .failure:
        preconditionFailure("テストの部屋名が空")
    }
}
