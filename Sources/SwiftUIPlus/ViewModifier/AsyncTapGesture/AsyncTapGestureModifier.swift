import SwiftUI

extension View {
    public func onAsyncTapGesture(
        count: Int = 1,
        perform action: @escaping () async -> Void
    ) -> some View {
        self
            .modifier(AsyncTapGestureModifier(count: count, perform: action))
    }
}

public struct AsyncTapGestureModifier: ViewModifier {
    @State private var inProgress: Bool = false
    private let count: Int
    private let action: () async -> Void

    public init(count: Int, perform action: @escaping () async -> Void) {
        self.count = count
        self.action = action
    }

    public func body(content: Content) -> some View {
        content
            .allowsHitTesting(inProgress.not)
            .onTapGesture(count: count, perform: handleTap)
    }

    private func handleTap() {
        Task { @MainActor in
            self.inProgress = true
            await action()
            self.inProgress = false
        }
    }
}
