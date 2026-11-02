public enum LanePitch {
    struct Spec: Equatable, Sendable {
        let name: String
        let walk: String
        let floor: String

        init(_ name: String, _ walk: String, _ floor: String) {
            self.name = name
            self.walk = walk
            self.floor = floor
        }
    }

    static let count = 18

    public static func make(_ index: Int) -> Room {
        let spec = course(index)
        let sky = String(repeating: ".", count: 26)
        let head = sheltered(index) ? String(repeating: "#", count: 26) : sky
        let rows = [sky, sky, head, spec.walk, spec.floor]
        return RoomSketch.room(named: "lane-\(index)", rows: rows, ascent: .lane(index))
    }

    public static func name(_ index: Int) -> String {
        course(index).name
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

    private static func sheltered(_ index: Int) -> Bool {
        switch index {
        case 0, 6, 10, 15:
            return true
        default:
            return false
        }
    }

    private static func course(_ index: Int) -> Spec {
        if let early = earlyCourse(index) {
            return early
        }
        return lateCourse(index)
    }

    private static func earlyCourse(_ index: Int) -> Spec? {
        switch index {
        case 0:
            return Spec("FERRY", "..@..o....$...............", "##########################")
        case 1:
            return Spec("HASTE", "..@.......................", "####HHHH^^^^^^############")
        case 2:
            return Spec("DRIFT", "..@..o....................", "####LLLL^^################")
        case 3:
            return Spec("WEST", "..@.......................", "################WWWW######")
        case 4:
            return Spec("TWIN", "..@..$....................", "##MMMM########MMMM########")
        case 5:
            return Spec("PURSE", "..@..$..$..$..............", "##########################")
        case 6:
            return Spec("GROVE", "..@.o..o..o...............", "##########################")
        case 7:
            return Spec("TEMPO", "..@....$..................", "####HHHH^^^^##############")
        default:
            return nil
        }
    }

    private static func lateCourse(_ index: Int) -> Spec {
        switch index {
        case 8:
            return Spec("LINGER", "..@..o....................", "####LLLL^^################")
        case 9:
            return Spec("BRAID", "..@.......................", "##HHHH######LLLL##########")
        case 10:
            return Spec("VAULT", "..@..o..$.................", "##########################")
        case 11:
            return Spec("NICK", "..@..o....................", "###ffff###################")
        case 12:
            return Spec("PERCH", "..@......$................", "####^^^###################")
        case 13:
            return Spec("RELAY", "..@........$..............", "##HHHH########LLLL########")
        case 14:
            return Spec("SPARK", "..@.R.......$.............", "######^^^#################")
        case 15:
            return Spec("KNOLL", "..@o.o.o..................", "##########################")
        case 16:
            return Spec("STACK", "..@..$....................", "######MMMM^^^^############")
        default:
            return Spec("TOLL", "..@.$..$..................", "####fff###################")
        }
    }
}
