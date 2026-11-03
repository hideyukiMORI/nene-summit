import NeNeSummitCore

enum Board {
    static func frame(_ state: SummitState, attendance: Attendance, note: String) -> [[Glyph]] {
        var sheet = Sheet.blank()
        Chrome.bands(&sheet)
        FieldView.paint(&sheet, state: state)
        Chrome.frame(&sheet)
        header(&sheet, state: state, attendance: attendance)
        let slip = HudPane.Slip(attendance: attendance, note: note)
        HudPane.paint(&sheet, state: state, slip: slip)
        footer(&sheet)
        return sheet.lines
    }

    static func header(_ sheet: inout Sheet, state: SummitState, attendance: Attendance) {
        let title = state.progress.expedition == .summited ? "CREST" : "NENE SUMMIT"
        let mode = attendance == .automatic ? "AUTO" : "PLAY"
        let rest = " \u{2502} " + mode + " \u{2502} " + state.room.title()
        sheet.stamp(0, 1, "\u{258C}", .banner)
        sheet.stamp(0, 3, title, .banner)
        sheet.stamp(0, 3 + title.count, rest, .hint)
    }

    static func footer(_ sheet: inout Sheet) {
        let row = Stage.rows - 1
        var column = 1
        sheet.stamp(row, column, "q", .ink)
        column += 1
        sheet.stamp(row, column, " QUIT  ", .hint)
        column += 7
        sheet.stamp(row, column, "m", .ink)
        column += 1
        sheet.stamp(row, column, " MODE  ", .hint)
        column += 7
        sheet.stamp(row, column, "a", .ink)
        column += 1
        sheet.stamp(row, column, " ", .hint)
        column += 1
        sheet.stamp(row, column, "d", .ink)
        column += 1
        sheet.stamp(row, column, " MOVE  ", .hint)
        column += 7
        sheet.stamp(row, column, "space", .ink)
        column += 5
        sheet.stamp(row, column, " JUMP  ", .hint)
        column += 7
        sheet.stamp(row, column, "k", .ink)
        column += 1
        sheet.stamp(row, column, " DASH", .hint)
    }
}
