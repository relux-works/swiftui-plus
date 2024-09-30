import SwiftUI

public struct AdaptiveLineLimitModifier: ViewModifier {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    let rule: AdaptiveLineLimitRule
    let lessLineLimit: Int?
    let greaterLineLimit: Int?

    public init(
        rule: AdaptiveLineLimitRule,
        lessLineLimit: Int? = nil,
        greaterLineLimit: Int? = nil
    ) {
        self.rule = rule
        self.lessLineLimit = lessLineLimit
        self.greaterLineLimit = greaterLineLimit
    }

    public func body(content: Content) -> some View {
        content
            .lineLimit(adaptedLineLimit)
    }
}

private extension AdaptiveLineLimitModifier {
    var adaptedLineLimit: Int? {
        switch rule {
            case let .greaterThanOrEqual(size, lineLimit):
                return dynamicTypeSize >= size ? lineLimit : lessLineLimit
            case let .lessThanOrEqual(size, lineLimit):
                return dynamicTypeSize <= size ? lineLimit : greaterLineLimit
            case let .range(range, lineLimit):
                guard dynamicTypeSize <= range.upperBound else { return greaterLineLimit }
                guard dynamicTypeSize >= range.lowerBound else { return lessLineLimit }
                return lineLimit

        }
    }
}

public extension View {
    func adaptiveLineLimit(
        rule: AdaptiveLineLimitRule,
        lessLineLimit: Int? = nil,
        greaterLineLimit: Int? = nil
    ) -> some View {
        modifier(
            AdaptiveLineLimitModifier(
                rule: rule,
                lessLineLimit: lessLineLimit,
                greaterLineLimit: greaterLineLimit
            )
        )
    }
}
