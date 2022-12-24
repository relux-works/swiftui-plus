import SwiftUI

extension View {
    public var storingContentFrame: some View {
        self.modifier(StoringContentFrame(condition: nil))
    }
    public func storingContentFrame(when condition: @escaping (CGRect)->Bool) -> some View {
        self.modifier(StoringContentFrame(condition: condition))
    }
}

struct StoringContentFrame: ViewModifier {
    let condition: ((CGRect)->Bool)?
    @EnvironmentObject private var store: PropagatingContentFrame.Store

    func body(content: Content) -> some View {
        content
                .storingSize(
                        in: $store.frame,
                        space: store.space.asCoordinateSpace,
                        when: condition
                )
    }
}