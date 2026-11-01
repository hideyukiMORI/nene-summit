import Testing

@testable import NeNeSummitCore
@testable import NeNeSummitRender

@Test func theFrameShowsTheClimberAndTheSummit() {
    let frame = Canvas.draw(SummitState.begin(in: FirstAscent.make()))
    let symbols = frame.lines.flatMap { $0.map(\.symbol) }
    #expect(symbols.contains("A"))
    #expect(symbols.contains("#"))
    #expect(symbols.contains("^"))
    #expect(symbols.contains("*"))
}

@Test func theSummitBannerChangesAfterTheClimb() {
    var state = SummitState.begin(in: FirstAscent.make())
    var tick = 0
    while tick < 500 && state.progress.expedition != .summited {
        let input: Input = state.action.phase == .grounded ? .hopping(.right) : .moving(.right)
        state = state.advance(input: input).state
        tick += 1
    }
    let title = String(Canvas.draw(state).lines[0].map(\.symbol))
    #expect(title.contains("頂上"))
}
