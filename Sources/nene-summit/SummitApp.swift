import NeNeSummitCore
import NeNeSummitRender
import NeNeSummitTerminal

@main
struct SummitApp {
    static func main() {
        switch TerminalSession.open() {
        case .failure:
            TerminalSession.fail("この端末では遊べない。")
        case .success(let session):
            play(session)
        }
    }

    static func play(_ session: TerminalSession) {
        defer {
            session.close()
        }
        var state = SummitState.begin(in: FirstAscent.make())
        var held = IntentBuffer()
        while true {
            let presses = session.poll()
            if presses.contains(.quit) {
                break
            }
            state = state.advance(input: held.take(presses)).state
            session.present(Canvas.draw(state))
            session.wait(milliseconds: 16)
        }
    }
}
