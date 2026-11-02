public enum WellPitch {
    static let rows = [
        "#.........................",
        "#..fff####################",
        "#..#######################",
        "#@.#######################",
        "##########################",
    ]

    public static func make() -> Room {
        RoomSketch.room(named: "well-pitch", rows: rows, ascent: .well)
    }
}
