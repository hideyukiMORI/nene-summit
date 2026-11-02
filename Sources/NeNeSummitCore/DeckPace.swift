struct DeckPace: Equatable, Sendable {
    let axis: Axis
    let reach: Int
    let travel: Int
    let dwell: Int

    static func ferry() -> DeckPace {
        DeckPace(
            axis: .horizontal,
            reach: MotionPolicy.deckReach,
            travel: MotionPolicy.deckTravel,
            dwell: MotionPolicy.deckDwell
        )
    }

    static func hoist() -> DeckPace {
        DeckPace(
            axis: .vertical,
            reach: MotionPolicy.deckReach,
            travel: MotionPolicy.deckTravel,
            dwell: MotionPolicy.deckDwell
        )
    }

    static func haste() -> DeckPace {
        DeckPace(axis: .horizontal, reach: MotionPolicy.deckReach, travel: 16, dwell: 8)
    }

    static func drift() -> DeckPace {
        DeckPace(axis: .horizontal, reach: 6, travel: 72, dwell: 12)
    }

    static func west() -> DeckPace {
        DeckPace(axis: .horizontal, reach: -MotionPolicy.deckReach, travel: 24, dwell: 8)
    }

    static func drop() -> DeckPace {
        DeckPace(axis: .vertical, reach: -MotionPolicy.dropReach, travel: 18, dwell: 10)
    }

    func harms() -> Bool {
        axis == .vertical && reach < 0
    }
}
