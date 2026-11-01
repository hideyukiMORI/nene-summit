enum Springboard {
    static func launch(_ slide: Slide, action: Action, progress: Progress, events: [StepEvent]) -> Resolved {
        let velocity = Velocity(x: slide.velocity.x, y: MotionPolicy.springSpeed)
        let kinematics = Kinematics(place: slide.place, velocity: velocity)
        let risen = Action(facing: action.facing, phase: .air, dashTicks: 0, charges: .full)
        return Resolved(kinematics: kinematics, action: risen, progress: progress, events: events + [.sprung])
    }
}
