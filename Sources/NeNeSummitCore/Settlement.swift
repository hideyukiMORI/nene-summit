enum Settlement {
    static func resolve(start: SummitState, wish: WishResult, slide: Slide, progress: Progress) -> Resolved {
        let matter = Matter(room: start.room, tick: progress.tick.count)
        let phase = phase(after: slide, matter: matter)
        let charges = refilled(phase, previous: start.action.phase, charges: wish.action.charges)
        let action = Action(
            facing: wish.action.facing,
            phase: phase,
            dashTicks: wish.action.dashTicks,
            charges: charges
        )
        switch Probe.contact(place: slide.place, matter: matter) {
        case .spike:
            return respawn(start, wish: wish, progress: progress)
        case .summit:
            return arrive(slide, action: action, progress: progress, events: wish.events + [.summited])
        case .spring:
            return Springboard.launch(slide, action: action, progress: progress, events: wish.events)
        case .gleam(let cell):
            return gatherBerry(resting(slide, action: action, progress: progress, events: wish.events), cell: cell)
        case .coin(let cell):
            return gatherCoin(resting(slide, action: action, progress: progress, events: wish.events), cell: cell)
        case .checkpoint(let cell):
            let marked = progress.withCheckpoint(cell)
            return Resolved(kinematics: slide.kinematics, action: action, progress: marked, events: wish.events)
        case .none:
            return Resolved(kinematics: slide.kinematics, action: action, progress: progress, events: wish.events)
        }
    }

    static func phase(after slide: Slide, matter: Matter) -> Phase {
        if slide.vertical == .negative || Probe.supported(place: slide.place, matter: matter) {
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

    static func resting(_ slide: Slide, action: Action, progress: Progress, events: [StepEvent]) -> Resolved {
        Resolved(kinematics: slide.kinematics, action: action, progress: progress, events: events)
    }

    static func gatherBerry(_ resting: Resolved, cell: CellPoint) -> Resolved {
        keep(resting, next: resting.progress.gathering(cell))
    }

    static func gatherCoin(_ resting: Resolved, cell: CellPoint) -> Resolved {
        keep(resting, next: resting.progress.gatheringCoin(cell))
    }

    static func keep(_ resting: Resolved, next: Progress) -> Resolved {
        if next == resting.progress {
            return resting
        }
        return Resolved(
            kinematics: resting.kinematics,
            action: resting.action,
            progress: next,
            events: resting.events + [.gathered]
        )
    }

    static func arrive(_ slide: Slide, action: Action, progress: Progress, events: [StepEvent]) -> Resolved {
        let stopped = Kinematics(place: slide.place, velocity: .still)
        let resting = Action(facing: action.facing, phase: .grounded, dashTicks: 0, charges: action.charges)
        return Resolved(kinematics: stopped, action: resting, progress: progress.summited(), events: events)
    }
}
