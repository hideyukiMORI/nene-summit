import NeNeSummitCore

enum FieldView {
    static func paint(_ sheet: inout Sheet, state: SummitState) {
        let origin = Viewport.origin(
            width: state.room.width, height: state.room.height, portrait: state.portrait())
        var viewY = 0
        while viewY < Stage.fieldCellsY {
            paintRow(&sheet, state: state, origin: origin, viewY: viewY)
            viewY += 1
        }
    }

    static func paintRow(_ sheet: inout Sheet, state: SummitState, origin: CellPoint, viewY: Int) {
        let roomY = origin.y + Stage.fieldCellsY - 1 - viewY
        let screenY = Stage.fieldRow + viewY
        var viewX = 0
        while viewX < Stage.fieldCellsX {
            let tone = tone(state, x: origin.x + viewX, y: roomY)
            block(&sheet, row: screenY, viewX: viewX, tone: tone)
            viewX += 1
        }
    }

    static func tone(_ state: SummitState, x: Int, y: Int) -> Glyph.Tone {
        if y < 0 || y >= state.room.height || x < 0 || x >= state.room.width {
            return .sky
        }
        let here = state.portrait()
        if here.x == x && here.y == y {
            return .climber
        }
        switch state.room.kind(x: x, y: y) {
        case .open:
            return .sky
        case .solid:
            return .stone
        case .spike:
            return .hazard
        case .checkpoint:
            return .flag
        case .summit:
            return .crest
        }
    }

    static func block(_ sheet: inout Sheet, row: Int, viewX: Int, tone: Glyph.Tone) {
        let column = Stage.fieldColumn + viewX * Stage.cellSpan
        var span = 0
        while span < Stage.cellSpan {
            sheet.fill(row, column + span, tone)
            span += 1
        }
    }
}
