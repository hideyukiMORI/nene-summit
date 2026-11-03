public enum RiftPitch {
    public static func make() -> Room {
        RoomSketch.room(named: "rift-pitch", rows: rows(), ascent: .rift)
    }

    static func rows() -> [String] {
        var rows: [String] = [mast()]
        var y = LaneA.climbHeight - 1
        while y >= 0 {
            rows.append(LaneA.climbLine(y, flag: true))
            y -= 1
        }
        return rows
    }

    static func mast() -> String {
        var row = ""
        var x = 0
        while x < LaneA.climbWidth {
            if x == 58 {
                row.append("S")
            } else {
                row.append(".")
            }
            x += 1
        }
        return row
    }
}
