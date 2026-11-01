public struct GleamBag: Equatable, Sendable {
    public let cells: [CellPoint]
    public let kept: Int

    public init(cells: [CellPoint], kept: Int) {
        self.cells = cells
        self.kept = kept
    }

    public static let empty = GleamBag(cells: [], kept: 0)

    public func count() -> Int {
        kept + cells.count
    }

    public func holds(x: Int, y: Int) -> Bool {
        cells.contains(CellPoint(x: x, y: y))
    }

    public func taking(_ cell: CellPoint) -> GleamBag {
        if cells.contains(cell) {
            return self
        }
        return GleamBag(cells: cells + [cell], kept: kept)
    }

    public func carried() -> GleamBag {
        GleamBag(cells: [], kept: count())
    }
}
