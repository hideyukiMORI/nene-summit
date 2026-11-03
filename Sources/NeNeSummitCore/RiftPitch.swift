public enum RiftPitch {
    static let rows = [
        "#SSSS#####################",
        "#..#######################",
        "#..#######################",
        "#.^#######################",
        "#@..######################",
        "#ffffff###################",
        "#......###################",
    ]

    public static func make() -> Room {
        RoomSketch.room(named: "rift-pitch", rows: rows, ascent: .rift)
    }
}
