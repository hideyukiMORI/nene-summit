public enum Trail {
    public static func opening() -> Room {
        FirstAscent.make()
    }

    public static func after(_ room: Room) -> Room {
        if let next = LanePitch.follow(room) {
            return next
        }
        if let next = early(room.ascent) {
            return next
        }
        return late(room.ascent, room)
    }

    public static func beside(_ room: Room, toward side: Direction) -> Room? {
        if Border.leaves(room, toward: side) {
            let next = after(room)
            if next.ascent == room.ascent {
                return nil
            }
            return next
        }
        if side == .left {
            return earlier(room)
        }
        return nil
    }

    static func earlier(_ room: Room) -> Room? {
        if let back = LanePitch.back(room) {
            return back
        }
        if let back = earlyBack(room.ascent) {
            return back
        }
        return lateBack(room.ascent)
    }

    static func earlyBack(_ ascent: Ascent) -> Room? {
        switch ascent {
        case .second:
            return FirstAscent.make()
        case .spring:
            return SecondPitch.make()
        case .raft:
            return SpringPitch.make()
        case .lift:
            return RaftPitch.make()
        default:
            return nil
        }
    }

    static func lateBack(_ ascent: Ascent) -> Room? {
        switch ascent {
        case .well:
            return LiftPitch.make()
        case .slot:
            return WellPitch.make()
        case .span:
            return SlotPitch.make()
        case .fall:
            return SpanPitch.make()
        case .rift:
            return FallPitch.make()
        default:
            return nil
        }
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
