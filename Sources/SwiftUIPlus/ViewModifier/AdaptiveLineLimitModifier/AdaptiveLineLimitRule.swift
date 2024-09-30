import Foundation

public enum AdaptiveLineLimitRule {
    case greaterThanOrEqual(size: DynamicTypeSize, lineLimit: Int)
    case lessThanOrEqual(size: DynamicTypeSize, lineLimit: Int)
    case range(size: ClosedRange<DynamicTypeSize>, lineLimit: Int)
}
