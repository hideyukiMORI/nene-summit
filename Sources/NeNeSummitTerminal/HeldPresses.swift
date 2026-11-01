public struct HeldPresses: Sendable {
    public static let releaseTimeout = 1_000
    public static let firstRepeat = 600
    public static let repeatGap = 120

    private struct Entry: Sendable {
        var lastSeen: Int
        var repeating: Bool
        var releasable: Bool
    }

    private var entries: [Press: Entry] = [:]
    private var latched: [Press] = []

    public init() {}

    public mutating func apply(_ stroke: Stroke, at now: Int) {
        switch stroke {
        case .pressed(let press):
            entries[press] = Entry(lastSeen: now, repeating: false, releasable: true)
            latched.append(press)
        case .released(let press):
            entries[press] = nil
        case .typed(let press):
            let repeating = entries[press].map { now - $0.lastSeen <= Self.firstRepeat + Self.repeatGap } ?? false
            entries[press] = Entry(lastSeen: now, repeating: repeating, releasable: false)
            latched.append(press)
        }
    }

    public mutating func take(at now: Int) -> [Press] {
        let held = Press.allCases.filter { press in
            guard let entry = entries[press] else {
                return false
            }
            return now - entry.lastSeen < window(entry)
        }
        let pressed = latched
        latched = []
        return Press.allCases.filter { held.contains($0) || pressed.contains($0) }
    }

    private func window(_ entry: Entry) -> Int {
        if entry.releasable {
            return Self.releaseTimeout
        }
        if entry.repeating {
            return Self.repeatGap
        }
        return Self.firstRepeat
    }
}
