public enum FramePace {
    public static let milliseconds = 40

    public static func remaining(started: Int, now: Int) -> Int {
        if now < started {
            return milliseconds
        }
        let spent = now - started
        if spent >= milliseconds {
            return 0
        }
        return milliseconds - spent
    }
}
