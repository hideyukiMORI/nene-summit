public enum LanePitch {
    static let count = 5

    public static func make(_ index: Int) -> Room {
        RoomSketch.room(named: "lane-\(index)", rows: rows(index), ascent: .lane(index))
    }

    public static func name(_ index: Int) -> String {
        switch index {
        case 0:
            return "RISE"
        case 1:
            return "WEST"
        case 2:
            return "DROP"
        case 3:
            return "CLING"
        default:
            return "VAULT"
        }
    }

    static func mouth(_ index: Int) -> Direction {
        switch index {
        case 0:
            return .up
        case 1:
            return .left
        case 2:
            return .down
        default:
            return .right
        }
    }

    static func rear(_ index: Int) -> Direction {
        switch index {
        case 0:
            return .left
        case 1:
            return .down
        case 2:
            return .right
        case 3:
            return .up
        default:
            return .left
        }
    }

    static func row(_ index: Int) -> Int {
        if index == 3 {
            return 9
        }
        return 1
    }

    static func column(_ index: Int) -> Int {
        if index == 2 {
            return 2
        }
        return 1
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
        case .lane(0):
            return BridgePitch.make()
        case .bridge:
            return FallPitch.make()
        case .lane(let index):
            return make(index - 1)
        case .rift:
            return make(count - 1)
        default:
            return nil
        }
    }

    private static func rows(_ index: Int) -> [String] {
        switch index {
        case 0:
            return [
                "#.########################",
                "#.########################",
                "#@########################",
                "##########################",
            ]
        case 1:
            return [
                "..........................",
                "..........................",
                "..........o..........$@...",
                "##########################",
            ]
        case 2:
            return [
                "..........................",
                "..........................",
                "......................@...",
                "##..######################",
            ]
        case 3:
            return [
                "..........................",
                "..........................",
                "..........................",
                "...#######################",
                "#.........................",
                "#.........................",
                "#.........................",
                "#.........................",
                "#.........................",
                "#.........................",
                "#@V.......................",
                "###^^^^^^^^^^^^^^^^^^^^^^^",
            ]
        default:
            return [
                "..........................",
                "..........................",
                "..@..$....................",
                "####^^^^##################",
            ]
        }
    }
}
