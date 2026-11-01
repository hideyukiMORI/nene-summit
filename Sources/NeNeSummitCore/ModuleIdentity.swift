struct ModuleIdentity: Sendable {
    enum Rejection: Error, Sendable {
        case emptyName
    }

    let name: String

    private init(name: String) {
        self.name = name
    }

    static func make(name: String) -> Result<ModuleIdentity, Rejection> {
        if name.isEmpty {
            return .failure(.emptyName)
        }
        return .success(ModuleIdentity(name: name))
    }
}
