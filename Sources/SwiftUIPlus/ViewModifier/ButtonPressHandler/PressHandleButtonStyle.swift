import SwiftUI

public struct PressHandleButtonStyle: PrimitiveButtonStyle {
    private let props: Props
    @State var pressed: Bool = false

    public init(props: Props) {
        self.props = props
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
                .opacity(pressed ? props.pressConfig.opacity : 1.0)
                .scaleEffect(pressed ? props.pressConfig.scale : 1.0)
                .onTapGesture { configuration.trigger() }
                .handlePress(
                        onPress: onPress,
                        onRelease: onRelease
                )
                .animation(.easeInOut)
    }

    private func onPress() {
        guard !pressed else { return }
        pressed = true
        props.reaction.onPress()
    }

    private func onRelease() {
        guard pressed else { return }
        pressed = false;
        props.reaction.onRelease()
    }
}

