import SwiftUI

extension View {
    public func handleSwipeBack(
        disableBackNavigation: Bool = false,
        onBack: (()->())? = nil,
        onTryDisabledBack: (()->())? = nil
    ) -> some View {
        self
            .modifier(SwipeBackHandleModifier(
                disableBackNavigation: disableBackNavigation,
                onBack: onBack,
                onTryDisabledBack: onTryDisabledBack
            ))
    }
}
