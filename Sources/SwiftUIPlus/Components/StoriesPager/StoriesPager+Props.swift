import Foundation
import Combine

extension StoriesPager.Reactions {
    enum NavigationType: Equatable {
        case backward(from: Model.Id)
        case forward(from: Model.Id)
    }
}

extension StoriesPager.Reactions.NavigationType {
    var asStoriesNavType: StoriesPagerNavigationType {
        switch self {
            case let .backward(id): .backward(id: id.description)
            case let .forward(id): .forward(id: id.description)
        }
    }
}

public enum StoriesPagerNavigationType {
    case backward(id: CustomStringConvertible)
    case forward(id: CustomStringConvertible)

    public var targetPageId: CustomStringConvertible {
        switch self {
            case let .forward(id): return id
            case let .backward(id): return id
        }
    }
}

extension StoriesPagerNavigationType: Identifiable, Equatable {
    public var id: String { "\(self)" }
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}


extension StoriesPager {
    public struct ViewConfig {
        @ViewBuilder let storyViewBuilder: (Model) -> Page
        let switchStoryModifier: SwitchModifier
        let backToForwardAreaRatio: CGFloat
        let contentOnHoldConfig: (opacity: CGFloat, scale: CGFloat)
        let contentOnHoldMinDuration: TimeInterval
        let navigationDebounceDuration: TimeInterval
        let activePageDebounceDuration: TimeInterval

        public init(
            @ViewBuilder storyViewBuilder: @escaping (Model) -> Page,
            switchStoryModifier: SwitchModifier = CubeRotationModifier(),
            backToForwardNavigationAreaRatio: CGFloat = 0.4,
            contentOnHoldConfig: (opacity: CGFloat, scale: CGFloat) = (opacity: 1, scale: 1),
            contentOnHoldMinDuration: TimeInterval = 0.4,
            navigationDebounceDuration: TimeInterval = 0.2,
            activePageDebounceDuration: TimeInterval = 0.1
        ) {
            self.storyViewBuilder = storyViewBuilder
            self.switchStoryModifier = switchStoryModifier
            self.backToForwardAreaRatio = backToForwardNavigationAreaRatio
            self.contentOnHoldConfig = contentOnHoldConfig
            self.contentOnHoldMinDuration = contentOnHoldMinDuration
            self.navigationDebounceDuration = navigationDebounceDuration
            self.activePageDebounceDuration = activePageDebounceDuration
        }
    }
}

extension StoriesPager {
    public struct Reactions {
        let activeId: Binding<Model.Id?>
        let contentHeld: Binding<Bool>?
        let navigationSubject: PassthroughSubject<StoriesPagerNavigationType, Never>?

        public init(
            activeId: Binding<Model.Id?> = .constant(.none),
            contentHeld: Binding<Bool>? = .none,
            navigationSubject: PassthroughSubject<StoriesPagerNavigationType, Never>? = .none
        ) {
            self.activeId = activeId
            self.contentHeld = contentHeld
            self.navigationSubject = navigationSubject
        }
    }
}
