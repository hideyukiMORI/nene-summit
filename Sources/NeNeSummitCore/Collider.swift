enum Collider {
    static func slide(place: Place, velocity: Velocity, room: Room) -> Slide {
        let across = move(place: place, room: room, remaining: velocity.x, axis: .horizontal)
        let risen = move(place: across.place, room: room, remaining: velocity.y, axis: .vertical)
        let vx = across.block == .none ? velocity.x : 0
        let vy = risen.block == .none ? velocity.y : 0
        return Slide(
            place: risen.place,
            velocity: Velocity(x: vx, y: vy),
            across: across.block,
            vertical: risen.block
        )
    }

    static func move(place: Place, room: Room, remaining: Int, axis: Axis) -> AxisMove {
        var current = place
        var left = remaining
        var steps = 0
        while left != 0 && steps < MotionPolicy.maxSubsteps {
            let piece = chunk(left)
            let trial = shifted(current, axis: axis, by: piece)
            if Probe.hitsSolid(place: trial, room: room) {
                return creep(from: current, room: room, axis: axis, toward: piece)
            }
            current = trial
            left -= piece
            steps += 1
        }
        return AxisMove(place: current, block: .none)
    }

    static func chunk(_ remaining: Int) -> Int {
        if remaining > MotionPolicy.substep {
            return MotionPolicy.substep
        }
        if remaining < -MotionPolicy.substep {
            return -MotionPolicy.substep
        }
        return remaining
    }

    static func creep(from place: Place, room: Room, axis: Axis, toward: Int) -> AxisMove {
        let step = toward > 0 ? 1 : -1
        var current = place
        var left = abs(toward)
        while left > 0 {
            let trial = shifted(current, axis: axis, by: step)
            if Probe.hitsSolid(place: trial, room: room) {
                return AxisMove(place: current, block: step > 0 ? .positive : .negative)
            }
            current = trial
            left -= 1
        }
        return AxisMove(place: current, block: .none)
    }

    static func shifted(_ place: Place, axis: Axis, by amount: Int) -> Place {
        switch axis {
        case .horizontal:
            return place.moved(x: amount, y: 0)
        case .vertical:
            return place.moved(x: 0, y: amount)
        }
    }
}
