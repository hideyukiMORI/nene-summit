struct Deck: Equatable, Sendable {
    let origin: CellPoint
    let size: CellPoint
    let pace: DeckPace

    var axis: Axis { pace.axis }
    var reach: Int { pace.reach }

    func covers(_ x: Int, _ y: Int, tick: Int) -> Bool {
        let shift = cellShift(at: tick)
        let x0 = origin.x + (axis == .horizontal ? shift : 0)
        let y0 = origin.y + (axis == .vertical ? shift : 0)
        let wide = x >= x0 && x < x0 + size.x
        let tall = y >= y0 && y < y0 + size.y
        return wide && tall
    }

    func cellShift(at tick: Int) -> Int {
        let travel = pace.travel
        let dwell = pace.dwell
        let cycle = travel * 2 + dwell
        let phase = tick % cycle
        if phase < travel {
            return phase * reach / travel
        }
        if phase < travel + dwell {
            return reach
        }
        let back = phase - travel - dwell
        return reach - back * reach / travel
    }
}
