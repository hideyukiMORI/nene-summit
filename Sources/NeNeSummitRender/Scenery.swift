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
        case cloud(String)
        case hem(String)
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
            return puff(sight)
        }
        if ridge(viewX: sight.viewX, viewY: sight.viewY, origin: sight.origin) {
            let far = sight.origin.x / 3 + sight.viewX
            return .peak(CellMark.slope(far))
        }
        if foot(viewX: sight.viewX, viewY: sight.viewY, origin: sight.origin) {
            return .peak("\\\\")
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
        case .cloud(let text):
            return CellStamp(text: text, tone: .cloud)
        case .hem(let text):
            return CellStamp(text: text, tone: .mist)
        case .peak(let text):
            return CellStamp(text: text, tone: .ridge)
        case .drift:
            return CellStamp(text: CellMark.cloud, tone: .mist)
        case .frost:
            return CellStamp(text: ", ", tone: .spark)
        case .spark:
            return CellStamp(text: CellMark.spark, tone: .spark)
        }
    }

    static func puff(_ sight: Sight) -> Layer {
        let local = positive(sight.origin.x / 5 + sight.viewX) % 12
        let text = cloudText(viewY: sight.viewY, local: local)
        if sight.viewY == 3 {
            return .hem(text)
        }
        return .cloud(text)
    }

    static func cloudText(viewY: Int, local: Int) -> String {
        if viewY == 1 {
            return cap(local)
        }
        if viewY == 2 {
            return bellyText(local)
        }
        return hem(local)
    }

    static func cap(_ local: Int) -> String {
        if local == 2 {
            return ".'"
        }
        return "- "
    }

    static func bellyText(_ local: Int) -> String {
        if local == 1 {
            return ", "
        }
        if local == 2 || local == 6 {
            return "~~"
        }
        if local == 3 {
            return "~ "
        }
        if local == 5 {
            return " -"
        }
        return "' "
    }

    static func hem(_ local: Int) -> String {
        if local == 2 {
            return "_ "
        }
        return "_."
    }

    static func cloud(viewX: Int, viewY: Int, origin: CellPoint) -> Bool {
        if viewY < 1 || viewY > 3 {
            return false
        }
        let local = positive(origin.x / 5 + viewX) % 12
        return band(viewY, local: local)
    }

    static func band(_ viewY: Int, local: Int) -> Bool {
        if viewY == 1 {
            return local == 2 || local == 3
        }
        if viewY == 2 {
            return belly(local)
        }
        return local == 2 || local == 6
    }

    static func belly(_ local: Int) -> Bool {
        if local == 4 || local < 1 || local > 7 {
            return false
        }
        return true
    }

    static func foot(viewX: Int, viewY: Int, origin: CellPoint) -> Bool {
        if viewY != 8 {
            return false
        }
        let far = origin.x / 3 + viewX
        return positive(far) % 8 == 7
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
