public enum Border {
    public static func goal(_ room: Room) -> CellPoint? {
        guard opens(room.ascent) else {
            return nil
        }
        return CellPoint(x: room.width - 1, y: along(room.ascent))
    }

    static func leaves(_ room: Room, toward side: Direction) -> Bool {
        side == .right && opens(room.ascent)
    }

    static func leaks(_ room: Room, x: Int, y: Int) -> Bool {
        if opens(room.ascent) && x == room.width && clears(room.ascent, y) {
            return true
        }
        if x == -1 && returns(room.ascent) && entered(room, y) {
            return true
        }
        return false
    }

    static func side(_ room: Room, _ place: Place) -> Direction? {
        let scale = MotionPolicy.scale
        if place.x < 0 {
            return .left
        }
        if opens(room.ascent) && place.x + MotionPolicy.bodyWidth > room.width * scale {
            return .right
        }
        return nil
    }

    private static func opens(_ ascent: Ascent) -> Bool {
        switch ascent {
        case .rift, .aside:
            return false
        default:
            return true
        }
    }

    private static func returns(_ ascent: Ascent) -> Bool {
        ascent != .first && ascent != .aside
    }

    private static func entered(_ room: Room, _ y: Int) -> Bool {
        y == room.spawn.y || y == along(room.ascent)
    }

    private static func clears(_ ascent: Ascent, _ y: Int) -> Bool {
        let lip = along(ascent)
        return y >= lip && y <= lip + 1
    }

    static func along(_ ascent: Ascent) -> Int {
        switch ascent {
        case .first, .second:
            return 5
        case .spring:
            return 8
        case .lift:
            return 9
        case .well:
            return 4
        case .bridge:
            return 4
        default:
            return 1
        }
    }
}
