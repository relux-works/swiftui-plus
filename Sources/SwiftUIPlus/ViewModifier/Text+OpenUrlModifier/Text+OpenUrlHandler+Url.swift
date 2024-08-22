import Foundation

public extension URL {
    typealias UrlOpenReaction = (URL) -> ()
    typealias OpenUrlPatternReaction = (pattern: UrlPattern, reaction: UrlOpenReaction)

    enum UrlPattern: Hashable, Equatable {
        case url(URL)
        case string(String)
        var url: URL? {
            switch self {
                case let .url(value): return value
                case let .string(value): return URL(string: value)
            }
        }
    }
}
