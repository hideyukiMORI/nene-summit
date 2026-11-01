struct Moment: Sendable {
    private let clock: ContinuousClock
    private let started: ContinuousClock.Instant

    init() {
        let clock = ContinuousClock()
        self.clock = clock
        started = clock.now
    }

    func milliseconds() -> Int {
        let parts = (clock.now - started).components
        let seconds = Int(parts.seconds) * 1_000
        let fraction = Int(parts.attoseconds / 1_000_000_000_000_000)
        return seconds + fraction
    }
}
