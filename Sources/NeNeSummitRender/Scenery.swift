import NeNeSummitCore

enum Scenery {
    struct Sight {
        let state: SummitState
        let origin: CellPoint
        let viewX: Int
        let viewY: Int
    }

    static func paint(_ sheet: inout Sheet, state: SummitState, origin: CellPoint) {
        var viewY = 0
        while viewY < Stage.fieldCellsY {
            var viewX = 0
            while viewX < Stage.fieldCellsX {
                let sight = Sight(state: state, origin: origin, viewX: viewX, viewY: viewY)
                if let tone = tone(sight) {
                    FieldView.block(&sheet, row: Stage.fieldRow + viewY, viewX: viewX, tone: tone)
                }
                viewX += 1
            }
            viewY += 1
        }
    }

    static func tone(_ sight: Sight) -> Glyph.Tone? {
        let roomX = sight.origin.x + sight.viewX
        let roomY = sight.origin.y + Stage.fieldCellsY - 1 - sight.viewY
        if !open(sight.state, x: roomX, y: roomY) {
            return nil
        }
        if void(sight.state, x: roomX, y: roomY) && ridge(viewX: sight.viewX, viewY: sight.viewY, origin: sight.origin)
        {
            return .ridge
        }
        if !void(sight.state, x: roomX, y: roomY) && chip(viewX: sight.viewX, viewY: sight.viewY, origin: sight.origin)
        {
            return .ridge
        }
        if spark(viewX: sight.viewX, viewY: sight.viewY, origin: sight.origin, tick: sight.state.elapsed())
            && twinkle(viewX: sight.viewX, tick: sight.state.elapsed())
        {
            return .spark
        }
        return nil
    }

    static func ridge(viewX: Int, viewY: Int, origin: CellPoint) -> Bool {
        let far = origin.x / 3 + viewX
        if positive(far) % 3 != 0 {
            return false
        }
        let fromBottom = Stage.fieldCellsY - 1 - viewY
        let peak = 13 + positive(far * 5) % 5
        return fromBottom >= 11 && fromBottom <= peak
    }

    static func chip(viewX: Int, viewY: Int, origin: CellPoint) -> Bool {
        let worldX = origin.x + viewX
        let worldY = origin.y + viewY
        return positive(worldX * 5 + worldY * 9) % 29 == 0
    }

    static func spark(viewX: Int, viewY: Int, origin: CellPoint, tick: Int) -> Bool {
        let midX = origin.x / 2 + viewX
        let midY = viewY + tick / 8
        return positive(midX * 13 + midY * 7) % 47 == 0
    }

    static func open(_ state: SummitState, x: Int, y: Int) -> Bool {
        let here = state.portrait()
        if here.x == x && here.y == y {
            return false
        }
        if void(state, x: x, y: y) {
            return true
        }
        if state.gathered(x: x, y: y) {
            return true
        }
        return state.room.kind(x: x, y: y) == .open
    }

    static func void(_ state: SummitState, x: Int, y: Int) -> Bool {
        x < 0 || y < 0 || x >= state.room.width || y >= state.room.height
    }

    static func twinkle(viewX: Int, tick: Int) -> Bool {
        positive(viewX + tick / 6) % 2 == 0
    }

    static func positive(_ value: Int) -> Int {
        if value >= 0 {
            return value
        }
        return -value
    }
}
