import SwiftUI
import Combine

struct SwipeBackHandleModifier: ViewModifier {
    @StateObject private var ls: LocalState
    private let onBack: (()->())?
    private let onTryDisabledBack: (()->())?
    private let disableBackNavigation: Bool

    init(
        disableBackNavigation: Bool,
        onBack: (()->())?,
        onTryDisabledBack: (()->())?
    ) {
        self._ls = .init (wrappedValue: .init (disableSwipeBack: disableBackNavigation))
        self.disableBackNavigation = disableBackNavigation
        self.onBack = onBack
        self.onTryDisabledBack = onTryDisabledBack
    }

    func body(content: Content) -> some View {
        content
          .onAppearanceChange { vc, phase in
                ls.nc = vc.findSpecificChildVC()
                switch phase {
                    case .willAppear:
                        break
                    case .didAppear:
                        ls.nc?.interactivePopGestureRecognizer?.isEnabled = ls.disableSwipeBack.not
                    case .willDisappear:
                        ls.nc?.interactivePopGestureRecognizer?.isEnabled = true
                    case .didDisappear:
                        break
                }
            }
            .onChange(of: disableBackNavigation, perform: {
                ls.disableSwipeBack = $0
            })
            .onReceive(ls.$disableSwipeBack) { toggle in
                ls.nc?.interactivePopGestureRecognizer?.isEnabled = toggle.not
            }
            .storingSize(in: $ls.contentRect, space: .global)
            .onReceive(Publishers.CombineLatest(ls.$onSwipeBack, ls.$disableSwipeBack)) { swipeBack, disabled in
                guard swipeBack, disabled.not else { return }
                onBack?()
            }
    }
}