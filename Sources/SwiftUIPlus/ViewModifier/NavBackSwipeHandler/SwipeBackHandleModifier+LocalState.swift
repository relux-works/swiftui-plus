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
            self.nc = self.nc ?? vc.findSpecificChildVC()
            self.applyViewPhase(phase)
        }

        func applyViewPhase(_ phase: ControllerAppearanceType?) {
            self.actualiseBackNavigation(for: self.nc, backNavEnabled: self.disableSwipeBack.not, with: phase)

            switch contentOnTransitionMode {
                case .enabled: break
                case let .disabled(dimColor):  self.actualiseContentBlockingOnTransition(for: self.nc, dimColor: dimColor, with: phase)
            }
        }

        private func actualiseBackNavigation(
            for nc: UINavigationController?,
            backNavEnabled: Bool,
            with phase: ControllerAppearanceType?
        ) {
            switch phase {
                case .willAppear:
                    nc?.interactivePopGestureRecognizer?.isEnabled = backNavEnabled
                case .didAppear:
                    self.nc?.interactivePopGestureRecognizer?.isEnabled = backNavEnabled
                case .willDisappear:
                    self.nc?.interactivePopGestureRecognizer?.isEnabled = backNavEnabled
                case .didDisappear:
                    self.nc?.interactivePopGestureRecognizer?.isEnabled = true
                case .none:
                    break
            }
        }

        private func actualiseContentBlockingOnTransition(
            for nc: UINavigationController?,
            dimColor: Color,
            with phase: ControllerAppearanceType?
        ) {
            print(Date.now.timeWithNanos, "swipe handler: actualiseContentBlockingOnTransition for phase \(phase.debugDescription) nc: \(nc != nil)")

            switch phase {
                case .willAppear:
                    break
                    // actually problem with content is only for willDisappear
                    // in some cases with custom animation it's tappable even if not visible while the view is not disappeared in view hierarchy
//                    nc?.blockContent(dim: contentDim, from: phase.debugDescription)
                case .didAppear:
                    nc?.unblockContent(from: phase.debugDescription)
                case .willDisappear:
                    nc?.blockContent(dimColor: dimColor, from: phase.debugDescription)
                case .didDisappear:
                    nc?.unblockContent(from: phase.debugDescription)
                case .none:
                    break
            }
        }
    }
}
