import SwiftUI
import Combine

extension StoriesPager {
    @MainActor
    final class LocalState: ObservableObject {
        private(set) var pagesRects: [Model.Id: CGRect] = [:]
        private let viewConfig: StoriesPager.ViewConfig
        private var initialOffsetY: CGFloat?

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
            if self.initialOffsetY == nil { self.initialOffsetY = rect.minY }

            if currentPageId == targetPageId {
                let startPoint = CGPoint(x: rect.minX, y: rect.minY - (self.initialOffsetY ?? 0))
                let placedInViewPort = startPoint.distance == 0
                self.activePageIdSub.send(placedInViewPort ? targetPageId : .none)
            }
        }
    }
}

fileprivate 
extension CGPoint {
    var distance: CGFloat {
        sqrt(pow(self.x, 2) + pow(self.y, 2))
    }
}
