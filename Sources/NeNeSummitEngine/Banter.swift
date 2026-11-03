import NeNeSummitCore

public struct Banter: Equatable, Sendable {
    public private(set) var line: String
    private var quietUntil: Int
    private var lastTick: Int
    private var tally: Tally
    private var voice: Int
    private var rooms: Int
    private var spoken: [String]

    static let gap = 48

    struct Tally: Equatable, Sendable {
        var counts = [0, 0, 0, 0, 0]

        mutating func take(_ cue: Cue) -> Int {
            let index = cue.rank - 1
            let spoken = counts[index]
            counts[index] += 1
            return spoken
        }
    }

    public init() {
        line = ""
        quietUntil = 0
        lastTick = 0
        tally = Tally()
        voice = 0
        rooms = 0
        spoken = []
    }

    public func script() -> String {
        if spoken.isEmpty {
            return line
        }
        return spoken.joined(separator: "\n")
    }

    public mutating func listen(_ events: [StepEvent], at tick: Int, opened: Bool) {
        if tick < lastTick {
            quietUntil = tick
        }
        lastTick = tick
        if opened {
            voice = rooms % 4
            rooms += 1
        }
        guard let cue = Cue.choose(events, opened: opened) else {
            return
        }
        if !cue.interrupts && tick < quietUntil {
            return
        }
        line = Cast.say(voice, cue: cue, index: tally.take(cue))
        spoken.append(line)
        if spoken.count > 4 {
            spoken.removeFirst()
        }
        quietUntil = tick + Banter.gap
    }
}
