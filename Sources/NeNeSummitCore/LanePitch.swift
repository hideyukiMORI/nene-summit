public enum LanePitch {
    public static let count = 14

    static let mouths: [Direction] = [
        .up, .left, .down, .right, .right, .up, .right, .right, .right, .up, .right, .right, .right,
        .up,
    ]

    static let rears: [Direction] = [
        .left, .down, .right, .up, .left, .left, .down, .left, .left, .left, .left, .left, .left,
        .left,
    ]

    static let lips: [Int] = [1, 4, 1, 1, 4, 1, 20, 1, 8, 1, 9, 1, 1, 1]

    static let shafts: [Int] = [58, 24, 8, 1, 1, 1, 2, 1, 24, 40, 1, 1, 1, 58]

    static let titles = [
        "RISE", "LEDGE", "PIT", "CROSS", "WELL", "SHAFT", "LIFT", "VAULT", "FERRY", "SPIRE",
        "BLOOM", "SPAN", "GULF", "RIDGE",
    ]

    public static func make(_ index: Int) -> Room {
        RoomSketch.room(named: "lane-\(index)", rows: rows(index), ascent: .lane(index))
    }

    public static func name(_ index: Int) -> String {
        if index < 0 || index >= titles.count {
            return "BEND"
        }
        return titles[index]
    }

    static func mouth(_ index: Int) -> Direction {
        pick(mouths, index, fallback: .right)
    }

    static func rear(_ index: Int) -> Direction {
        pick(rears, index, fallback: .left)
    }

    static func row(_ index: Int) -> Int {
        if index < 0 || index >= lips.count {
            return 1
        }
        return lips[index]
    }

    static func column(_ index: Int) -> Int {
        if index < 0 || index >= shafts.count {
            return 1
        }
        return shafts[index]
    }

    static func order(_ ascent: Ascent) -> String {
        let total = count + 1
        if case .lane(let index) = ascent {
            return digit(index + 1) + "/" + digit(total)
        }
        if ascent == .rift {
            return digit(total) + "/" + digit(total)
        }
        return "--"
    }

    static func place(_ ascent: Ascent) -> Int {
        if case .lane(let index) = ascent {
            return index
        }
        if ascent == .rift {
            return count
        }
        return -1
    }

    static func follow(_ room: Room) -> Room? {
        switch room.ascent {
        case .fall:
            return BridgePitch.make()
        case .bridge:
            return make(0)
        case .lane(let index):
            if index + 1 < count {
                return make(index + 1)
            }
            return RiftPitch.make()
        default:
            return nil
        }
    }

    static func back(_ room: Room) -> Room? {
        switch room.ascent {
        case .bridge:
            return FallPitch.make()
        case .lane(let index):
            if index == 0 {
                return nil
            }
            return make(index - 1)
        case .rift:
            return make(count - 1)
        default:
            return nil
        }
    }

    private static func rows(_ index: Int) -> [String] {
        if index < 5 {
            return LaneA.rows(index)
        }
        if index < 10 {
            return LaneB.rows(index)
        }
        return LaneC.rows(index)
    }

    private static func pick(_ sides: [Direction], _ index: Int, fallback: Direction) -> Direction {
        if index < 0 || index >= sides.count {
            return fallback
        }
        return sides[index]
    }

    private static func digit(_ value: Int) -> String {
        if value < 10 {
            return "0" + String(value)
        }
        return String(value)
    }
}
