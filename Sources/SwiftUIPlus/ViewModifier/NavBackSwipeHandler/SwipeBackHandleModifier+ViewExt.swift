import SwiftUI

extension View {
    public func handleSwipeBack(
        disableBackNavigation: Bool = false,
        disableContentOnTransition: Bool = false,
        onBack: (()->())? = nil,
        onTryDisabledBack: (()->())? = nil
    ) -> some View {
        self
            .modifier(SwipeBackHandleModifier(
                disableBackNavigation: disableBackNavigation,
                disableContentOnTransition: disableContentOnTransition,
                onBack: onBack,
                onTryDisabledBack: onTryDisabledBack
            ))
    }
}
