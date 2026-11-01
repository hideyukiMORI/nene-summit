public enum Trail {
    public static func opening() -> Room {
        FirstAscent.make()
    }

    public static func after(_ room: Room) -> Room {
        switch room.ascent {
        case .first:
            return SecondPitch.make()
        case .second:
            return SpringPitch.make()
        case .spring:
            return RaftPitch.make()
        case .raft:
            return LiftPitch.make()
        case .lift:
            return WellPitch.make()
        case .well:
            return FirstAscent.make()
        case .aside:
            return room
        }
    }
}
