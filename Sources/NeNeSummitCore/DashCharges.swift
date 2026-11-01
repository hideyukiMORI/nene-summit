public struct DashCharges: Equatable, Sendable {
    public let remaining: Int

    private init(remaining: Int) {
        self.remaining = remaining
    }

    static let full = DashCharges(remaining: MotionPolicy.maxCharges)
    static let empty = DashCharges(remaining: 0)

    var isEmpty: Bool {
        remaining == 0
    }

    func spent() -> DashCharges {
        if remaining == 0 {
            return .empty
        }
        return DashCharges(remaining: remaining - 1)
    }
}
