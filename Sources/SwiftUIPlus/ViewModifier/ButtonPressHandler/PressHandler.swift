import SwiftUI

public struct PressHandler: ViewModifier {
    private let onPress: ()->()
    private let onRelease: ()->()
    @State private var pressed = false

    public init(
            onPress: @escaping ()->(),
            onRelease: @escaping ()->()
    ) {
        self.onPress = onPress
        self.onRelease = onRelease
    }

    public func body(content: Content) -> some View {
        content
                .simultaneousGesture(
                        DragGesture(minimumDistance: 0)
                                .onChanged { _ in handlePress() }
                                .onEnded { _ in handleRelease() }
                )
    }

    private func handlePress() {
        guard pressed.not else { return }
        pressed = true
        onPress()
    }

    private func handleRelease() {
        guard pressed else { return }
        pressed = false
        onRelease()
    }
}

public extension View {
    func handlePress(onPress: @escaping () -> Void, onRelease: @escaping () -> Void) -> some View {
        modifier(PressHandler(onPress: onPress, onRelease: onRelease))
    }
}
