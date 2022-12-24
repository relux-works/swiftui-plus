import SwiftUI

extension View {
    public var applyingContentFrame: some View {
        self.modifier(PropagatingContentFrame(coordinateSpace: .local))
    }

    public func propagatingContentFrame(coordinateSpace: ApplyingCoordinateSpace.Space) -> some View {
        self.modifier(PropagatingContentFrame(coordinateSpace: coordinateSpace))
    }
}

extension PropagatingContentFrame {
    class Store: ObservableObject {
        @Published var frame: CGRect = .zero
        @Published var space: ApplyingCoordinateSpace.Space

        fileprivate init(space: ApplyingCoordinateSpace.Space) {
            self.space = space
        }
    }
}

struct PropagatingContentFrame: ViewModifier {
    @StateObject private var store: Store
    private let coordinateSpace: ApplyingCoordinateSpace.Space
    init(coordinateSpace: ApplyingCoordinateSpace.Space) {
        self.coordinateSpace = coordinateSpace
        self._store = .init(wrappedValue: .init(space: coordinateSpace))
    }

    func body(content: Content) -> some View {
        content
                .applyCoordinateSpace(coordinateSpace)
                .environment(\.contentFrame, store.frame)
                .environmentObject(store)
    }
}