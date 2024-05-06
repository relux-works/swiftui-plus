import SwiftUI

public extension EnvironmentValues {
    var size: (width: CGFloat?, height: CGFloat?) {
        get { self[SizeEnvironmentKey.self] }
        set { self[SizeEnvironmentKey.self] = newValue }
    }
}

public struct SizeEnvironmentKey: EnvironmentKey {
    public static let defaultValue: (width: CGFloat?, height: CGFloat?) = (width: nil, height: nil)
}
