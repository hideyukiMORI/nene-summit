public enum FallPitch {
    static let rows = [
        "......................",
        "..D...................",
        "##.###################",
        "##.###################",
        ".@........SSSS........",
        "##^^^#################",
    ]

    public static func make() -> Room {
        RoomSketch.room(named: "fall-pitch", rows: rows, ascent: .fall)
    }
}
