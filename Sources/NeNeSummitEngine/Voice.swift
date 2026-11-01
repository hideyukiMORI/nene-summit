enum Voice: Equatable, Sendable {
    case mio
    case rue
    case nib
    case bram

    var name: String {
        switch self {
        case .mio:
            return "MIO"
        case .rue:
            return "RUE"
        case .nib:
            return "NIB"
        case .bram:
            return "BRAM"
        }
    }

    var face: String {
        switch self {
        case .mio:
            return "(^^)"
        case .rue:
            return "(-_-)"
        case .nib:
            return "(o_o)"
        case .bram:
            return "(>:)"
        }
    }

    static func at(_ index: Int) -> Voice {
        let order: [Voice] = [.mio, .rue, .nib, .bram]
        let wrapped = index % order.count
        if wrapped < 0 {
            return .mio
        }
        return order[wrapped]
    }
}
