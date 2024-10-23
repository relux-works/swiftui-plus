import SwiftUI

public struct PressHandleButtonStyle: ButtonStyle {
    private let props: Props
    @Binding private var pressed: Bool
    @State private var changeTask : Task<Void, any Error>?

    public init(props: Props) {
        self._pressed = props.pressed
        self.props = props
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? props.pressConfig.opacity : 1.0)
            .scaleEffect(configuration.isPressed ? props.pressConfig.scale : 1.0)
            .animation(.easeInOut, value: configuration.isPressed)
            .onChange(of: configuration.isPressed, perform: reactOnPressState)
    }

    private func reactOnPressState(pressed: Bool) {
        self.changeTask?.cancel()
        self.changeTask = Task.delayed(
            byTimeInterval: pressed ? props.minDuration : 0
        ) { @MainActor in
            guard self.pressed != pressed else { return }
            self.pressed = pressed
        }
    }
}

