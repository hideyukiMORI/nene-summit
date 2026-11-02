enum DeckField {
    static func covers(_ room: Room, x: Int, y: Int, tick: Int) -> Bool {
        for deck in room.decks {
            if deck.covers(x, y, tick: tick) {
                return true
            }
        }
        return false
    }

    static func ride(_ place: Place, room: Room, from previous: Int, to tick: Int) -> Place {
        guard let deck = under(room, place: place, tick: previous) else {
            return place
        }
        let moved = deck.cellShift(at: tick) - deck.cellShift(at: previous)
        switch deck.axis {
        case .horizontal:
            return place.moved(x: moved * MotionPolicy.scale, y: 0)
        case .vertical:
            return place.moved(x: 0, y: moved * MotionPolicy.scale)
        }
    }

    static func under(_ room: Room, place: Place, tick: Int) -> Deck? {
        let span = Probe.covering(place)
        var x = span.x0
        while x <= span.x1 {
            for deck in room.decks {
                if !deck.pace.harms() && deck.covers(x, span.y0 - 1, tick: tick) {
                    return deck
                }
            }
            x += 1
        }
        return nil
    }

    static func crushes(_ room: Room, x: Int, y: Int, tick: Int) -> Bool {
        for deck in room.decks {
            if deck.pace.harms() && deck.covers(x, y, tick: tick) {
                return true
            }
        }
        return false
    }
}
