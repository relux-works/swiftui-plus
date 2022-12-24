import SwiftUI

public extension PressHandleButtonStyle {
    struct Props {
        let pressConfig: (opacity: CGFloat, scale: CGFloat)
        let reaction: (onPress: ()->(), onRelease: ()->())

        public init(
                pressConfig: (opacity: CGFloat, scale: CGFloat),
                reaction: (onPress: ()->(), onRelease: ()->())
        ) {
            self.pressConfig = pressConfig
            self.reaction = reaction
        }
    }
}
