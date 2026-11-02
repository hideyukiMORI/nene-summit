import Testing

@testable import NeNeSummitCore
@testable import NeNeSummitEngine

@Test func aGlanceLeavesTheLiveState() {
    let live = SummitState.begin(in: FirstAscent.make())
    let before = live
    let choice = Lookahead.choose(live)
    #expect(live == before)
    #expect(choice.horizontal == .right)
}

@Test func aPitPrefersAMoveThatDoesNotFall() {
    let live = SummitState.begin(in: pitRoom())
    let walking = Lookahead.glimpse(live, opening: .moving(.right), wait: 0)
    let choice = Lookahead.choose(live)
    #expect(walking.fell)
    #expect(choice != .moving(.right))
    #expect(live == SummitState.begin(in: pitRoom()))
}

private func pitRoom() -> Room {
    let width = 14
    let height = 6
    var cells = [CellKind](repeating: .open, count: width * height)
    var x = 0
    while x < width {
        if x < 4 || x > 8 {
            cells[x] = .solid
        } else {
            cells[width + x] = .spike
        }
        x += 1
    }
    cells[5 * width + 12] = .summit
    switch RoomId.make(value: "pit") {
    case .success(let id):
        let grid = RoomGrid(width: width, height: height, cells: cells)
        let spec = RoomSpec(id: id, spawn: CellPoint(x: 1, y: 1), grid: grid, ascent: .aside)
        switch Room.make(spec) {
        case .success(let room):
            return room
        case .failure:
            preconditionFailure("隙間の部屋が作れない")
        }
    case .failure:
        preconditionFailure("部屋名が空")
    }
}
