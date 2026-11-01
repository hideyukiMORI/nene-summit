public enum RaftPitch {
    static let rows = [
        "........................",
        "........................",
        "........................",
        "........................",
        "........................",
        "........................",
        "..@.............SSSSS...",
        "####MMM^^^^^^^##########",
    ]

    public static func make() -> Room {
        RoomSketch.room(named: "raft-pitch", rows: rows, ascent: .raft)
    }
}
