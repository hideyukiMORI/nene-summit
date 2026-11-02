public struct Room: Equatable, Sendable {
    enum Rejection: Error, Equatable, Sendable {
        case widthNotPositive
        case heightNotPositive
        case spawnOutside
        case cellCount
        case spawnBlocked
    }

    let id: RoomId
    public let width: Int
    public let height: Int
    let spawn: CellPoint
    let cells: [CellKind]
    let decks: [Deck]
    let ascent: Ascent

    private init(spec: RoomSpec) {
        id = spec.id
        width = spec.grid.width
        height = spec.grid.height
        spawn = spec.spawn
        cells = spec.grid.cells
        decks = spec.grid.decks
        ascent = spec.ascent
    }

    static func make(_ spec: RoomSpec) -> Result<Room, Rejection> {
        if spec.grid.width <= 0 {
            return .failure(.widthNotPositive)
        }
        if spec.grid.height <= 0 {
            return .failure(.heightNotPositive)
        }
        if !contains(spec.spawn, width: spec.grid.width, height: spec.grid.height) {
            return .failure(.spawnOutside)
        }
        if spec.grid.cells.count != spec.grid.width * spec.grid.height {
            return .failure(.cellCount)
        }
        if blocked(spec) {
            return .failure(.spawnBlocked)
        }
        return .success(Room(spec: spec))
    }

    public func title() -> String {
        if let early = earlyTitle(ascent) {
            return early
        }
        return lateTitle(ascent)
    }

    private func earlyTitle(_ ascent: Ascent) -> String? {
        switch ascent {
        case .first:
            return "RIDGE"
        case .second:
            return "SHELF"
        case .spring:
            return "SPRING"
        case .raft:
            return "RAFT"
        default:
            return nil
        }
    }

    private func lateTitle(_ ascent: Ascent) -> String {
        switch ascent {
        case .lift:
            return "LIFT"
        case .well:
            return "WELL"
        case .slot:
            return "SLOT"
        case .span:
            return "SPAN"
        case .fall:
            return "FALL"
        case .rift:
            return "RIFT"
        case .aside:
            return "PITCH"
        default:
            return "PITCH"
        }
    }

    public func kind(x: Int, y: Int) -> CellKind {
        if x < 0 || y < 0 || x >= width || y >= height {
            return .solid
        }
        return cells[y * width + x]
    }

    public func moving(x: Int, y: Int, tick: Int) -> Bool {
        DeckField.covers(self, x: x, y: y, tick: tick)
    }

    public func crushing(x: Int, y: Int, tick: Int) -> Bool {
        DeckField.crushes(self, x: x, y: y, tick: tick)
    }

    public func firm(x: Int, y: Int, tick: Int) -> Bool {
        kind(x: x, y: y) == .crumble && Crumble.holds(tick)
    }

    private static func contains(_ point: CellPoint, width: Int, height: Int) -> Bool {
        point.x >= 0 && point.x < width && point.y >= 0 && point.y < height
    }

    private static func blocked(_ spec: RoomSpec) -> Bool {
        let kind = spec.grid.cells[spec.spawn.y * spec.grid.width + spec.spawn.x]
        switch kind {
        case .open, .checkpoint, .spring, .gleam, .coin, .refill:
            return false
        case .solid, .spike, .summit, .crumble:
            return true
        }
    }
}
