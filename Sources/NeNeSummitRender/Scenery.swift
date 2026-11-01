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
                if let layer = layer(sight) {
                    lay(&sheet, viewX: viewX, viewY: viewY, layer: layer)
                }
                viewX += 1
            }
            viewY += 1
        }
    }

    enum Layer {
        case cloud
        case peak(String)
        case drift
        case frost
        case spark
    }

    static func layer(_ sight: Sight) -> Layer? {
        let roomX = sight.origin.x + sight.viewX
        let roomY = sight.origin.y + Stage.fieldCellsY - 1 - sight.viewY
        if !open(sight.state, x: roomX, y: roomY) {
            return nil
        }
        if void(sight.state, x: roomX, y: roomY) {
            return far(sight)
        }
        return near(sight)
    }

    static func far(_ sight: Sight) -> Layer? {
        if cloud(viewX: sight.viewX, viewY: sight.viewY, origin: sight.origin) {
            return .cloud
        }
        if ridge(viewX: sight.viewX, viewY: sight.viewY, origin: sight.origin) {
            let far = sight.origin.x / 3 + sight.viewX
            return .peak(CellMark.slope(far))
        }
        if drift(viewX: sight.viewX, viewY: sight.viewY, origin: sight.origin) {
            return .drift
        }
        if spark(viewX: sight.viewX, viewY: sight.viewY, origin: sight.origin, tick: sight.state.elapsed()) {
            return .spark
        }
        return nil
    }

    static func near(_ sight: Sight) -> Layer? {
        if chip(viewX: sight.viewX, viewY: sight.viewY, origin: sight.origin) {
            return .frost
        }
        if spark(viewX: sight.viewX, viewY: sight.viewY, origin: sight.origin, tick: sight.state.elapsed()) {
            return .spark
        }
        return nil
    }

    static func lay(_ sheet: inout Sheet, viewX: Int, viewY: Int, layer: Layer) {
        FieldView.block(&sheet, row: Stage.fieldRow + viewY, viewX: viewX, stamp: stamp(layer))
    }

    static func stamp(_ layer: Layer) -> CellStamp {
        switch layer {
        case .cloud:
            return CellStamp(text: CellMark.cloud, tone: .cloud)
        case .peak(let text):
            return CellStamp(text: text, tone: .ridge)
        case .drift:
            return CellStamp(text: CellMark.cloud, tone: .mist)
        case .frost:
            return CellStamp(text: CellMark.frost, tone: .spark)
        case .spark:
            return CellStamp(text: CellMark.spark, tone: .spark)
        }
    }

    static func cloud(viewX: Int, viewY: Int, origin: CellPoint) -> Bool {
        if viewY < 1 || viewY > 3 {
            return false
        }
        let far = origin.x / 5 + viewX
        let local = positive(far) % 12
        if viewY == 2 && local < 4 {
            return true
        }
        return viewY == 3 && local > 0 && local < 3
    }

    static func ridge(viewX: Int, viewY: Int, origin: CellPoint) -> Bool {
        let far = origin.x / 3 + viewX
        let local = positive(far) % 8
        let rise = local <= 4 ? local : 8 - local
        let fromBottom = Stage.fieldCellsY - 1 - viewY
        return fromBottom == 11 + rise
    }

    static func drift(viewX: Int, viewY: Int, origin: CellPoint) -> Bool {
        if viewY != 9 {
            return false
        }
        let far = origin.x / 3 + viewX
        return positive(far) % 5 != 0
    }

    static func chip(viewX: Int, viewY: Int, origin: CellPoint) -> Bool {
        let worldX = origin.x + viewX
        let worldY = origin.y + viewY
        return positive(worldX * 5 + worldY * 9) % 67 == 0
    }

    static func spark(viewX: Int, viewY: Int, origin: CellPoint, tick: Int) -> Bool {
        let midX = origin.x / 2 + viewX
        let midY = viewY + tick / 16
        return positive(midX * 13 + midY * 7) % 97 == 0
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

    static func positive(_ value: Int) -> Int {
        if value >= 0 {
            return value
        }
        return -value
    }
}
