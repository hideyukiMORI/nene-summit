public enum Border {
    public static func goal(_ room: Room) -> CellPoint? {
        guard opens(room.ascent) else {
            return nil
        }
        switch mouth(room.ascent) {
        case .right:
            return CellPoint(x: room.width - 1, y: along(room.ascent))
        case .left:
            return CellPoint(x: 0, y: along(room.ascent))
        case .up:
            return CellPoint(x: shaft(room.ascent), y: room.height - 1)
        case .down:
            return CellPoint(x: shaft(room.ascent), y: 0)
        }
    }

    static func mouth(_ ascent: Ascent) -> Direction {
        if case .lane(let index) = ascent {
            return LanePitch.mouth(index)
        }
        return .right
    }

    static func rear(_ ascent: Ascent) -> Direction {
        if case .lane(let index) = ascent {
            return LanePitch.rear(index)
        }
        return .left
    }

    static func leaves(_ room: Room, toward side: Direction) -> Bool {
        opens(room.ascent) && side == mouth(room.ascent)
    }

    static func leaks(_ room: Room, x: Int, y: Int) -> Bool {
        if opens(room.ascent) && outward(room, x: x, y: y, side: mouth(room.ascent)) {
            return true
        }
        if returns(room.ascent) && rearEdge(room, x: x, y: y) && entered(room, x: x, y: y) {
            return true
        }
        return false
    }

    static func side(_ room: Room, _ place: Place) -> Direction? {
        if opens(room.ascent) && passed(room, place, mouth(room.ascent)) {
            return mouth(room.ascent)
        }
        if returns(room.ascent) && passed(room, place, rear(room.ascent)) {
            return rear(room.ascent)
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

    private static func entered(_ room: Room, x: Int, y: Int) -> Bool {
        switch rear(room.ascent) {
        case .left, .right:
            return y == room.spawn.y || y == along(room.ascent)
        case .up, .down:
            return x == room.spawn.x || x == shaft(room.ascent)
        }
    }

    private static func rearEdge(_ room: Room, x: Int, y: Int) -> Bool {
        switch rear(room.ascent) {
        case .left:
            return x == -1
        case .right:
            return x == room.width
        case .up:
            return y == room.height
        case .down:
            return y == -1
        }
    }

    private static func outward(_ room: Room, x: Int, y: Int, side: Direction) -> Bool {
        let lip = along(room.ascent)
        let column = shaft(room.ascent)
        switch side {
        case .right:
            return x == room.width && y >= lip && y <= lip + 1
        case .left:
            return x == -1 && y >= lip && y <= lip + 1
        case .up:
            return y == room.height && x >= column && x <= column + 1
        case .down:
            return y == -1 && x >= column && x <= column + 1
        }
    }

    private static func passed(_ room: Room, _ place: Place, _ side: Direction) -> Bool {
        let scale = MotionPolicy.scale
        switch side {
        case .left:
            return place.x < 0
        case .right:
            return place.x + MotionPolicy.bodyWidth > room.width * scale
        case .up:
            return place.y + MotionPolicy.bodyHeight > room.height * scale
        case .down:
            return place.y < 0
        }
    }

    static func along(_ ascent: Ascent) -> Int {
        if case .lane(let index) = ascent {
            return LanePitch.row(index)
        }
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

    static func shaft(_ ascent: Ascent) -> Int {
        if case .lane(let index) = ascent {
            return LanePitch.column(index)
        }
        return 1
    }
}
