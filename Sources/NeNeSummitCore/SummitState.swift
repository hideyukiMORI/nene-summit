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
        return StepOutcome(state: next, events: [.tick] + resolved.events)
    }
}
