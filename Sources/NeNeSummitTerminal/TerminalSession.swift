import Glibc
import NeNeSummitRender

public struct TerminalSession {
    public enum Failure: Error, Equatable, Sendable {
        case notATerminal
    }

    private let original: termios
    private let flags: Int32

    public static func open() -> Result<TerminalSession, Failure> {
        if isatty(STDIN_FILENO) == 0 {
            return .failure(.notATerminal)
        }
        var term = termios()
        if tcgetattr(STDIN_FILENO, &term) != 0 {
            return .failure(.notATerminal)
        }
        var raw = term
        cfmakeraw(&raw)
        if tcsetattr(STDIN_FILENO, TCSANOW, &raw) != 0 {
            return .failure(.notATerminal)
        }
        let flags = fcntl(STDIN_FILENO, F_GETFL, 0)
        _ = fcntl(STDIN_FILENO, F_SETFL, flags | O_NONBLOCK)
        emit("\u{001B}[?25l\u{001B}[2J")
        return .success(TerminalSession(original: term, flags: flags))
    }

    public func close() {
        var term = original
        _ = tcsetattr(STDIN_FILENO, TCSANOW, &term)
        _ = fcntl(STDIN_FILENO, F_SETFL, flags)
        TerminalSession.emit("\u{001B}[?25h\u{001B}[0m")
    }

    public func poll() -> [Press] {
        var buffer = [UInt8](repeating: 0, count: 64)
        let count = buffer.withUnsafeMutableBytes { raw -> ssize_t in
            guard let base = raw.baseAddress else {
                return 0
            }
            return Glibc.read(STDIN_FILENO, base, raw.count)
        }
        if count <= 0 {
            return []
        }
        return PressParser.parse(Array(buffer.prefix(Int(count))))
    }

    public func present(_ frame: Frame) {
        var text = "\u{001B}[H"
        for line in frame.lines {
            text += Painter.paint(line)
            text += "\u{001B}[0m\r\n"
        }
        TerminalSession.emit(text)
    }

    public func wait(milliseconds: Int) {
        var request = timespec(tv_sec: 0, tv_nsec: milliseconds * 1_000_000)
        _ = nanosleep(&request, nil)
    }

    public static func fail(_ message: String) -> Never {
        let bytes = Array("\(message)\n".utf8)
        _ = bytes.withUnsafeBytes { raw in
            Glibc.write(STDERR_FILENO, raw.baseAddress, raw.count)
        }
        exit(1)
    }

    private static func emit(_ text: String) {
        let bytes = Array(text.utf8)
        _ = bytes.withUnsafeBytes { raw in
            Glibc.write(STDOUT_FILENO, raw.baseAddress, raw.count)
        }
    }
}
