public struct GleamBag: Equatable, Sendable {
    public let berries: [CellPoint]
    public let coins: [CellPoint]
    public let keptBerries: Int
    public let keptCoins: Int

    public init(berries: [CellPoint], coins: [CellPoint], keptBerries: Int, keptCoins: Int) {
        self.berries = berries
        self.coins = coins
        self.keptBerries = keptBerries
        self.keptCoins = keptCoins
    }

    public static let empty = GleamBag(berries: [], coins: [], keptBerries: 0, keptCoins: 0)

    public func count() -> Int {
        berryCount() + coinCount()
    }

    public func berryCount() -> Int {
        keptBerries + berries.count
    }

    public func coinCount() -> Int {
        keptCoins + coins.count
    }

    public func holds(x: Int, y: Int) -> Bool {
        let cell = CellPoint(x: x, y: y)
        return berries.contains(cell) || coins.contains(cell)
    }

    public func taking(_ cell: CellPoint) -> GleamBag {
        if holds(x: cell.x, y: cell.y) {
            return self
        }
        return GleamBag(
            berries: berries + [cell], coins: coins, keptBerries: keptBerries, keptCoins: keptCoins)
    }

    public func takingCoin(_ cell: CellPoint) -> GleamBag {
        if holds(x: cell.x, y: cell.y) {
            return self
        }
        return GleamBag(
            berries: berries, coins: coins + [cell], keptBerries: keptBerries, keptCoins: keptCoins)
    }

    public func carried() -> GleamBag {
        GleamBag(berries: [], coins: [], keptBerries: berryCount(), keptCoins: coinCount())
    }
}
