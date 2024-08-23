import SwiftUI
import Combine

extension StoriesPager {
    @MainActor
    final class LocalState: ObservableObject {
        private(set) var pagesRects: [Model.Id: CGRect] = [:]

        let activePageIdSub: PassthroughSubject<Model.Id?, Never> = .init()
        var activePageIdPub: AnyPublisher<Model.Id?, Never> {
            activePageIdSub
                .debounce(for: 0.05, scheduler: DispatchQueue.main)
                .removeDuplicates()
                .eraseToAnyPublisher()
        }

        let navigationSub: PassthroughSubject<Reactions.NavigationType, Never> = .init()
        var navigationPub: AnyPublisher<StoriesPagerNavigationType, Never> {
            navigationSub
                .debounce(for: 0.15, scheduler: DispatchQueue.main)
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
