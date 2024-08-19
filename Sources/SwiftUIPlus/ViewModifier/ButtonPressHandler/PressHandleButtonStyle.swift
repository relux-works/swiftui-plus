import SwiftUI

public struct PressHandleButtonStyle: ButtonStyle {
    private let props: Props
    @State private var prevHoldState = false
    @State private var changeTask : Task<Void, any Error>?

    public init(props: Props) {
        self.props = props
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? props.pressConfig.opacity : 1.0)
            .scaleEffect(configuration.isPressed ? props.pressConfig.scale : 1.0)
            .animation(.easeInOut)
            .onChange(of: configuration.isPressed, perform: reactOnPressState)
    }

    private func reactOnPressState(pressed: Bool) {
        self.changeTask?.cancel()
        self.changeTask = Task.delayed(byTimeInterval: props.minDuration) { @MainActor in
            guard prevHoldState != pressed else { return }
            self.prevHoldState = pressed
            switch pressed {
                case true: props.reaction.onPress()
                case false: props.reaction.onRelease()
            }
        }
    }
}

