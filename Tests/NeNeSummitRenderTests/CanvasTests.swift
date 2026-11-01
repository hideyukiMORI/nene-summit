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
    #expect(text.contains("AUTO"))
    #expect(text.contains("q QUIT"))
    #expect(text.contains("#") == false)
    #expect(text.contains("^") == false)
    #expect(has(frame, .climber))
    #expect(has(frame, .stone))
    #expect(has(frame, .hazard))
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
