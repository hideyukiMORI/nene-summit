public enum Trail {
    public static func opening() -> Room {
        FirstAscent.make()
    }

    public static func after(_ room: Room) -> Room {
        if let next = early(room.ascent) {
            return next
        }
        return late(room.ascent, room)
    }

    static func early(_ ascent: Ascent) -> Room? {
        switch ascent {
        case .first:
            return SecondPitch.make()
        case .second:
            return SpringPitch.make()
        case .spring:
            return RaftPitch.make()
        case .raft:
            return LiftPitch.make()
        default:
            return nil
        }
    }

    static func late(_ ascent: Ascent, _ room: Room) -> Room {
        switch ascent {
        case .lift:
            return WellPitch.make()
        case .well:
            return SlotPitch.make()
        case .slot:
            return SpanPitch.make()
        case .span:
            return FallPitch.make()
        case .fall:
            return RiftPitch.make()
        case .rift:
            return FirstAscent.make()
        case .aside:
            return room
        default:
            return room
        }
    }
}
