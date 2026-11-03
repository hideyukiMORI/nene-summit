public enum LanePitch {
    public static let count = 7

    public static func make(_ index: Int) -> Room {
        RoomSketch.room(named: "lane-\(index)", rows: rows(index), ascent: .lane(index))
    }

    public static func name(_ index: Int) -> String {
        switch index {
        case 0:
            return "RISE"
        case 1:
            return "RIDGE"
        case 2:
            return "LIFT"
        case 3:
            return "WEST"
        case 4:
            return "DROP"
        case 5:
            return "WELL"
        default:
            return "VAULT"
        }
    }

    static func mouth(_ index: Int) -> Direction {
        switch index {
        case 0:
            return .up
        case 3:
            return .left
        case 4:
            return .down
        default:
            return .right
        }
    }

    static func rear(_ index: Int) -> Direction {
        switch index {
        case 3:
            return .right
        case 4:
            return .right
        default:
            return .left
        }
    }

    static func row(_ index: Int) -> Int {
        switch index {
        case 1, 5:
            return 4
        case 2:
            return 9
        default:
            return 1
        }
    }

    static func column(_ index: Int) -> Int {
        if index == 4 {
            return 2
        }
        return 1
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

    private static func digit(_ value: Int) -> String {
        if value < 10 {
            return "0" + String(value)
        }
        return String(value)
    }

    private static func rows(_ index: Int) -> [String] {
        switch index {
        case 0:
            return rise()
        case 1:
            return ridge()
        case 2:
            return lift()
        case 3:
            return west()
        case 4:
            return drop()
        case 5:
            return well()
        default:
            return vault()
        }
    }

    private static func rise() -> [String] {
        [
            "#..#######################",
            "#..#######################",
            "#..#######################",
            "#@..######################",
            "##########################",
        ]
    }

    private static func ridge() -> [String] {
        [
            "#.........................",
            "#..fff####################",
            "#..#######################",
            "#@.#######################",
            "##########################",
        ]
    }

    private static func lift() -> [String] {
        [
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
    }

    private static func west() -> [String] {
        [
            "##########################",
            "....................$o@...",
            "##########################",
        ]
    }

    private static func drop() -> [String] {
        [
            "..........................",
            "..........................",
            "......................@...",
            "##..######################",
        ]
    }

    private static func well() -> [String] {
        [
            "#.........................",
            "#...fff###################",
            "#...######################",
            "#@..######################",
            "##########################",
        ]
    }

    private static func vault() -> [String] {
        [
            "..........................",
            "................######....",
            "..@..$....................",
            "####^^^^##################",
        ]
    }
}
