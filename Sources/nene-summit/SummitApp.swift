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
        var watch = Watch.begin(in: Trail.opening())
        var keys = HeldPresses()
        var chord = PlayChord()
        var attendance = Attendance.automatic
        var modeDown = false
        var trace = PlayTrace.open()
        defer {
            trace?.close()
        }
        let moment = Moment()
        while true {
            let arrival = session.poll()
            let now = moment.milliseconds()
            for stroke in arrival.strokes {
                keys.apply(stroke, at: now)
            }
            let presses = keys.take(at: now)
            attendance = flipped(attendance, presses: presses, wasDown: &modeDown)
            let human = chord.make(HeldBits.play(presses))
            let before = watch.state
            watch = watch.advance(human: human, attendance: attendance)
            let sample = TraceSample(
                now: now,
                keys: TraceKeys(arrival: arrival, presses: presses, human: human, attendance: attendance),
                before: before,
                after: watch.state
            )
            if let line = sample.line() {
                trace?.write(line)
            }
            if arrival.strokes.contains(where: quits) {
                break
            }
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
