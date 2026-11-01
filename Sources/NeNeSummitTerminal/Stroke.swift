public enum Stroke: Equatable, Sendable {
    case pressed(Press)
    case released(Press)
    case typed(Press)
}
