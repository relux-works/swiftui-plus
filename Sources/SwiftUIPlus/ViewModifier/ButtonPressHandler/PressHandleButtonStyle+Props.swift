import SwiftUI

public extension PressHandleButtonStyle {
    struct Props {
        let pressConfig: (opacity: CGFloat, scale: CGFloat)
        let minDuration: CGFloat
        let reaction: (onPress: ()->(), onRelease: ()->())

        public init(
            pressConfig: (opacity: CGFloat, scale: CGFloat),
            minDuration: CGFloat = 0,
            reaction: (onPress: ()->(), onRelease: ()->())
        ) {
            self.pressConfig = pressConfig
            self.minDuration = minDuration
            self.reaction = reaction
        }
    }
}
