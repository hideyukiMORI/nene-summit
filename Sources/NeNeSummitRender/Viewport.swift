import NeNeSummitCore

enum Viewport {
    static func origin(width: Int, height: Int, portrait: CellPoint) -> CellPoint {
        CellPoint(
            x: place(portrait.x, span: Stage.fieldCellsX, limit: width, ahead: true),
            y: place(portrait.y, span: Stage.fieldCellsY, limit: height, ahead: false)
        )
    }

    static func place(_ focus: Int, span: Int, limit: Int, ahead: Bool) -> Int {
        if limit <= span {
            return 0
        }
        let margin = ahead ? span / 3 : span / 2
        let raw = focus - margin
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
