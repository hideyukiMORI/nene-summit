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
                let crush = state.room.crushing(x: x, y: y, tick: state.elapsed())
                if (deck || crush) && (here.x != x || here.y != y) {
                    let mark = crush ? crusher : snow
                    blot(&sheet, origin: origin, at: CellPoint(x: x, y: y), mark: mark)
                }
                x += 1
            }
            y += 1
        }
    }

    static let snow = CellStamp(text: CellMark.stone(capped: true), tone: .stone)
    static let crusher = CellStamp(text: CellMark.crusher, tone: .hazard)

    static func blot(_ sheet: inout Sheet, origin: CellPoint, at: CellPoint, mark: CellStamp) {
        let viewX = at.x - origin.x
        let viewY = origin.y + Stage.fieldCellsY - 1 - at.y
        if viewX < 0 || viewX >= Stage.fieldCellsX || viewY < 0 || viewY >= Stage.fieldCellsY {
            return
        }
        block(&sheet, row: Stage.fieldRow + viewY, viewX: viewX, stamp: mark)
    }

    static func paintRow(_ sheet: inout Sheet, state: SummitState, origin: CellPoint, viewY: Int) {
        let roomY = origin.y + Stage.fieldCellsY - 1 - viewY
        let screenY = Stage.fieldRow + viewY
        var viewX = 0
        while viewX < Stage.fieldCellsX {
            let stamp = mark(state, x: origin.x + viewX, y: roomY)
            block(&sheet, row: screenY, viewX: viewX, stamp: stamp)
            viewX += 1
        }
    }

    static func mark(_ state: SummitState, x: Int, y: Int) -> CellStamp {
        if y < 0 || y >= state.room.height || x < 0 || x >= state.room.width {
            return CellStamp(text: CellMark.sky, tone: .sky)
        }
        let here = state.portrait()
        if here.x == x && here.y == y {
            return CellStamp(text: CellMark.climber(state.action.phase, dashing: state.dashing()), tone: .climber)
        }
        if state.gathered(x: x, y: y) {
            return CellStamp(text: CellMark.sky, tone: .sky)
        }
        return face(state, x: x, y: y)
    }

    static func face(_ state: SummitState, x: Int, y: Int) -> CellStamp {
        switch state.room.kind(x: x, y: y) {
        case .open, .solid, .spike, .checkpoint, .summit, .exit:
            return ground(state, x: x, y: y)
        case .spring, .gleam, .coin, .crumble, .refill:
            return prize(state, x: x, y: y)
        }
    }

    static func ground(_ state: SummitState, x: Int, y: Int) -> CellStamp {
        switch state.room.kind(x: x, y: y) {
        case .solid:
            return CellStamp(text: CellMark.stone(capped: capped(state, x: x, y: y)), tone: .stone)
        case .spike:
            return CellStamp(text: CellMark.spike, tone: .hazard)
        case .checkpoint:
            return CellStamp(text: CellMark.flag, tone: .flag)
        case .summit:
            return CellStamp(text: crest(state, x: x, y: y), tone: .crest)
        case .exit:
            return CellStamp(text: CellMark.exit, tone: .mist)
        default:
            return CellStamp(text: CellMark.sky, tone: .sky)
        }
    }

    static func prize(_ state: SummitState, x: Int, y: Int) -> CellStamp {
        switch state.room.kind(x: x, y: y) {
        case .spring:
            return CellStamp(text: CellMark.spring, tone: .spring)
        case .gleam:
            return CellStamp(text: CellMark.berry, tone: .gleam)
        case .coin:
            return CellStamp(text: CellMark.coin, tone: .coin)
        case .crumble:
            return shelf(state, x: x, y: y)
        case .refill:
            return CellStamp(text: CellMark.refill, tone: .flag)
        default:
            return CellStamp(text: CellMark.sky, tone: .sky)
        }
    }

    static func shelf(_ state: SummitState, x: Int, y: Int) -> CellStamp {
        if state.room.firm(x: x, y: y, tick: state.elapsed()) {
            return CellStamp(text: CellMark.crumble, tone: .mist)
        }
        return CellStamp(text: CellMark.sky, tone: .sky)
    }

    static func crest(_ state: SummitState, x: Int, y: Int) -> String {
        if pennant(state, x: x, y: y) {
            return CellMark.crest
        }
        return "--"
    }

    static func pennant(_ state: SummitState, x: Int, y: Int) -> Bool {
        let start = bound(state, x: x, y: y, step: -1)
        let end = bound(state, x: x, y: y, step: 1)
        let count = end - start + 1
        return x == start + count / 2
    }

    static func bound(_ state: SummitState, x: Int, y: Int, step: Int) -> Int {
        var cursor = x
        while summit(state, x: cursor + step, y: y) {
            cursor += step
        }
        return cursor
    }

    static func summit(_ state: SummitState, x: Int, y: Int) -> Bool {
        if x < 0 || y < 0 || x >= state.room.width || y >= state.room.height {
            return false
        }
        return state.room.kind(x: x, y: y) == .summit
    }

    static func capped(_ state: SummitState, x: Int, y: Int) -> Bool {
        let above = y + 1
        if above >= state.room.height {
            return true
        }
        return state.room.kind(x: x, y: above) != .solid
    }

    static func block(_ sheet: inout Sheet, row: Int, viewX: Int, stamp: CellStamp) {
        let column = Stage.fieldColumn + viewX * Stage.cellSpan
        if stamp.tone == .sky {
            var span = 0
            while span < Stage.cellSpan {
                sheet.fill(row, column + span, .sky)
                span += 1
            }
            return
        }
        sheet.stamp(row, column, stamp.text, stamp.tone)
    }
}
