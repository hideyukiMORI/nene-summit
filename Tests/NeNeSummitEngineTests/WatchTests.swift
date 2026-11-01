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

@Test func theSecondSummitReturnsToTheFirstRoom() {
    var watch = rest(climb(Watch.begin(in: FirstAscent.make())))
    #expect(watch.state.room.ascent == .second)
    watch = rest(climb(watch))
    #expect(watch.state.room.ascent == .first)
    #expect(watch.state.progress.expedition == .climbing)
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
