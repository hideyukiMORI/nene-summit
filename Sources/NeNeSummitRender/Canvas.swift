import NeNeSummitCore

public enum Canvas {
    public static func draw(
        _ state: SummitState,
        attendance: Attendance = .automatic,
        note: String = ""
    ) -> Frame {
        Frame(lines: Board.frame(state, attendance: attendance, note: note))
    }
}
