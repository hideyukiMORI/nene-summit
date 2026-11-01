public struct Progress: Equatable, Sendable {
    let checkpoint: CellPoint
    public let expedition: Expedition
    let tick: Tick

    func ticked() -> Progress {
        Progress(checkpoint: checkpoint, expedition: expedition, tick: tick.advanced())
    }

    func withCheckpoint(_ checkpoint: CellPoint) -> Progress {
        Progress(checkpoint: checkpoint, expedition: expedition, tick: tick)
    }

    func summited() -> Progress {
        Progress(checkpoint: checkpoint, expedition: .summited, tick: tick)
    }
}
