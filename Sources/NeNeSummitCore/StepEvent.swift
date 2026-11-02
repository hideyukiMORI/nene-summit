public enum StepEvent: Equatable, Sendable {
    case tick
    case faced(Direction)
    case jumped
    case sprung
    case dashed
    case fell
    case returned
    case summited
    case departed
    case gathered
}
