import SwiftUI

public extension EnvironmentValues {
    var contentFrame: CGRect {
        get { self[ContentFrameEnvironmentKey.self] }
        set { self[ContentFrameEnvironmentKey.self] = newValue }
    }
}

public struct ContentFrameEnvironmentKey: EnvironmentKey {
    public static let defaultValue: CGRect = .zero
}
