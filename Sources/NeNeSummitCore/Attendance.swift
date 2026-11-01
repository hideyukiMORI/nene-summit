public enum Attendance: Equatable, Sendable {
    case automatic
    case manual

    public func flipped() -> Attendance {
        if self == .automatic {
            return .manual
        }
        return .automatic
    }
}
