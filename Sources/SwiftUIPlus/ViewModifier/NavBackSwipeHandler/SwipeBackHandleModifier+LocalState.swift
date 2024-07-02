import SwiftUI

extension SwipeBackHandleModifier {
    @MainActor
    class LocalState: ObservableObject {
        @Published var contentRect: CGRect = .zero
        @Published private(set) var onSwipeBack: Bool = false
        @Published var disableSwipeBack: Bool
        @Published var nc: UINavigationController?

        init(disableSwipeBack: Bool) {
            self.disableSwipeBack = disableSwipeBack
            initPipelines()
        }

        private func initPipelines() {
            $contentRect
                .map { $0.origin.x >= UIScreen.main.bounds.width / 5 * 4 }
                .throttle(for: 0.1, scheduler: DispatchQueue.main, latest: true)
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .assign(to: &$onSwipeBack)
        }
    }
}
