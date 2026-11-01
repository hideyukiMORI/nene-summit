import NeNeSummitCore

enum HudPane {
    static func paint(_ sheet: inout Sheet, state: SummitState, attendance: Attendance, note: String) {
        let column = Stage.hudColumn
        sheet.stamp(Stage.fieldRow, column, "STATUS", .banner)
        sheet.stamp(Stage.fieldRow + 2, column, "DASH", .quiet)
        dash(&sheet, state: state)
        sheet.stamp(Stage.fieldRow + 3, column, "MODE  " + mode(attendance), .quiet)
        sheet.stamp(Stage.fieldRow + 4, column, "ROOM  " + state.room.title(), .quiet)
        sheet.stamp(Stage.fieldRow + 5, column, "VOICE " + voice(note), .mark)
        sheet.stamp(Stage.fieldRow + 7, column, "COMMS", .banner)
        noteRows(&sheet, note: note)
    }

    static func dash(_ sheet: inout Sheet, state: SummitState) {
        let tone: Glyph.Tone = state.action.charges.remaining > 0 ? .crest : .stone
        let column = Stage.hudColumn + 6
        sheet.fill(Stage.fieldRow + 2, column, tone)
        sheet.fill(Stage.fieldRow + 2, column + 1, tone)
    }

    static func noteRows(_ sheet: inout Sheet, note: String) {
        let width = Stage.hudWidth - 1
        var row = Stage.fieldRow + 8
        for line in Ink.wrap(note, width: width) {
            if row >= Stage.fieldRow + Stage.fieldCellsY {
                return
            }
            sheet.stamp(row, Stage.hudColumn, line, .quiet)
            row += 1
        }
    }

    static func mode(_ attendance: Attendance) -> String {
        switch attendance {
        case .automatic:
            return "AUTO"
        case .manual:
            return "PLAY"
        }
    }

    static func voice(_ note: String) -> String {
        if note.isEmpty {
            return "--"
        }
        return String(note.prefix { $0 != " " })
    }
}
