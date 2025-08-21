import SwiftUI
import Combine

extension SwipeBackHandleModifier {
    @MainActor
    class LocalState: ObservableObject {
        private var pipelines: Set<AnyCancellable> = []

        @Published var contentRect: CGRect = .zero
        @Published private(set) var onSwipeBack: Bool = false
        @Published var disableSwipeBack: Bool
        @Published var inTransition: Bool = false
        @Published var disableContent: Bool = false

        private var contentOnTransitionMode: ContentOnTransitionMode
        private(set) weak var nc: UINavigationController?
        private(set) weak var vc: UIViewController?

        init(
            disableSwipeBack: Bool,
            contentOnTransitionMode: ContentOnTransitionMode
        ) {
            self.disableSwipeBack = disableSwipeBack
            self.contentOnTransitionMode = contentOnTransitionMode
            initPipelines()
        }

        deinit {
            print(Date.now.timeWithNanos, "swipe handler: LS deinit")
        }

        private func initPipelines() {
            $inTransition
                .assign(to: &$disableContent)

            $contentRect
                .map { $0.origin.x >= UIScreen.main.bounds.width / 5 * 4 }
                .throttle(for: 0.1, scheduler: DispatchQueue.main, latest: true)
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .assign(to: &$onSwipeBack)  

            $disableSwipeBack
                .receive(on: DispatchQueue.main)
                .sink { [weak self] toggle in
                    guard let self else { return }
                    self.nc?.interactivePopGestureRecognizer?.isEnabled = toggle.not
                }
                .store(in: &pipelines)
        }

        func handleControllerState(vc: UIViewController, phase: ControllerAppearanceType) {
            self.vc = self.vc ?? vc
            self.nc = self.nc ?? vc.findSpecificChildVC()
            self.applyViewPhase(phase)
        }

        func applyViewPhase(_ phase: ControllerAppearanceType?) {
            self.actualiseBackNavigation(for: self.nc, backNavEnabled: self.disableSwipeBack.not, with: phase)

            switch contentOnTransitionMode {
                case .enabled: break
                case let .disabled(dimColor): self.actualiseContentBlockingOnTransition(for: self.vc, dimColor: dimColor, with: phase)
            }
        }

        private func actualiseBackNavigation(
            for nc: UINavigationController?,
            backNavEnabled: Bool,
            with phase: ControllerAppearanceType?
        ) {
            switch phase {
                case .willAppear:
                    if #available(iOS 18.0, *) {
                        nc?.interactivePopGestureRecognizer?.isEnabled = backNavEnabled
                    }
                case .didAppear:
                case .willDisappear:
                    break
                case .didDisappear:
                    break
                case .none:
                    break
            }
        }

        private func actualiseContentBlockingOnTransition(
            for vc: UIViewController?,
            dimColor: Color,
            with phase: ControllerAppearanceType?
        ) {
            print(Date.now.timeWithNanos, "swipe handler: actualiseContentBlockingOnTransition for phase \(phase.debugDescription) nc: \(nc != nil)")

            switch phase {
                case .willAppear:
                    // actually problem with content is only for willDisappear
                    // in some cases with custom animation it's tappable even if not visible while the view is not disappeared in view hierarchy
                    vc?.blockContent(dimColor: dimColor, from: phase.debugDescription)
                case .didAppear:
                    vc?.unblockContent(from: phase.debugDescription)
                case .willDisappear:
                    vc?.blockContent(dimColor: dimColor, from: phase.debugDescription)
                case .didDisappear:
                    vc?.unblockContent(from: phase.debugDescription)
                case .none:
                    break
            }
        }
    }
}
