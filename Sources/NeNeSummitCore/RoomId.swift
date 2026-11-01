struct RoomId: Equatable, Sendable {
    enum Rejection: Error, Equatable, Sendable {
        case empty
    }

    let value: String

    private init(value: String) {
        self.value = value
    }

    static func make(value: String) -> Result<RoomId, Rejection> {
        if value.isEmpty {
            return .failure(.empty)
        }
        return .success(RoomId(value: value))
    }
}
