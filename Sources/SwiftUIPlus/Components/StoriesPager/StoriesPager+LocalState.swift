import SwiftUI
import Combine

extension StoriesPager {
    @MainActor
    final class LocalState: ObservableObject {
        private(set) var pagesRects: [Model.Id: CGRect] = [:]
        private let viewConfig: StoriesPager.ViewConfig

        init(viewConfig: StoriesPager.ViewConfig) {
            self.viewConfig = viewConfig
        }

        let activePageIdSub: PassthroughSubject<Model.Id?, Never> = .init()
        var activePageIdPub: AnyPublisher<Model.Id?, Never> {
            activePageIdSub
                .debounce(
                    for: .init(floatLiteral: viewConfig.activePageDebounceDuration),
                    scheduler: DispatchQueue.main
                )
                .removeDuplicates()
                .eraseToAnyPublisher()
        }

        let navigationSub: PassthroughSubject<Reactions.NavigationType, Never> = .init()
        var navigationPub: AnyPublisher<StoriesPagerNavigationType, Never> {
            navigationSub
                .debounce(
                    for: .init(floatLiteral: viewConfig.navigationDebounceDuration),
                    scheduler: DispatchQueue.main
                )
                .map { $0.asStoriesNavType }
                .eraseToAnyPublisher()
        }

        func trackPageRects(currentPageId: Model.Id, targetPageId: Model.Id, rect: CGRect) {
            self.pagesRects[targetPageId] = rect
            if currentPageId == targetPageId {
                let placedInViewPort = rect.minX == 0
                self.activePageIdSub.send(placedInViewPort ? targetPageId : .none)
            }
        }
    }
}
