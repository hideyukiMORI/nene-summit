import NeNeSummitCore
import NeNeSummitEngine
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
        var watch = Watch.begin(in: FirstAscent.make())
        var held = IntentBuffer()
        while true {
            let presses = session.poll()
            if presses.contains(.quit) {
                break
            }
            watch = watch.advance(human: held.take(presses))
            session.present(Canvas.draw(watch.state))
            session.wait(milliseconds: 16)
        }
    }
}
