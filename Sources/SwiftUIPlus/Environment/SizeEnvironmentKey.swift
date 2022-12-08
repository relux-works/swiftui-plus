import SwiftUI

public extension EnvironmentValues {
    var size: CGSize? {
        get { self[SizeEnvironmentKey.self] }
        set { self[SizeEnvironmentKey.self] = newValue }
    }
}

public struct SizeEnvironmentKey: EnvironmentKey {
    public static let defaultValue: CGSize? = nil
}
