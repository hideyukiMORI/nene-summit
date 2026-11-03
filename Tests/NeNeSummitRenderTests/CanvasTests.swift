import Testing

@testable import NeNeSummitCore
@testable import NeNeSummitEngine
@testable import NeNeSummitRender

@Test func theFrameShowsTheClimberAndTheSummit() {
    let frame = Canvas.draw(SummitState.begin(in: FirstAscent.make()))
    let text = letters(frame)
    #expect(frame.lines.count == Stage.rows)
    #expect(frame.lines.allSatisfy { $0.count == Stage.columns })
    #expect(text.contains("NENE SUMMIT"))
    #expect(text.contains("ASCENT"))
    #expect(text.contains("COMMS"))
    #expect(text.contains("DASH"))
    #expect(text.contains("READY"))
    #expect(text.contains("HOLD"))
    #expect(text.contains("GROUND"))
    #expect(text.contains("BERRY"))
    #expect(text.contains("COIN"))
    #expect(text.contains("*'"))
    #expect(text.contains("(o"))
    #expect(text.contains("~"))
    #expect(text.contains("/\\"))
    #expect(text.contains("o>"))
    #expect(text.contains("AUTO"))
    #expect(text.contains("q QUIT"))
    #expect(text.contains("\u{250C}"))
    #expect(text.contains("\u{2500}"))
    #expect(text.contains("\u{2502}"))
    #expect(text.contains("#") == false)
    #expect(text.contains("^") == false)
    #expect(frame.lines[0][0].tone == .veil)
    #expect(frame.lines[Stage.rows - 1][0].tone == .veil)
    #expect(frame.lines[Stage.rows - 1][1].tone == .ink)
    #expect(has(frame, .climber))
    #expect(has(frame, .stone))
    #expect(has(frame, .hazard))
    #expect(has(frame, .gleam))
    #expect(has(frame, .coin))
    #expect(has(frame, .ridge))
    #expect(has(frame, .cloud))
    #expect(has(frame, .spark))
    #expect(has(frame, .sky))
}

@Test func bothRoomsShareOneScreen() {
    let first = Canvas.draw(SummitState.begin(in: FirstAscent.make()))
    let second = Canvas.draw(SummitState.begin(in: SecondPitch.make()))
    #expect(first.lines.count == second.lines.count)
    #expect(first.lines[0].count == second.lines[0].count)
    #expect(letters(second).contains("SHELF"))
}

@Test func theSpringAndTheRaftAreColoredFaces() {
    let spring = Canvas.draw(SummitState.begin(in: SpringPitch.make()))
    let raft = Canvas.draw(SummitState.begin(in: RaftPitch.make()))
    #expect(has(spring, .spring))
    #expect(has(raft, .stone))
    #expect(letters(spring).contains("SPRING"))
    #expect(letters(raft).contains("RAFT"))
}

@Test func aFarSpikeStaysOutsideTheWindow() {
    let frame = Canvas.draw(SummitState.begin(in: wideRoom()))
    #expect(has(frame, .hazard) == false)
    #expect(has(frame, .climber))
}

@Test func theManualStripSaysPlay() {
    let frame = Canvas.draw(SummitState.begin(in: FirstAscent.make()), attendance: .manual)
    let text = letters(frame)
    #expect(text.contains("PLAY"))
    #expect(text.contains("AUTO") == false)
}

@Test func theNoteSitsOnTheStrip() {
    let frame = Canvas.draw(SummitState.begin(in: FirstAscent.make()), note: "MIO (^^) made it")
    let text = letters(frame)
    #expect(text.contains("MIO"))
    #expect(text.contains("(^^)"))
    #expect(text.contains("made"))
}

@Test func theSummitBannerChangesAfterTheClimb() {
    var watch = Watch.begin(in: RiftPitch.make())
    var tick = 0
    while tick < Watch.budget && watch.state.progress.expedition != .summited {
        watch = watch.advance(human: .idle)
        tick += 1
    }
    let text = letters(Canvas.draw(watch.state))
    #expect(text.contains("CREST"))
    #expect(text.contains("NENE SUMMIT") == false)
}

@Test func drawingLeavesTheClimbWhereItWas() {
    let state = SummitState.begin(in: FirstAscent.make())
    _ = Canvas.draw(state)
    #expect(state == SummitState.begin(in: FirstAscent.make()))
    #expect(state.finds() == 0)
}

@Test func aFoundGleamLeavesTheSky() {
    let held = GleamBag.empty.taking(CellPoint(x: 4, y: 1))
    let state = SummitState.begin(in: FirstAscent.make(), gleams: held)
    #expect(has(Canvas.draw(state), .gleam) == false)
    #expect(state.finds() == 1)
}

@Test func distantRidgesSlipBehindTheCave() {
    let origin = CellPoint(x: 0, y: 0)
    let slid = CellPoint(x: 2, y: 0)
    let jumped = CellPoint(x: 3, y: 0)
    #expect(Scenery.ridge(viewX: 4, viewY: 4, origin: origin))
    #expect(Scenery.ridge(viewX: 4, viewY: 4, origin: slid))
    #expect(Scenery.ridge(viewX: 4, viewY: 4, origin: jumped) == false)
    let held = CellPoint(x: 4, y: 0)
    let passed = CellPoint(x: 5, y: 0)
    #expect(Scenery.cloud(viewX: 3, viewY: 2, origin: origin))
    #expect(Scenery.cloud(viewX: 3, viewY: 2, origin: held))
    #expect(Scenery.cloud(viewX: 3, viewY: 2, origin: passed) == false)
    #expect(Scenery.chip(viewX: 0, viewY: 0, origin: origin))
    #expect(Scenery.chip(viewX: 0, viewY: 0, origin: jumped) == false)
    #expect(Scenery.chip(viewX: 4, viewY: 1, origin: origin) == Scenery.chip(viewX: 1, viewY: 1, origin: jumped))
    #expect(Scenery.spark(viewX: 0, viewY: 0, origin: origin, tick: 0))
    #expect(Scenery.spark(viewX: 0, viewY: 0, origin: CellPoint(x: 1, y: 0), tick: 0))
    #expect(Scenery.spark(viewX: 0, viewY: 0, origin: CellPoint(x: 2, y: 0), tick: 0) == false)
    #expect(Scenery.spark(viewX: 0, viewY: 0, origin: origin, tick: 16) == false)
}

@Test func theFallRoomSlidesAsTheClimberMoves() {
    let room = FallPitch.make()
    let start = Viewport.origin(width: room.width, height: room.height, portrait: CellPoint(x: 2, y: 1))
    let later = Viewport.origin(
        width: room.width, height: room.height, portrait: CellPoint(x: 33, y: 1))
    #expect(room.width > Stage.fieldCellsX)
    #expect(start.x == 0)
    #expect(later.x > start.x)
}

@Test func aWideRoomShowsTheWayAhead() {
    let room = FallPitch.make()
    let portrait = CellPoint(x: 16, y: 1)
    let origin = Viewport.origin(width: room.width, height: room.height, portrait: portrait)
    #expect(origin.x > portrait.x - Stage.fieldCellsX / 2)
    #expect(origin.x + Stage.fieldCellsX <= room.width)
    let span = SpanPitch.make()
    let held = Viewport.origin(width: span.width, height: span.height, portrait: CellPoint(x: 1, y: 1))
    #expect(span.width <= Stage.fieldCellsX)
    #expect(span.height <= Stage.fieldCellsY)
    #expect(held.x == 0)
}

@Test func onePennantStandsOnTheLip() {
    let state = SummitState.begin(in: RiftPitch.make())
    #expect(FieldView.mark(state, x: 9, y: 4).text == "--")
    #expect(FieldView.mark(state, x: 11, y: 4).text == "|>")
    #expect(FieldView.mark(state, x: 12, y: 4).text == "--")
    #expect(FieldView.mark(state, x: 11, y: 4).tone == .crest)
    let opening = SummitState.begin(in: FirstAscent.make())
    #expect(FieldView.mark(opening, x: 30, y: 5).text == "  ")
    #expect(FieldView.mark(opening, x: 30, y: 5).tone != .crest)
    #expect(opening.room.kind(x: opening.room.width - 1, y: 5) == .open)
}

private func letters(_ frame: Frame) -> String {
    String(frame.lines.flatMap { $0.map(\.symbol) })
}

private func has(_ frame: Frame, _ tone: Glyph.Tone) -> Bool {
    frame.lines.flatMap { $0 }.contains { $0.tone == tone }
}

private func wideRoom() -> Room {
    let width = 40
    let height = 6
    var cells = [CellKind](repeating: .open, count: width * height)
    var x = 0
    while x < width {
        cells[x] = .solid
        x += 1
    }
    cells[1 * width] = .spike
    switch RoomId.make(value: "wide") {
    case .success(let id):
        let grid = RoomGrid(width: width, height: height, cells: cells)
        let spec = RoomSpec(id: id, spawn: CellPoint(x: 36, y: 1), grid: grid, ascent: .aside)
        switch Room.make(spec) {
        case .success(let room):
            return room
        case .failure:
            preconditionFailure("広い部屋が作れない")
        }
    case .failure:
        preconditionFailure("部屋名が空")
    }
}
