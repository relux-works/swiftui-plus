import SwiftUI

public extension PressHandleButtonStyle {
    struct Props {
        let pressed: Binding<Bool>
        let pressConfig: (opacity: CGFloat, scale: CGFloat)
        let minDuration: CGFloat

        public init(
            pressed: Binding<Bool>,
            pressConfig: (opacity: CGFloat, scale: CGFloat),
            minDuration: CGFloat = 0
        ) {
            self.pressed = pressed
            self.pressConfig = pressConfig
            self.minDuration = minDuration
        }
    }
}
