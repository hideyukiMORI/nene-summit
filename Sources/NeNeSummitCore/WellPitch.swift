public enum WellPitch {
    static let rows = [
        "#...#",
        "#...#",
        "#...#",
        "#@..#",
        "#####",
    ]

    public static func make() -> Room {
        RoomSketch.room(named: "well-pitch", rows: rows, ascent: .well)
    }
}
