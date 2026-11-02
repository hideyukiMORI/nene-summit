enum Probe {
    struct Span {
        let x0: Int
        let y0: Int
        let x1: Int
        let y1: Int
    }

    struct Found {
        var summit = false
        var exit = false
        var spring = false
        var gleam: CellPoint?
        var coin: CellPoint?
        var refill = false
        var checkpoint: CellPoint?
    }

    static func hitsSolid(place: Place, room: Room) -> Bool {
        hitsSolid(place: place, matter: Matter(room: room, tick: 0))
    }

    static func hitsSolid(place: Place, matter: Matter) -> Bool {
        if place.x < 0 || place.y < 0 {
            return true
        }
        let span = covering(place)
        var y = span.y0
        while y <= span.y1 {
            var x = span.x0
            while x <= span.x1 {
                if matter.kind(x: x, y: y) == .solid {
                    return true
                }
                x += 1
            }
            y += 1
        }
        return false
    }

    static func supported(place: Place, matter: Matter) -> Bool {
        hitsSolid(place: place.moved(x: 0, y: -1), matter: matter)
    }

    static func contact(place: Place, matter: Matter) -> Contact {
        if place.x < 0 || place.y < 0 {
            return .none
        }
        let span = covering(place)
        var found = Found()
        var y = span.y0
        while y <= span.y1 {
            var x = span.x0
            while x <= span.x1 {
                if matter.crushes(x: x, y: y) || note(matter.kind(x: x, y: y), x: x, y: y, found: &found) {
                    return .spike
                }
                x += 1
            }
            y += 1
        }
        return ranked(found)
    }

    static func ranked(_ found: Found) -> Contact {
        if found.summit {
            return .summit
        }
        if found.exit {
            return .exit
        }
        if found.spring {
            return .spring
        }
        if let cell = found.gleam {
            return .gleam(cell)
        }
        if let cell = found.coin {
            return .coin(cell)
        }
        if found.refill {
            return .refill
        }
        if let cell = found.checkpoint {
            return .checkpoint(cell)
        }
        return .none
    }

    static func covering(_ place: Place) -> Span {
        let x0 = place.x / MotionPolicy.scale
        let y0 = place.y / MotionPolicy.scale
        let x1 = (place.x + MotionPolicy.bodyWidth - 1) / MotionPolicy.scale
        let y1 = (place.y + MotionPolicy.bodyHeight - 1) / MotionPolicy.scale
        return Span(x0: x0, y0: y0, x1: x1, y1: y1)
    }

    private static func note(_ kind: CellKind, x: Int, y: Int, found: inout Found) -> Bool {
        switch kind {
        case .spike:
            return true
        case .summit:
            found.summit = true
        case .exit:
            found.exit = true
        case .checkpoint:
            found.checkpoint = CellPoint(x: x, y: y)
        case .spring:
            found.spring = true
        case .gleam:
            found.gleam = CellPoint(x: x, y: y)
        case .coin:
            found.coin = CellPoint(x: x, y: y)
        case .refill:
            found.refill = true
        case .crumble, .open, .solid:
            break
        }
        return false
    }
}
