import Glibc

public struct PlayTrace: Sendable {
    public static let defaultPath = "/tmp/nene-summit-trace.log"

    private var fd: Int32

    public static func destination(_ value: String?) -> String? {
        if value == "0" {
            return nil
        }
        if value == nil || value == "" || value == "1" {
            return defaultPath
        }
        return value
    }

    public static func open() -> PlayTrace? {
        guard let path = destination(value()) else {
            return nil
        }
        guard var trace = create(at: path) else {
            warn("記録ファイルを開けない。記録なしで続ける。")
            return nil
        }
        trace.write("# nene-summit trace \(path)")
        trace.write("# ms tick bytes strokes held human mode hands from phase cell vx vy charges")
        if trace.fd < 0 {
            return nil
        }
        return trace
    }

    public mutating func write(_ line: String) {
        if fd < 0 {
            return
        }
        let bytes = Array("\(line)\n".utf8)
        var offset = 0
        while offset < bytes.count {
            let wrote = bytes.withUnsafeBytes { raw -> ssize_t in
                guard let base = raw.baseAddress else {
                    return -1
                }
                return Glibc.write(fd, base + offset, raw.count - offset)
            }
            if wrote < 0 {
                fd = -1
                return
            }
            offset += Int(wrote)
        }
    }

    public mutating func close() {
        if fd < 0 {
            return
        }
        _ = Glibc.close(fd)
        fd = -1
    }

    private static func value() -> String? {
        guard let raw = getenv("NENE_SUMMIT_TRACE") else {
            return nil
        }
        return String(cString: raw)
    }

    private static func create(at path: String) -> PlayTrace? {
        let opened = path.withCString { pointer in
            Glibc.open(pointer, O_WRONLY | O_CREAT | O_TRUNC, 0o600)
        }
        if opened < 0 {
            return nil
        }
        return PlayTrace(fd: opened)
    }

    private static func warn(_ message: String) {
        let bytes = Array("\(message)\n".utf8)
        _ = bytes.withUnsafeBytes { raw in
            Glibc.write(STDERR_FILENO, raw.baseAddress, raw.count)
        }
    }
}
