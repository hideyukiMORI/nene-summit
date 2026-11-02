public enum Border {
    public static func goal(_ room: Room) -> CellPoint? {
        if room.ascent == .well {
            return CellPoint(x: room.width / 2, y: room.height - 1)
        }
        guard opens(room.ascent) else {
            return nil
        }
        return CellPoint(x: room.width - 1, y: along(room.ascent))
    }

    static func leaves(_ room: Room, toward side: Direction) -> Bool {
        if side == .up {
            return room.ascent == .well
        }
        if side == .right {
            return opens(room.ascent)
        }
        return false
    }

    static func leaks(_ room: Room, x: Int, y: Int) -> Bool {
        if room.ascent == .well && y == room.height && x > 0 && x < room.width - 1 {
            return true
        }
        if opens(room.ascent) && x == room.width && clears(room.ascent, y) {
            return true
        }
        if x == -1 && y == room.spawn.y && returns(room.ascent) {
            return true
        }
        return false
    }

    static func side(_ room: Room, _ place: Place) -> Direction? {
        if place.x < 0 {
            return .left
        }
        let span = Probe.covering(place)
        if room.ascent == .well && span.y1 >= room.height - 1 && span.x0 < room.width - 1 {
            return .up
        }
        if opens(room.ascent) && span.x1 >= room.width - 1 && clears(room.ascent, span.y0) {
            return .right
        }
        return nil
    }

    private static func opens(_ ascent: Ascent) -> Bool {
        switch ascent {
        case .rift, .aside, .well:
            return false
        default:
            return true
        }
    }

    private static func returns(_ ascent: Ascent) -> Bool {
        ascent != .first && ascent != .aside
    }

    private static func clears(_ ascent: Ascent, _ y: Int) -> Bool {
        let lip = along(ascent)
        return y >= lip && y <= lip + 1
    }

    private static func along(_ ascent: Ascent) -> Int {
        switch ascent {
        case .first, .second:
            return 5
        case .spring:
            return 8
        case .lift:
            return 9
        default:
            return 1
        }
    }
}
