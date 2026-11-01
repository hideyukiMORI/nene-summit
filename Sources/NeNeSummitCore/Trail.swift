public enum Trail {
    public static func opening() -> Room {
        FirstAscent.make()
    }

    public static func after(_ room: Room) -> Room {
        switch room.ascent {
        case .first:
            return SecondPitch.make()
        case .second:
            return FirstAscent.make()
        case .aside:
            return room
        }
    }
}
