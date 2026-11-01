struct SummitState: Equatable, Sendable {
    let room: Room
    let position: CellPoint
    let facing: Direction
    let tick: Tick

    private init(room: Room, position: CellPoint, facing: Direction, tick: Tick) {
        self.room = room
        self.position = position
        self.facing = facing
        self.tick = tick
    }

    static func begin(in room: Room) -> SummitState {
        SummitState(room: room, position: room.spawn, facing: .up, tick: .zero)
    }

    func advance(input: Input) -> StepOutcome {
        let next = SummitState(
            room: room,
            position: position,
            facing: facing(after: input),
            tick: tick.advanced()
        )
        return StepOutcome(state: next, events: events(for: input))
    }

    private func facing(after input: Input) -> Direction {
        switch input {
        case .idle:
            return facing
        case .face(let direction):
            return direction
        }
    }

    private func events(for input: Input) -> [StepEvent] {
        switch input {
        case .idle:
            return [.tick]
        case .face(let direction):
            return [.tick, .faced(direction)]
        }
    }
}
