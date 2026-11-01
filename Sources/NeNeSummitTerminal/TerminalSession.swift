import Glibc
import NeNeSummitRender

public struct TerminalSession {
    public enum Failure: Error, Equatable, Sendable {
        case notATerminal
    }

    private let original: termios
    private let flags: Int32
    private var pending: [UInt8]
    private static let enterKeys = "\u{001B}[=11u\u{001B}[?9001h\u{001B}[?25l\u{001B}[2J"
    private static let leaveKeys = "\u{001B}[<u\u{001B}[=0u\u{001B}[?9001l\u{001B}[?25h\u{001B}[0m"

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
        emit(enterKeys)
        return .success(TerminalSession(original: term, flags: flags, pending: []))
    }

    public func close() {
        TerminalSession.emit(TerminalSession.leaveKeys)
        var term = original
        _ = tcsetattr(STDIN_FILENO, TCSANOW, &term)
        _ = fcntl(STDIN_FILENO, F_SETFL, flags)
    }

    public mutating func poll() -> Arrival {
        let bytes = readChunk()
        pending.append(contentsOf: bytes)
        trimPending()
        let read = StrokeParser.parse(pending)
        if read.consumed > 0 {
            pending.removeFirst(read.consumed)
        }
        return Arrival(bytes: bytes, strokes: read.strokes)
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

    private mutating func trimPending() {
        if pending.count > 128 {
            pending.removeFirst(pending.count - 128)
        }
    }

    private func readChunk() -> [UInt8] {
        var buffer = [UInt8](repeating: 0, count: 256)
        let count = buffer.withUnsafeMutableBytes { raw -> ssize_t in
            guard let base = raw.baseAddress else {
                return 0
            }
            return Glibc.read(STDIN_FILENO, base, raw.count)
        }
        if count <= 0 {
            return []
        }
        return Array(buffer.prefix(Int(count)))
    }

    private static func emit(_ text: String) {
        let bytes = Array(text.utf8)
        _ = bytes.withUnsafeBytes { raw in
            Glibc.write(STDOUT_FILENO, raw.baseAddress, raw.count)
        }
    }
}
