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
        kept(gleams.taking(cell))
    }

    func gatheringCoin(_ cell: CellPoint) -> Progress {
        kept(gleams.takingCoin(cell))
    }

    private func kept(_ next: GleamBag) -> Progress {
        if next == gleams {
            return self
        }
        return Progress(checkpoint: checkpoint, expedition: expedition, tick: tick, gleams: next)
    }
}
