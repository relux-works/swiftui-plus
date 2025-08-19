import SwiftUI
import Combine

struct SwipeBackHandleModifier: ViewModifier {
    @StateObject private var ls: LocalState
    private let onBack: (()->())?
    private let onTryDisabledBack: (()->())?
    private let disableBackNavigation: Bool

    init(
        disableBackNavigation: Bool,
        disableContentOnTransition: Bool,
        onBack: (()->())?,
        onTryDisabledBack: (()->())?
    ) {
        self._ls = .init(wrappedValue: .init(
            disableSwipeBack: disableBackNavigation,
            disableContentOnTransition: disableContentOnTransition
        ))
        self.disableBackNavigation = disableBackNavigation
        self.onBack = onBack
        self.onTryDisabledBack = onTryDisabledBack
    }

    func body(content: Content) -> some View {
        content
            .onAppearanceChange { vc, phase in
                ls.nc = vc.findSpecificChildVC()
                ls.ncPhase = phase
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
