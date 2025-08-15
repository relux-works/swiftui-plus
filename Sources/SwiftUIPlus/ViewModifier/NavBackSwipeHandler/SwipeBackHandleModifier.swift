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
            .overlay {
                Color.clear.allowsTightening(true).presentIf(ls.disableContent)
            }
            .allowsTightening(ls.disableContent.not)
            .onAppearanceChange { vc, phase in
                ls.nc = vc.findSpecificChildVC()
                switch phase {
                    case .willAppear:
                        if ls.disableSwipeBack {
                            ls.nc?.interactivePopGestureRecognizer?.isEnabled = false
                        }
                        ls.inTransition = true
                    case .didAppear:
                        if ls.disableSwipeBack.not {
                            ls.nc?.interactivePopGestureRecognizer?.isEnabled = true
                        }
                        ls.inTransition = false
                    case .willDisappear:
                        if ls.disableSwipeBack.not {
                            ls.nc?.interactivePopGestureRecognizer?.isEnabled = true
                        }
                        ls.inTransition = true
                    case .didDisappear:
                        if ls.disableSwipeBack {
                            ls.nc?.interactivePopGestureRecognizer?.isEnabled = true
                        }
                        ls.inTransition = false
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
