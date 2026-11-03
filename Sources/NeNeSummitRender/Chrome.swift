enum Chrome {
    struct Edge {
        let left: Int
        let right: Int
        let top: Int
        let bottom: Int
    }

    static let post = "\u{2502}"
    static let bar = "\u{2500}"
    static let topLeft = "\u{250C}"
    static let topRight = "\u{2510}"
    static let bottomLeft = "\u{2514}"
    static let bottomRight = "\u{2518}"

    static func bands(_ sheet: inout Sheet) {
        band(&sheet, row: 0)
        band(&sheet, row: Stage.rows - 1)
    }

    static func frame(_ sheet: inout Sheet) {
        box(&sheet, fieldEdge())
        box(&sheet, ascentEdge())
        box(&sheet, holdEdge())
        box(&sheet, commsEdge())
    }

    static func band(_ sheet: inout Sheet, row: Int) {
        var column = 0
        while column < Stage.columns {
            sheet.fill(row, column, .veil)
            column += 1
        }
    }

    static func box(_ sheet: inout Sheet, _ edge: Edge) {
        sheet.stamp(edge.top, edge.left, topLeft, .quiet)
        sheet.stamp(edge.top, edge.right, topRight, .quiet)
        line(&sheet, row: edge.top, edge: edge)
        sheet.stamp(edge.bottom, edge.left, bottomLeft, .quiet)
        sheet.stamp(edge.bottom, edge.right, bottomRight, .quiet)
        line(&sheet, row: edge.bottom, edge: edge)
        posts(&sheet, edge: edge)
    }

    static func line(_ sheet: inout Sheet, row: Int, edge: Edge) {
        let span = edge.right - edge.left - 1
        sheet.stamp(row, edge.left + 1, String(repeating: bar, count: span), .quiet)
    }

    static func posts(_ sheet: inout Sheet, edge: Edge) {
        var row = edge.top + 1
        while row < edge.bottom {
            sheet.stamp(row, edge.left, post, .quiet)
            sheet.stamp(row, edge.right, post, .quiet)
            row += 1
        }
    }

    static func fieldEdge() -> Edge {
        Edge(
            left: Stage.fieldColumn - 1,
            right: Stage.fieldColumn + Stage.fieldWidth,
            top: Stage.fieldRow - 1,
            bottom: Stage.fieldRow + Stage.fieldCellsY
        )
    }

    static func ascentEdge() -> Edge {
        Edge(
            left: Stage.hudColumn - 1,
            right: Stage.columns - 1,
            top: Stage.fieldRow - 1,
            bottom: Stage.fieldRow + 9
        )
    }

    static func holdEdge() -> Edge {
        Edge(
            left: Stage.hudColumn - 1,
            right: Stage.columns - 1,
            top: Stage.fieldRow + 10,
            bottom: Stage.fieldRow + 15
        )
    }

    static func commsEdge() -> Edge {
        Edge(
            left: Stage.hudColumn - 1,
            right: Stage.columns - 1,
            top: Stage.fieldRow + 16,
            bottom: Stage.fieldRow + Stage.fieldCellsY
        )
    }
}
