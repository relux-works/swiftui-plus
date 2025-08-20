import SwiftUI

extension View {
    public func handleSwipeBack(
        disableBackNavigation: Bool = false,
        contentOnTransitionMode: SwipeBackHandleModifier.ContentOnTransitionMode = .enabled,
        onBack: (()->())? = nil,
        onTryDisabledBack: (()->())? = nil
    ) -> some View {
        self
            .modifier(SwipeBackHandleModifier(
                disableBackNavigation: disableBackNavigation,
                contentOnTransitionMode: contentOnTransitionMode,
                onBack: onBack,
                onTryDisabledBack: onTryDisabledBack
            ))
    }
}
