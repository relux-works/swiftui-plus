import SwiftUI

public extension View {
    typealias UrlPattern = URL.UrlPattern
    typealias UrlOpenReaction = URL.UrlOpenReaction
    typealias UrlOpenReactions = URL.OpenUrlPatternReaction

    func reactOnOpenURLs(
        @URL.OpenUrlReactionBuilder reactions: () -> [UrlOpenReactions]
    ) -> some View {
        let reactions = reactions().asUrlMap
        return self
            .environment(\.openURL, OpenURLAction { url in
                switch reactions[url] {
                    case let .some(reaction): reaction(url); return .handled
                    case .none: return .systemAction
                }
            })
    }
}

extension Sequence where Element == URL.OpenUrlPatternReaction {
    var asUrlMap: [URL: URL.UrlOpenReaction] {
        self.reduce(into: [URL: URL.UrlOpenReaction]()) { store, next in
            guard let url = next.pattern.url else { return }
            store[url] = next.reaction
        }
    }
}
