import Foundation

extension View {
    public func applyCoordinateSpace(_ space: ApplyingCoordinateSpace.Space) -> some View {
        self.modifier(ApplyingCoordinateSpace(space: space))
    }
}

extension ApplyingCoordinateSpace {
    public enum Space {
        case local
        case global
        case named(name: String)

        var asCoordinateSpace: CoordinateSpace {
            switch self {
            case .local: return .local
            case .global: return .global
            case let .named(name): return .named(name)
            }
        }
    }
}

public struct ApplyingCoordinateSpace: ViewModifier {
    private let space: Space
    public init(space: Space) {
        self.space = space
    }

    public func body(content: Content) -> some View {
        switch space {
        case let .named(name):
            content.coordinateSpace(name: name)
        default:
            content
        }
    }
}