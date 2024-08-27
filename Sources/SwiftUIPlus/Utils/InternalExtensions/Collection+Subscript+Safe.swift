import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        guard startIndex <= index, index < endIndex
        else { return nil }
        return self[index]
    }
}
