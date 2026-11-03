import NeNeSummitCore

enum HudPane {
    struct Heard {
        let name: String
        let face: String
        let line: String
    }

    struct Slip {
        let attendance: Attendance
        let note: String
    }

    struct Field {
        let label: String
        let value: String
    }

    struct Voice {
        let text: String
        let row: Int
        let latest: Bool
    }

    static func paint(_ sheet: inout Sheet, state: SummitState, slip: Slip) {
        let top = Stage.fieldRow
        sheet.stamp(top, Stage.hudColumn, "[ STATUS ]", .banner)
        field(&sheet, row: top + 1, field: Field(label: "MODE", value: mode(slip.attendance)))
        field(&sheet, row: top + 2, field: Field(label: "ROOM", value: state.room.title()))
        hold(&sheet, state: state, row: top + 3)
        dash(&sheet, state: state, row: top + 4)
        rule(&sheet, row: top + 5, title: "[ CLIMB ]")
        field(&sheet, row: top + 6, field: Field(label: "BERRY", value: number(state.berries())))
        field(&sheet, row: top + 7, field: Field(label: "COIN", value: number(state.coins())))
        rule(&sheet, row: top + 8, title: "[ COMMS ]")
        comms(&sheet, note: slip.note, row: top + 9)
    }

    static func field(_ sheet: inout Sheet, row: Int, field: Field) {
        sheet.stamp(row, Stage.hudColumn, pad(field.label), .quiet)
        sheet.stamp(row, Stage.hudColumn + 7, field.value, .mark)
    }

    static func hold(_ sheet: inout Sheet, state: SummitState, row: Int) {
        let phase = hold(state.action.phase)
        sheet.stamp(row, Stage.hudColumn, pad("HOLD"), .quiet)
        sheet.stamp(row, Stage.hudColumn + 7, phase, .mark)
        let pose = CellMark.climber(state.action.phase, dashing: state.dashing())
        sheet.stamp(row, Stage.hudColumn + 8 + phase.count, pose, .climber)
    }

    static func dash(_ sheet: inout Sheet, state: SummitState, row: Int) {
        let ready = state.action.charges.remaining > 0
        let tone: Glyph.Tone = ready ? .crest : .stone
        sheet.stamp(row, Stage.hudColumn, pad("DASH"), .quiet)
        sheet.stamp(row, Stage.hudColumn + 7, "++", tone)
        let word = ready ? "READY" : "USED"
        let ink: Glyph.Tone = ready ? .mark : .quiet
        sheet.stamp(row, Stage.hudColumn + 10, word, ink)
    }

    static func rule(_ sheet: inout Sheet, row: Int, title: String) {
        let width = Stage.columns - (Stage.hudColumn - 1)
        let head = "\u{251C}" + title
        let bars = max(width - head.count - 1, 0)
        let text = head + String(repeating: Chrome.bar, count: bars) + "\u{2524}"
        sheet.stamp(row, Stage.hudColumn - 1, text, .quiet)
    }

    static func comms(_ sheet: inout Sheet, note: String, row: Int) {
        let lines = records(note)
        var index = 0
        var line = row
        while index < lines.count {
            if line + 1 >= Stage.fieldRow + Stage.fieldCellsY {
                return
            }
            let voice = Voice(text: lines[index], row: line, latest: index == lines.count - 1)
            wrote(&sheet, voice: voice)
            line += 2
            index += 1
        }
    }

    static func wrote(_ sheet: inout Sheet, voice: Voice) {
        let heard = heard(voice.text)
        let who = heard.face.isEmpty ? heard.name : heard.name + " " + heard.face
        let name: Glyph.Tone = voice.latest ? .mark : .quiet
        let words: Glyph.Tone = voice.latest ? .hint : .quiet
        sheet.stamp(voice.row, Stage.hudColumn, clip(who), name)
        sheet.stamp(voice.row + 1, Stage.hudColumn, clip(heard.line), words)
    }

    static func records(_ note: String) -> [String] {
        let parts = note.split(separator: "\n", omittingEmptySubsequences: true).map(String.init)
        if !parts.isEmpty {
            return parts
        }
        if note.isEmpty {
            return []
        }
        return [note]
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

    static func clip(_ text: String) -> String {
        let width = Stage.hudWidth - 1
        if text.count <= width {
            return text
        }
        return String(text.prefix(width))
    }

    static func pad(_ label: String) -> String {
        label + String(repeating: " ", count: max(6 - label.count, 0))
    }

    static func number(_ value: Int) -> String {
        if value < 10 {
            return "0" + String(value)
        }
        return String(value)
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
