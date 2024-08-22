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
            case .backward: .backward
            case .forward: .forward
        }
    }
}

public enum StoriesPagerNavigationType: Equatable {
    case backward
    case forward
}

extension StoriesPager {
    public struct ViewConfig {
        @ViewBuilder let storyViewBuilder: (Model) -> Page
        let switchStoryModifier: SwitchModifier
        let backToForwardAreaRatio: CGFloat
        let contentOnHoldConfig: (opacity: CGFloat, scale: CGFloat)
        let contentOnHoldMinDuration: TimeInterval

        public init(
            @ViewBuilder storyViewBuilder: @escaping (Model) -> Page,
            switchStoryModifier: SwitchModifier = CubeRotationModifier(),
            backToForwardNavigationAreaRatio: CGFloat = 0.4,
            contentOnHoldConfig: (opacity: CGFloat, scale: CGFloat) = (opacity: 1, scale: 1),
            contentOnHoldMinDuration: TimeInterval = 0.25
        ) {
            self.storyViewBuilder = storyViewBuilder
            self.switchStoryModifier = switchStoryModifier
            self.backToForwardAreaRatio = backToForwardNavigationAreaRatio
            self.contentOnHoldConfig = contentOnHoldConfig
            self.contentOnHoldMinDuration = contentOnHoldMinDuration
        }
    }
}

extension StoriesPager {
    public struct Reactions {
        let contentHeld: Binding<Bool>?
        let navigationSubject: PassthroughSubject<StoriesPagerNavigationType, Never>?

        public init(
            contentHeld: Binding<Bool>? = .none,
            navigationSubject: PassthroughSubject<StoriesPagerNavigationType, Never>? = .none
        ) {
            self.contentHeld = contentHeld
            self.navigationSubject = navigationSubject
        }
    }
}
