public enum RiftPitch {
    public static func make() -> Room {
        RoomSketch.room(named: "rift-pitch", rows: rows(), ascent: .rift)
    }

    static func rows() -> [String] {
        var rows: [String] = []
        var y = LaneA.climbHeight - 1
        while y >= 0 {
            rows.append(LaneA.climbLine(y, flag: true))
            y -= 1
        }
        return rows
    }
}
