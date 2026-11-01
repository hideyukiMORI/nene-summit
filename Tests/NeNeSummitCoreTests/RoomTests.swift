import Testing

@testable import NeNeSummitCore

@Test func acceptsASpawnInsideTheRoom() {
    switch sampleRoom(width: 3, height: 2, spawn: CellPoint(x: 1, y: 1), cells: floorCells(width: 3, height: 2)) {
    case .success(let room):
        #expect(room.spawn == CellPoint(x: 1, y: 1))
    case .failure:
        Issue.record("内側の初期位置を拒否した")
    }
}

@Test func rejectsANonPositiveWidth() {
    switch sampleRoom(width: 0, height: 2, spawn: CellPoint(x: 0, y: 0), cells: []) {
    case .failure(.widthNotPositive):
        break
    case .failure, .success:
        Issue.record("幅 0 の部屋を受け入れた")
    }
}

@Test func rejectsANonPositiveHeight() {
    switch sampleRoom(width: 3, height: -1, spawn: CellPoint(x: 0, y: 0), cells: []) {
    case .failure(.heightNotPositive):
        break
    case .failure, .success:
        Issue.record("高さが正でない部屋を受け入れた")
    }
}

@Test func rejectsASpawnOnTheFarEdge() {
    let cells = floorCells(width: 3, height: 2)
    switch sampleRoom(width: 3, height: 2, spawn: CellPoint(x: 3, y: 0), cells: cells) {
    case .failure(.spawnOutside):
        break
    case .failure, .success:
        Issue.record("幅ちょうどを部屋の中にした")
    }
}

@Test func rejectsANegativeSpawn() {
    let cells = floorCells(width: 3, height: 2)
    switch sampleRoom(width: 3, height: 2, spawn: CellPoint(x: -1, y: 0), cells: cells) {
    case .failure(.spawnOutside):
        break
    case .failure, .success:
        Issue.record("負の座標を部屋の中にした")
    }
}

@Test func rejectsAMismatchedCellCount() {
    switch sampleRoom(width: 2, height: 2, spawn: CellPoint(x: 0, y: 1), cells: [.open]) {
    case .failure(.cellCount):
        break
    case .failure, .success:
        Issue.record("マスの数が違う部屋を受け入れた")
    }
}

@Test func rejectsASpawnInsideSolid() {
    let cells = [CellKind](repeating: .solid, count: 6)
    switch sampleRoom(width: 3, height: 2, spawn: CellPoint(x: 1, y: 1), cells: cells) {
    case .failure(.spawnBlocked):
        break
    case .failure, .success:
        Issue.record("壁の中の初期位置を受け入れた")
    }
}

private func sampleRoom(
    width: Int,
    height: Int,
    spawn: CellPoint,
    cells: [CellKind]
) -> Result<Room, Room.Rejection> {
    switch RoomId.make(value: "first-ascent") {
    case .success(let id):
        let grid = RoomGrid(width: width, height: height, cells: cells)
        return Room.make(RoomSpec(id: id, spawn: spawn, grid: grid, ascent: .aside))
    case .failure:
        preconditionFailure("テストの部屋名が空")
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
