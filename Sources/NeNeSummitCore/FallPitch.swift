public enum FallPitch {
    static let rows = [
        "......................",
        "######################",
        ".@........SSSS....D...",
        "##^^^###########.#.###",
    ]

    public static func make() -> Room {
        RoomSketch.room(named: "fall-pitch", rows: rows, ascent: .fall)
    }
}
