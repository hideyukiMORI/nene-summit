import Testing

@testable import NeNeSummitCore

@Test func acceptsARoomName() {
    switch RoomId.make(value: "first-ascent") {
    case .success(let id):
        #expect(id.value == "first-ascent")
    case .failure:
        Issue.record("名前を拒否した")
    }
}

@Test func rejectsAnEmptyRoomName() {
    switch RoomId.make(value: "") {
    case .failure(.empty):
        break
    case .success:
        Issue.record("空の名前を受け入れた")
    }
}
