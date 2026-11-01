import NeNeSummitCore

enum Guide {
    static func choose(_ state: SummitState) -> Input {
        if state.action.phase == .grounded {
            return .hopping(.right)
        }
        return .moving(.right)
    }
}
