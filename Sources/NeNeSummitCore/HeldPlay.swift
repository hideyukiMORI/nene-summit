public struct HeldPlay: Equatable, Sendable {
    public let bits: Int
    public static let left = 1
    public static let right = 2
    public static let up = 4
    public static let down = 8
    public static let jump = 16
    public static let dash = 32

    public init(bits: Int = 0) {
        self.bits = bits
    }

    public func contains(_ bit: Int) -> Bool {
        bits & bit != 0
    }

    public func with(_ bit: Int) -> HeldPlay {
        HeldPlay(bits: bits | bit)
    }
}
