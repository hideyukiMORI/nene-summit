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
        var attendance = Attendance.automatic
        var modeDown = false
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
            let presses = keys.take(at: now)
            attendance = flipped(attendance, presses: presses, wasDown: &modeDown)
            let human = chord.make(HeldBits.play(presses))
            watch = watch.advance(human: human, attendance: attendance)
            session.present(Canvas.draw(watch.state, attendance: attendance))
            session.wait(milliseconds: 16)
        }
    }

    static func flipped(_ attendance: Attendance, presses: [Press], wasDown: inout Bool) -> Attendance {
        let down = presses.contains(.mode)
        let edge = down && !wasDown
        wasDown = down
        if edge {
            return attendance.flipped()
        }
        return attendance
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
