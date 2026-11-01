public struct Progress: Equatable, Sendable {
    let checkpoint: CellPoint
    public let expedition: Expedition
    let tick: Tick
    let gleams: GleamBag

    func ticked() -> Progress {
        Progress(checkpoint: checkpoint, expedition: expedition, tick: tick.advanced(), gleams: gleams)
    }

    func withCheckpoint(_ checkpoint: CellPoint) -> Progress {
        Progress(checkpoint: checkpoint, expedition: expedition, tick: tick, gleams: gleams)
    }

    func summited() -> Progress {
        Progress(checkpoint: checkpoint, expedition: .summited, tick: tick, gleams: gleams)
    }

    func gathering(_ cell: CellPoint) -> Progress {
        let next = gleams.taking(cell)
        if next == gleams {
            return self
        }
        return Progress(checkpoint: checkpoint, expedition: expedition, tick: tick, gleams: next)
    }
}
