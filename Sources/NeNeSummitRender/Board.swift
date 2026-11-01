import NeNeSummitCore

enum Board {
    static func frame(_ state: SummitState, attendance: Attendance, note: String) -> [[Glyph]] {
        var sheet = Sheet.blank()
        FieldView.paint(&sheet, state: state)
        header(&sheet, state: state)
        HudPane.paint(&sheet, state: state, attendance: attendance, note: note)
        footer(&sheet)
        return sheet.lines
    }

    static func header(_ sheet: inout Sheet, state: SummitState) {
        let title = state.progress.expedition == .summited ? "CREST" : "NENE SUMMIT"
        sheet.stamp(0, 1, title, .banner)
    }

    static func footer(_ sheet: inout Sheet) {
        let keys = "q QUIT   m MODE   a d MOVE   space JUMP   k DASH"
        sheet.stamp(Stage.rows - 1, 1, keys, .quiet)
    }
}
