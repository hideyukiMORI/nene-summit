enum Settlement {
    static func resolve(start: SummitState, wish: WishResult, slide: Slide, progress: Progress) -> Resolved {
        let phase = phase(after: slide, room: start.room)
        let charges = refilled(phase, previous: start.action.phase, charges: wish.action.charges)
        let action = Action(
            facing: wish.action.facing,
            phase: phase,
            dashTicks: wish.action.dashTicks,
            charges: charges
        )
        switch Probe.contact(place: slide.place, room: start.room) {
        case .spike:
            return respawn(start, wish: wish, progress: progress)
        case .summit:
            return arrive(slide, action: action, progress: progress, events: wish.events + [.summited])
        case .checkpoint(let cell):
            let marked = progress.withCheckpoint(cell)
            return Resolved(kinematics: slide.kinematics, action: action, progress: marked, events: wish.events)
        case .none:
            return Resolved(kinematics: slide.kinematics, action: action, progress: progress, events: wish.events)
        }
    }

    static func phase(after slide: Slide, room: Room) -> Phase {
        if slide.vertical == .negative || Probe.supported(place: slide.place, room: room) {
            return .grounded
        }
        if slide.across == .negative {
            return .wall(.left)
        }
        if slide.across == .positive {
            return .wall(.right)
        }
        return .air
    }

    static func refilled(_ phase: Phase, previous: Phase, charges: DashCharges) -> DashCharges {
        if phase == .grounded && previous != .grounded {
            return .full
        }
        return charges
    }

    static func respawn(_ start: SummitState, wish: WishResult, progress: Progress) -> Resolved {
        let cell = progress.checkpoint
        let place = Place(x: cell.x * MotionPolicy.scale, y: cell.y * MotionPolicy.scale)
        let kinematics = Kinematics(place: place, velocity: .still)
        let action = Action(facing: wish.action.facing, phase: .grounded, dashTicks: 0, charges: .full)
        let events = wish.events + [.fell, .returned]
        return Resolved(kinematics: kinematics, action: action, progress: progress, events: events)
    }

    static func arrive(_ slide: Slide, action: Action, progress: Progress, events: [StepEvent]) -> Resolved {
        let stopped = Kinematics(place: slide.place, velocity: .still)
        let resting = Action(facing: action.facing, phase: .grounded, dashTicks: 0, charges: action.charges)
        return Resolved(kinematics: stopped, action: resting, progress: progress.summited(), events: events)
    }
}
