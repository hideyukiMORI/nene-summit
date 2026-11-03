public struct DashCharges: Equatable, Sendable {
    public let remaining: Int
    public let hops: Int

    private init(remaining: Int, hops: Int) {
        self.remaining = remaining
        self.hops = hops
    }

    static let full = DashCharges(remaining: MotionPolicy.maxCharges, hops: MotionPolicy.maxHops)
    static let empty = DashCharges(remaining: 0, hops: 0)

    var isEmpty: Bool {
        remaining == 0
    }

    func spent() -> DashCharges {
        if remaining == 0 {
            return self
        }
        return DashCharges(remaining: remaining - 1, hops: hops)
    }

    func hopped() -> DashCharges {
        if hops == 0 {
            return self
        }
        return DashCharges(remaining: remaining, hops: hops - 1)
    }
}
