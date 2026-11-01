struct Room: Equatable, Sendable {
    enum Rejection: Error, Equatable, Sendable {
        case widthNotPositive
        case heightNotPositive
        case spawnOutside
    }

    let id: RoomId
    let width: Int
    let height: Int
    let spawn: CellPoint

    private init(id: RoomId, width: Int, height: Int, spawn: CellPoint) {
        self.id = id
        self.width = width
        self.height = height
        self.spawn = spawn
    }

    static func make(id: RoomId, width: Int, height: Int, spawn: CellPoint) -> Result<Room, Rejection> {
        if width <= 0 {
            return .failure(.widthNotPositive)
        }
        if height <= 0 {
            return .failure(.heightNotPositive)
        }
        if !contains(width: width, height: height, point: spawn) {
            return .failure(.spawnOutside)
        }
        return .success(Room(id: id, width: width, height: height, spawn: spawn))
    }

    private static func contains(width: Int, height: Int, point: CellPoint) -> Bool {
        point.x >= 0 && point.x < width && point.y >= 0 && point.y < height
    }
}
