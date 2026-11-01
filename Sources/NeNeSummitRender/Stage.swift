enum Stage {
    static let columns = 80
    static let rows = 24
    static let fieldColumn = 1
    static let fieldRow = 2
    static let fieldCellsX = 26
    static let fieldCellsY = 20
    static let cellSpan = 2
    static let hudColumn = 55
    static let hudWidth = 25

    static var fieldWidth: Int {
        fieldCellsX * cellSpan
    }
}
