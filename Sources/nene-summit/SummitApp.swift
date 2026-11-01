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
        case .success(var session):
            play(&session)
        }
    }

    static func play(_ session: inout TerminalSession) {
        defer {
            session.close()
        }
        var watch = Watch.begin(in: FirstAscent.make())
        var keys = HeldPresses()
        var chord = PlayChord()
        let moment = Moment()
        while true {
            let strokes = session.poll()
            if strokes.contains(where: quits) {
                break
            }
            let now = moment.milliseconds()
            for stroke in strokes {
                keys.apply(stroke, at: now)
            }
            watch = watch.advance(human: chord.make(HeldBits.play(keys.take(at: now))))
            session.present(Canvas.draw(watch.state))
            session.wait(milliseconds: 16)
        }
    }

    static func quits(_ stroke: Stroke) -> Bool {
        switch stroke {
        case .pressed(let press), .typed(let press):
            return press == .quit
        case .released:
            return false
        }
    }
}
