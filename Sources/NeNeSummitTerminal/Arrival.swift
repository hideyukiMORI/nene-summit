public struct Arrival: Equatable, Sendable {
    public let bytes: [UInt8]
    public let strokes: [Stroke]

    public init(bytes: [UInt8], strokes: [Stroke]) {
        self.bytes = bytes
        self.strokes = strokes
    }
}
