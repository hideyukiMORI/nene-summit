struct Tick: Equatable, Sendable {
    let count: Int

    private init(count: Int) {
        self.count = count
    }

    static let zero = Tick(count: 0)

    func advanced() -> Tick {
        Tick(count: count + 1)
    }
}
