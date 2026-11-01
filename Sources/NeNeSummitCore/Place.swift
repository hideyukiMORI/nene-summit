struct Place: Equatable, Sendable {
    let x: Int
    let y: Int

    func moved(x dx: Int, y dy: Int) -> Place {
        Place(x: x + dx, y: y + dy)
    }
}
