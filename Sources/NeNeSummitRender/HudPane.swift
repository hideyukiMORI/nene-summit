import NeNeSummitCore

enum HudPane {
    struct Heard {
        let name: String
        let face: String
        let line: String
    }

    static func paint(_ sheet: inout Sheet, state: SummitState, note: String) {
        ascent(&sheet, state: state)
        hold(&sheet, state: state)
        comms(&sheet, note: note)
    }

    static func ascent(_ sheet: inout Sheet, state: SummitState) {
        let top = Stage.fieldRow
        sheet.stamp(top, Stage.hudColumn, "[ ASCENT ]", .banner)
        var index = 0
        while index <= LanePitch.count {
            rung(&sheet, index: index, here: state.room.place())
            index += 1
        }
    }

    static func rung(_ sheet: inout Sheet, index: Int, here: Int) {
        let tone: Glyph.Tone = index == here ? .mark : .quiet
        let row = Stage.fieldRow + 1 + index
        sheet.stamp(row, Stage.hudColumn, line(index, here: here), tone)
    }

    static func line(_ index: Int, here: Int) -> String {
        let name = index < LanePitch.count ? LanePitch.name(index) : "CREST"
        return mark(index, here: here) + " " + number(index + 1) + " " + name
    }

    static func mark(_ index: Int, here: Int) -> String {
        if index == here {
            return "<"
        }
        if here >= 0 && index < here {
            return "+"
        }
        return "."
    }

    static func number(_ value: Int) -> String {
        if value < 10 {
            return "0" + String(value)
        }
        return String(value)
    }

    static func hold(_ sheet: inout Sheet, state: SummitState) {
        let top = Stage.fieldRow + 11
        sheet.stamp(top, Stage.hudColumn, "[ HOLD ]", .banner)
        let phase = hold(state.action.phase)
        sheet.stamp(top + 1, Stage.hudColumn, phase, .mark)
        let pose = CellMark.climber(state.action.phase, dashing: state.dashing())
        sheet.stamp(top + 1, Stage.hudColumn + phase.count + 1, pose, .climber)
        dash(&sheet, state: state, row: top + 2)
        let berry = "BERRY " + number(state.berries())
        sheet.stamp(top + 3, Stage.hudColumn, berry, .mark)
        sheet.stamp(top + 3, Stage.hudColumn + berry.count + 1, "COIN " + number(state.coins()), .mark)
    }

    static func dash(_ sheet: inout Sheet, state: SummitState, row: Int) {
        let ready = state.action.charges.remaining > 0
        let tone: Glyph.Tone = ready ? .crest : .stone
        sheet.stamp(row, Stage.hudColumn, "DASH ", .quiet)
        sheet.stamp(row, Stage.hudColumn + 5, "++", tone)
        sheet.stamp(row, Stage.hudColumn + 8, ready ? "READY" : "USED", ready ? .mark : .quiet)
    }

    static func comms(_ sheet: inout Sheet, note: String) {
        let top = Stage.fieldRow + 17
        sheet.stamp(top, Stage.hudColumn, "[ COMMS ]", .banner)
        let heard = heard(note)
        sheet.stamp(top + 1, Stage.hudColumn, heard.name, .mark)
        if !heard.face.isEmpty {
            sheet.stamp(top + 1, Stage.hudColumn + heard.name.count + 1, heard.face, .banner)
        }
        let width = Stage.hudWidth - 1
        let lines = Ink.wrap(heard.line, width: width)
        if lines.isEmpty {
            return
        }
        sheet.stamp(top + 2, Stage.hudColumn, lines[0], .quiet)
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
