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

    var foot: CellPoint {
        CellPoint(
            x: kinematics.place.x / MotionPolicy.scale,
            y: kinematics.place.y / MotionPolicy.scale
        )
    }

    public static func begin(in room: Room) -> SummitState {
        let place = Place(x: room.spawn.x * MotionPolicy.scale, y: room.spawn.y * MotionPolicy.scale)
        let kinematics = Kinematics(place: place, velocity: .still)
        let action = Action(facing: .right, phase: .grounded, dashTicks: 0, charges: .full)
        let progress = Progress(checkpoint: room.spawn, expedition: .climbing, tick: .zero)
        return SummitState(room: room, kinematics: kinematics, action: action, progress: progress)
    }

    public func advance(input: Input) -> StepOutcome {
        let progress = progress.ticked()
        if self.progress.expedition == .summited {
            let frozen = SummitState(room: room, kinematics: kinematics.stopped(), action: action, progress: progress)
            return StepOutcome(state: frozen, events: [.tick])
        }
        let wish = Wish.apply(self, input: input)
        let slide = Collider.slide(place: wish.kinematics.place, velocity: wish.kinematics.velocity, room: room)
        let resolved = Settlement.resolve(start: self, wish: wish, slide: slide, progress: progress)
        let next = SummitState(
            room: room,
            kinematics: resolved.kinematics,
            action: resolved.action,
            progress: resolved.progress
        )
        return StepOutcome(state: next, events: [.tick] + resolved.events)
    }
}
