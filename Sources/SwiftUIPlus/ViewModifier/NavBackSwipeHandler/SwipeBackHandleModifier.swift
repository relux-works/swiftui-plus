import SwiftUI
import Combine

public struct SwipeBackHandleModifier: ViewModifier {
    @StateObject private var ls: LocalState
    private let onBack: (()->())?
    private let onTryDisabledBack: (()->())?
    private let disableBackNavigation: Bool

    public init(
        disableBackNavigation: Bool,
        contentOnTransitionMode: ContentOnTransitionMode,
        onBack: (()->())?,
        onTryDisabledBack: (()->())?
    ) {
        self._ls = .init(wrappedValue: .init(
            disableSwipeBack: disableBackNavigation,
            contentOnTransitionMode: contentOnTransitionMode
        ))
        self.disableBackNavigation = disableBackNavigation
        self.onBack = onBack
        self.onTryDisabledBack = onTryDisabledBack
    }

    public func body(content: Content) -> some View {
        content
            .onDisappear {
                // for new zoomed transition navigation
                // fixed absent status for didDisappear
                ls.applyViewPhase(.didDisappear)
            }
            .onAppearanceChange { vc, phase in
                ls.handleControllerState(vc: vc, phase: phase)
            }
            .onChange(of: disableBackNavigation, perform: {
                ls.disableSwipeBack = $0
            })
            .storingSize(in: $ls.contentRect, space: .global)
            .onReceive(Publishers.CombineLatest(ls.$onSwipeBack, ls.$disableSwipeBack)) { swipeBack, disabled in
                guard swipeBack, disabled.not else { return }
                onBack?()
            }
    }
}
