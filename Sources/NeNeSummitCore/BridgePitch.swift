public enum BridgePitch {
    static let rows = [
        "..........................",
        "..........................",
        "..@.o.....................",
        "###ffffff#################",
        "..........................",
        "..........................",
        "###^^^^^^#################",
    ]

    public static func make() -> Room {
        RoomSketch.room(named: "bridge-pitch", rows: rows, ascent: .bridge)
    }
}
