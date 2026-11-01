import NeNeSummitRender

enum Picture {
    static func text(_ frame: Frame) -> String {
        var text = ""
        var row = 1
        for line in frame.lines {
            text += "\u{001B}[\(row);1H"
            text += Painter.paint(line)
            text += "\u{001B}[0m\u{001B}[K"
            row += 1
        }
        text += "\u{001B}[J"
        return text
    }
}
