extension SwipeBackHandleModifier {
    public enum ContentOnTransitionMode : Sendable{
        case enabled
        case disabled(dimColor: Color = .clear)

        public static let disabled: Self = .disabled()
    }
}
