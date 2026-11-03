enum Wish {
    struct Draft {
        let facing: Direction
        let velocity: Velocity
        let dashTicks: Int
        let charges: DashCharges
    }

    static func apply(_ state: SummitState, input: Input) -> WishResult {
        let facing = turned(state.action.facing, horizontal: input.horizontal)
        var events: [StepEvent] = []
        if facing != state.action.facing {
            events.append(.faced(facing))
        }
        return shortened(steer(state, input: input, facing: facing, events: events), jump: input.jump)
    }

    static func shortened(_ result: WishResult, jump: Input.Jump) -> WishResult {
        let velocity = result.kinematics.velocity
        if result.action.dashTicks > 0 || jump != .released || velocity.y <= MotionPolicy.jumpCut {
            return result
        }
        let slowed = Velocity(x: velocity.x, y: MotionPolicy.jumpCut)
        let kinematics = Kinematics(place: result.kinematics.place, velocity: slowed)
        return WishResult(kinematics: kinematics, action: result.action, events: result.events)
    }

    static func steer(
        _ state: SummitState,
        input: Input,
        facing: Direction,
        events: [StepEvent]
    ) -> WishResult {
        if let jumped = jump(state.action, velocity: state.kinematics.velocity, input: input) {
            let draft = Draft(facing: facing, velocity: jumped, dashTicks: 0, charges: spentHop(state.action))
            return packed(state, draft: draft, events: events + [.jumped])
        }
        if dashRequested(input, charges: state.action.charges, dashTicks: state.action.dashTicks) {
            let draft = Draft(
                facing: facing,
                velocity: dashVelocity(input, facing: facing),
                dashTicks: MotionPolicy.dashTicks - 1,
                charges: state.action.charges.spent()
            )
            return packed(state, draft: draft, events: events + [.dashed])
        }
        if state.action.dashTicks > 0 {
            let draft = Draft(
                facing: facing,
                velocity: state.kinematics.velocity,
                dashTicks: state.action.dashTicks - 1,
                charges: state.action.charges
            )
            return packed(state, draft: draft, events: events)
        }
        let velocity = coast(state.kinematics.velocity, phase: state.action.phase, input: input)
        let draft = Draft(facing: facing, velocity: velocity, dashTicks: 0, charges: state.action.charges)
        return packed(state, draft: draft, events: events)
    }

    static func packed(_ state: SummitState, draft: Draft, events: [StepEvent]) -> WishResult {
        let kinematics = Kinematics(place: state.kinematics.place, velocity: draft.velocity)
        let action = Action(
            facing: draft.facing,
            phase: state.action.phase,
            dashTicks: draft.dashTicks,
            charges: draft.charges
        )
        return WishResult(kinematics: kinematics, action: action, events: events)
    }

    static func turned(_ facing: Direction, horizontal: Horizontal) -> Direction {
        switch horizontal {
        case .left:
            return .left
        case .right:
            return .right
        case .none:
            return facing
        }
    }

    static func spentHop(_ action: Action) -> DashCharges {
        if action.phase == .air {
            return action.charges.hopped()
        }
        return action.charges
    }

    static func jump(_ action: Action, velocity: Velocity, input: Input) -> Velocity? {
        if input.jump != .pressed {
            return nil
        }
        return risen(action, velocity: velocity, input: input)
    }

    static func risen(_ action: Action, velocity: Velocity, input: Input) -> Velocity? {
        switch action.phase {
        case .grounded:
            return Velocity(x: leapX(velocity.x, horizontal: input.horizontal), y: MotionPolicy.jumpSpeed)
        case .wall(.left):
            return Velocity(x: MotionPolicy.wallJumpX, y: MotionPolicy.jumpSpeed)
        case .wall(.right):
            return Velocity(x: -MotionPolicy.wallJumpX, y: MotionPolicy.jumpSpeed)
        case .air:
            return airJump(action, velocity: velocity, input: input)
        case .wall(.up), .wall(.down):
            return nil
        }
    }

    static func airJump(_ action: Action, velocity: Velocity, input: Input) -> Velocity? {
        if action.charges.hops == 0 {
            return nil
        }
        return Velocity(x: leapX(velocity.x, horizontal: input.horizontal), y: MotionPolicy.jumpSpeed)
    }

    static func leapX(_ vx: Int, horizontal: Horizontal) -> Int {
        if horizontal == .none {
            return vx
        }
        return directed(MotionPolicy.leapSpeed, horizontal: horizontal)
    }

    static func dashRequested(_ input: Input, charges: DashCharges, dashTicks: Int) -> Bool {
        input.dash == .pressed && !charges.isEmpty && dashTicks == 0
    }

    static func dashVelocity(_ input: Input, facing: Direction) -> Velocity {
        let sx = horizontalSign(input.horizontal, facing: facing)
        let sy = verticalSign(input.vertical)
        if sx != 0 && sy != 0 {
            let part = MotionPolicy.dashSpeed * MotionPolicy.diagonalNumerator / MotionPolicy.diagonalDenominator
            return Velocity(x: sx * part, y: sy * part)
        }
        return Velocity(x: sx * MotionPolicy.dashSpeed, y: sy * MotionPolicy.dashSpeed)
    }

    static func horizontalSign(_ horizontal: Horizontal, facing: Direction) -> Int {
        switch horizontal {
        case .left:
            return -1
        case .right:
            return 1
        case .none:
            return facing == .left ? -1 : 1
        }
    }

    static func verticalSign(_ vertical: Vertical) -> Int {
        switch vertical {
        case .up:
            return 1
        case .down:
            return -1
        case .none:
            return 0
        }
    }

    static func coast(_ velocity: Velocity, phase: Phase, input: Input) -> Velocity {
        let target = coastTarget(input.horizontal, phase: phase)
        let accel = phase == .grounded ? MotionPolicy.groundAccel : MotionPolicy.airAccel
        return Velocity(x: approach(velocity.x, target: target, accel: accel), y: falling(velocity.y, phase: phase))
    }

    static func coastTarget(_ horizontal: Horizontal, phase: Phase) -> Int {
        let speed = phase == .grounded ? MotionPolicy.runSpeed : MotionPolicy.leapSpeed
        return directed(speed, horizontal: horizontal)
    }

    static func directed(_ speed: Int, horizontal: Horizontal) -> Int {
        switch horizontal {
        case .left:
            return -speed
        case .right:
            return speed
        case .none:
            return 0
        }
    }

    static func approach(_ value: Int, target: Int, accel: Int) -> Int {
        if value < target {
            return min(value + accel, target)
        }
        if value > target {
            return max(value - accel, target)
        }
        return value
    }

    static func falling(_ vy: Int, phase: Phase) -> Int {
        if phase == .grounded {
            return 0
        }
        let next = vy - MotionPolicy.gravity
        if next < -MotionPolicy.maxFall {
            return -MotionPolicy.maxFall
        }
        return next
    }
}
