import SwiftUI

public struct SizeKey: PreferenceKey {
    public static let defaultValue: [CGSize] = []
    public static func reduce(value: inout [CGSize], nextValue: () -> [CGSize]) {
        value.append(contentsOf: nextValue())
    }
}
