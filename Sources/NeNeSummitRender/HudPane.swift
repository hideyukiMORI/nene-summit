import NeNeSummitCore

enum HudPane {
    struct Heard {
        let name: String
        let face: String
        let line: String
    }

    static func paint(_ sheet: inout Sheet, state: SummitState, attendance: Attendance, note: String) {
        let top = Stage.fieldRow
        sheet.stamp(top, Stage.hudColumn, "STATUS", .banner)
        pair(&sheet, row: top + 2, label: "MODE", value: mode(attendance))
        pair(&sheet, row: top + 3, label: "ROOM", value: state.room.title())
        pair(&sheet, row: top + 4, label: "HOLD", value: hold(state.action.phase))
        pair(&sheet, row: top + 5, label: "ALT", value: String(state.portrait().y))
        dash(&sheet, state: state, row: top + 6)
        pair(&sheet, row: top + 7, label: "GLEAM", value: String(state.finds()))
        sheet.stamp(top + 9, Stage.hudColumn, "--------", .quiet)
        sheet.stamp(top + 10, Stage.hudColumn, "COMMS", .banner)
        speaker(&sheet, note: note, row: top + 11)
        noteRows(&sheet, note: note, row: top + 12)
    }

    static func pair(_ sheet: inout Sheet, row: Int, label: String, value: String) {
        sheet.stamp(row, Stage.hudColumn, pad(label), .quiet)
        sheet.stamp(row, Stage.hudColumn + 6, value, .mark)
    }

    static func dash(_ sheet: inout Sheet, state: SummitState, row: Int) {
        let ready = state.action.charges.remaining > 0
        let tone: Glyph.Tone = ready ? .crest : .stone
        let column = Stage.hudColumn
        sheet.stamp(row, column, pad("DASH"), .quiet)
        sheet.fill(row, column + 6, tone)
        sheet.fill(row, column + 7, tone)
        sheet.stamp(row, column + 9, ready ? "READY" : "USED", ready ? .mark : .quiet)
    }

    static func speaker(_ sheet: inout Sheet, note: String, row: Int) {
        let heard = heard(note)
        sheet.stamp(row, Stage.hudColumn, heard.name, .mark)
        if heard.face.isEmpty {
            return
        }
        sheet.stamp(row, Stage.hudColumn + heard.name.count + 1, heard.face, .banner)
    }

    static func noteRows(_ sheet: inout Sheet, note: String, row: Int) {
        let width = Stage.hudWidth - 1
        var line = row
        for text in Ink.wrap(heard(note).line, width: width) {
            if line >= Stage.fieldRow + Stage.fieldCellsY {
                return
            }
            sheet.stamp(line, Stage.hudColumn, text, .quiet)
            line += 1
        }
    }

    static func heard(_ note: String) -> Heard {
        let parts = note.split(separator: " ", maxSplits: 2, omittingEmptySubsequences: true)
        if parts.isEmpty {
            return Heard(name: "--", face: "", line: "")
        }
        let name = String(parts[0])
        if parts.count < 3 {
            let rest = parts.count == 2 ? String(parts[1]) : ""
            return Heard(name: name, face: "", line: rest)
        }
        return Heard(name: name, face: String(parts[1]), line: String(parts[2]))
    }

    static func pad(_ label: String) -> String {
        label + String(repeating: " ", count: max(6 - label.count, 0))
    }

    static func mode(_ attendance: Attendance) -> String {
        switch attendance {
        case .automatic:
            return "AUTO"
        case .manual:
            return "PLAY"
        }
    }

    static func hold(_ phase: Phase) -> String {
        switch phase {
        case .grounded:
            return "GROUND"
        case .air:
            return "AIR"
        case .wall(.left):
            return "WALL L"
        case .wall(.right):
            return "WALL R"
        case .wall(.up), .wall(.down):
            return "WALL"
        }
    }
}
