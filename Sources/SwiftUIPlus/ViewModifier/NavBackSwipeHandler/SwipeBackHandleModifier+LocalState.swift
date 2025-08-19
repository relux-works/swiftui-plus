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

        private var disableContentOnTransition: Bool
        weak var nc: UINavigationController?
        @Published var ncPhase: ControllerAppearanceType?

        init(
            disableSwipeBack: Bool,
            disableContentOnTransition: Bool
        ) {
            self.disableSwipeBack = disableSwipeBack
            self.disableContentOnTransition = disableContentOnTransition
            initPipelines()
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

            $ncPhase
                .receive(on: DispatchQueue.main)
                .sink { [weak self] phase in
                    guard let self else { return }
                    self.actualiseBackNavigation(for: self.nc, backNavEnabled: self.disableSwipeBack.not, with: phase)
                    if self.disableContentOnTransition {
                        self.actualiseContentBlockingOnTransition(for: self.nc, contentDim: 0.2, with: phase)
                    }
                }
                .store(in: &pipelines)

            $disableSwipeBack
                .receive(on: DispatchQueue.main)
                .sink { [weak self] toggle in
                    guard let self else { return }
                    self.nc?.interactivePopGestureRecognizer?.isEnabled = toggle.not
                }
                .store(in: &pipelines)
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
            contentDim: CGFloat,
            with phase: ControllerAppearanceType?
        ) {
            print(Date.now.timeWithNanos, "swipe handler: actualiseContentBlockingOnTransition for phase \(phase.debugDescription)")

            switch phase {
                case .willAppear:
                    nc?.blockContent(dim: contentDim, from: phase.debugDescription)
                case .didAppear:
                    nc?.unblockContent(from: phase.debugDescription)
                case .willDisappear:
                    nc?.blockContent(dim: contentDim, from: phase.debugDescription)
                case .didDisappear:
                    nc?.unblockContent(from: phase.debugDescription)
                case .none:
                    break
            }
        }
    }
}
