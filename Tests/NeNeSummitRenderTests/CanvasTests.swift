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
    #expect(text.contains("STATUS"))
    #expect(text.contains("COMMS"))
    #expect(text.contains("DASH"))
    #expect(text.contains("READY"))
    #expect(text.contains("HOLD"))
    #expect(text.contains("GROUND"))
    #expect(text.contains("ALT"))
    #expect(text.contains("GLEAM"))
    #expect(text.contains("AUTO"))
    #expect(text.contains("q QUIT"))
    #expect(text.contains("\u{250C}"))
    #expect(text.contains("\u{2500}"))
    #expect(text.contains("\u{2502}"))
    #expect(text.contains("#") == false)
    #expect(text.contains("^") == false)
    #expect(frame.lines[0][0].tone == .veil)
    #expect(frame.lines[Stage.rows - 1][0].tone == .veil)
    #expect(frame.lines[Stage.rows - 1][1].tone == .hint)
    #expect(has(frame, .climber))
    #expect(has(frame, .stone))
    #expect(has(frame, .hazard))
    #expect(has(frame, .gleam))
    #expect(has(frame, .ridge))
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
    var watch = Watch.begin(in: FirstAscent.make())
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
    #expect(Scenery.ridge(viewX: 6, viewY: 8, origin: origin))
    #expect(Scenery.ridge(viewX: 6, viewY: 8, origin: slid))
    #expect(Scenery.ridge(viewX: 6, viewY: 8, origin: jumped) == false)
    #expect(Scenery.chip(viewX: 0, viewY: 0, origin: origin))
    #expect(Scenery.chip(viewX: 0, viewY: 0, origin: jumped) == false)
    #expect(Scenery.chip(viewX: 4, viewY: 1, origin: origin) == Scenery.chip(viewX: 1, viewY: 1, origin: jumped))
    #expect(Scenery.spark(viewX: 0, viewY: 0, origin: origin, tick: 0))
    #expect(Scenery.spark(viewX: 0, viewY: 0, origin: CellPoint(x: 1, y: 0), tick: 0))
    #expect(Scenery.spark(viewX: 0, viewY: 0, origin: CellPoint(x: 2, y: 0), tick: 0) == false)
    #expect(Scenery.spark(viewX: 0, viewY: 0, origin: origin, tick: 16) == false)
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
