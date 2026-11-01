import NeNeSummitCore

enum Board {
    static func frame(_ state: SummitState, attendance: Attendance, note: String) -> [[Glyph]] {
        var sheet = Sheet.blank()
        Chrome.bands(&sheet)
        FieldView.paint(&sheet, state: state)
        Chrome.frame(&sheet)
        header(&sheet, state: state)
        HudPane.paint(&sheet, state: state, attendance: attendance, note: note)
        footer(&sheet)
        return sheet.lines
    }

    static func header(_ sheet: inout Sheet, state: SummitState) {
        let title = state.progress.expedition == .summited ? "CREST" : "NENE SUMMIT"
        sheet.stamp(0, 1, Chrome.post, .hint)
        sheet.stamp(0, 3, title, .banner)
        let room = state.room.title()
        sheet.stamp(0, Stage.columns - room.count - 2, room, .hint)
    }

    static func footer(_ sheet: inout Sheet) {
        let keys = "q QUIT   m MODE   a d MOVE   space JUMP   k DASH"
        sheet.stamp(Stage.rows - 1, 1, keys, .hint)
    }
}
