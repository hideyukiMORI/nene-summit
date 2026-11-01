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
        Scenery.paint(&sheet, state: state, origin: origin)
        moving(&sheet, state: state, origin: origin)
    }

    static func moving(_ sheet: inout Sheet, state: SummitState, origin: CellPoint) {
        let here = state.portrait()
        var y = 0
        while y < state.room.height {
            var x = 0
            while x < state.room.width {
                let deck = state.room.moving(x: x, y: y, tick: state.elapsed())
                if deck && (here.x != x || here.y != y) {
                    stamp(&sheet, origin: origin, x: x, y: y)
                }
                x += 1
            }
            y += 1
        }
    }

    static func stamp(_ sheet: inout Sheet, origin: CellPoint, x: Int, y: Int) {
        let viewX = x - origin.x
        let viewY = origin.y + Stage.fieldCellsY - 1 - y
        if viewX < 0 || viewX >= Stage.fieldCellsX || viewY < 0 || viewY >= Stage.fieldCellsY {
            return
        }
        block(&sheet, row: Stage.fieldRow + viewY, viewX: viewX, tone: .stone)
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
        if state.gathered(x: x, y: y) {
            return .sky
        }
        return face(state.room.kind(x: x, y: y))
    }

    static func face(_ kind: CellKind) -> Glyph.Tone {
        switch kind {
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
        case .spring:
            return .spring
        case .gleam:
            return .gleam
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
