import Testing

@testable import NeNeSummitCore

@Test func acceptsTheModuleName() {
    switch ModuleIdentity.make(name: "NeNeSummitCore") {
    case .success(let identity):
        #expect(identity.name == "NeNeSummitCore")
    case .failure:
        Issue.record("名前を拒否した")
    }
}

@Test func rejectsAnEmptyName() {
    switch ModuleIdentity.make(name: "") {
    case .failure(.emptyName):
        break
    case .success:
        Issue.record("空の名前を受け入れた")
    }
}
