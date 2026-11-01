import Testing

@testable import NeNeSummitCore
@testable import NeNeSummitEngine
@testable import NeNeSummitRender

@Test func theFrameShowsTheClimberAndTheSummit() {
    let frame = Canvas.draw(SummitState.begin(in: FirstAscent.make()))
    let symbols = frame.lines.flatMap { $0.map(\.symbol) }
    let text = String(symbols)
    #expect(symbols.contains("A"))
    #expect(symbols.contains("#"))
    #expect(symbols.contains("^"))
    #expect(symbols.contains("*"))
    #expect(text.contains("DASH"))
    #expect(text.contains("q quit"))
}

@Test func theSummitBannerChangesAfterTheClimb() {
    var watch = Watch.begin(in: FirstAscent.make())
    var tick = 0
    while tick < Watch.budget && watch.state.progress.expedition != .summited {
        watch = watch.advance(human: .idle)
        tick += 1
    }
    let text = String(Canvas.draw(watch.state).lines.flatMap { $0.map(\.symbol) })
    #expect(text.contains("頂上"))
}
