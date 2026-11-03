public struct SummitState: Equatable, Sendable {
    public let room: Room
    let kinematics: Kinematics
    public let action: Action
    public let progress: Progress

    private init(room: Room, kinematics: Kinematics, action: Action, progress: Progress) {
        self.room = room
        self.kinematics = kinematics
        self.action = action
        self.progress = progress
    }

    public func dashing() -> Bool {
        action.dashTicks > 0
    }

    public func portrait() -> CellPoint {
        let place = kinematics.place
        let x = (place.x + MotionPolicy.bodyWidth / 2) / MotionPolicy.scale
        let y = (place.y + MotionPolicy.bodyHeight / 2) / MotionPolicy.scale
        return CellPoint(x: x, y: y)
    }

    public func paceX() -> Int {
        kinematics.velocity.x
    }

    public func paceY() -> Int {
        kinematics.velocity.y
    }

    public func elapsed() -> Int {
        progress.tick.count
    }

    public func finds() -> Int {
        progress.gleams.count()
    }

    public func berries() -> Int {
        progress.gleams.berryCount()
    }

    public func coins() -> Int {
        progress.gleams.coinCount()
    }

    public func gathered(x: Int, y: Int) -> Bool {
        progress.gleams.holds(x: x, y: y)
    }

    public func bag() -> GleamBag {
        progress.gleams
    }

    var foot: CellPoint {
        CellPoint(
            x: kinematics.place.x / MotionPolicy.scale,
            y: kinematics.place.y / MotionPolicy.scale
        )
    }

    func riding(_ place: Place) -> SummitState {
        SummitState(room: room, kinematics: kinematics.at(place), action: action, progress: progress)
    }

    private static func arrival(_ room: Room, toward side: Direction) -> CellPoint {
        switch side {
        case .right:
            return CellPoint(x: firstOpen(room, y: room.spawn.y), y: room.spawn.y)
        case .left:
            return CellPoint(x: lastOpen(room, y: room.spawn.y), y: room.spawn.y)
        case .up:
            return CellPoint(x: room.spawn.x, y: lowOpen(room, x: room.spawn.x))
        case .down:
            return CellPoint(x: room.spawn.x, y: highOpen(room, x: room.spawn.x))
        }
    }

    private static func firstOpen(_ room: Room, y: Int) -> Int {
        var x = 0
        while x < room.width {
            if clear(room, x: x, y: y) {
                return x
            }
            x += 1
        }
        return room.spawn.x
    }

    private static func lastOpen(_ room: Room, y: Int) -> Int {
        var x = room.width - 1
        while x >= 0 {
            if clear(room, x: x, y: y) {
                return x
            }
            x -= 1
        }
        return room.spawn.x
    }

    private static func lowOpen(_ room: Room, x: Int) -> Int {
        var y = 1
        while y < room.height {
            if clear(room, x: x, y: y) {
                return y
            }
            y += 1
        }
        return room.spawn.y
    }

    private static func highOpen(_ room: Room, x: Int) -> Int {
        var y = room.height - 2
        if y < 1 {
            return room.spawn.y
        }
        while y > 0 {
            if clear(room, x: x, y: y) {
                return y
            }
            y -= 1
        }
        return room.spawn.y
    }

    private static func clear(_ room: Room, x: Int, y: Int) -> Bool {
        switch room.kind(x: x, y: y) {
        case .solid, .spike:
            return false
        default:
            return true
        }
    }

    public func turningBack() -> Bool {
        crossing() == Border.rear(room.ascent)
    }

    public func crossing() -> Direction? {
        Border.side(room, kinematics.place)
    }

    public func carry(into next: Room, toward side: Direction) -> SummitState {
        let scale = MotionPolicy.scale
        let cell = Self.arrival(next, toward: side)
        let place = Place(x: cell.x * scale, y: cell.y * scale)
        let velocity = kinematics.velocity
        let matter = Matter(room: next, tick: 0)
        let standing = Probe.supported(place: place, matter: matter)
        let phase: Phase = standing && velocity.y <= 0 ? .grounded : .air
        let action = Action(facing: action.facing, phase: phase, dashTicks: 0, charges: .full)
        let progress = Progress(
            checkpoint: cell,
            expedition: .climbing,
            tick: .zero,
            gleams: progress.gleams.carried()
        )
        let kinematics = Kinematics(place: place, velocity: velocity)
        return SummitState(room: next, kinematics: kinematics, action: action, progress: progress)
    }

    public static func begin(in room: Room, gleams: GleamBag = .empty) -> SummitState {
        let place = Place(x: room.spawn.x * MotionPolicy.scale, y: room.spawn.y * MotionPolicy.scale)
        let kinematics = Kinematics(place: place, velocity: .still)
        let action = Action(facing: .right, phase: .grounded, dashTicks: 0, charges: .full)
        let progress = Progress(checkpoint: room.spawn, expedition: .climbing, tick: .zero, gleams: gleams)
        return SummitState(room: room, kinematics: kinematics, action: action, progress: progress)
    }

    public func advance(input: Input) -> StepOutcome {
        let progress = progress.ticked()
        if self.progress.expedition == .summited {
            let frozen = SummitState(room: room, kinematics: kinematics.stopped(), action: action, progress: progress)
            return StepOutcome(state: frozen, events: [.tick])
        }
        let place = DeckField.ride(
            kinematics.place, room: room, from: self.progress.tick.count, to: progress.tick.count)
        let wish = Wish.apply(riding(place), input: input)
        let matter = Matter(room: room, tick: progress.tick.count)
        let slide = Collider.slide(place: wish.kinematics.place, velocity: wish.kinematics.velocity, matter: matter)
        let resolved = Settlement.resolve(start: self, wish: wish, slide: slide, progress: progress)
        let next = SummitState(
            room: room,
            kinematics: resolved.kinematics,
            action: resolved.action,
            progress: resolved.progress
        )
        return StepOutcome(state: next, events: departing(resolved.events, next))
    }

    private func departing(_ events: [StepEvent], _ next: SummitState) -> [StepEvent] {
        let stepped = [StepEvent.tick] + events
        if stepped.contains(.departed) {
            return stepped
        }
        guard let side = next.crossing(), Trail.beside(room, toward: side) != nil else {
            return stepped
        }
        return stepped + [.departed]
    }
}
