import NeNeSummitCore

enum Viewport {
    static func origin(width: Int, height: Int, portrait: CellPoint) -> CellPoint {
        CellPoint(
            x: place(portrait.x, span: Stage.fieldCellsX, limit: width),
            y: place(portrait.y, span: Stage.fieldCellsY, limit: height)
        )
    }

    static func place(_ focus: Int, span: Int, limit: Int) -> Int {
        if limit <= span {
            return 0
        }
        let raw = focus - span / 2
        if raw < 0 {
            return 0
        }
        let cap = limit - span
        if raw > cap {
            return cap
        }
        return raw
    }
}
