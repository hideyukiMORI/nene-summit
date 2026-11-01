import NeNeSummitRender

enum Picture {
    static func text(_ frame: Frame) -> String {
        var text = "\u{001B}[H"
        for line in frame.lines {
            text += Painter.paint(line)
            text += "\u{001B}[0m\u{001B}[K\r\n"
        }
        text += "\u{001B}[J"
        return text
    }
}
