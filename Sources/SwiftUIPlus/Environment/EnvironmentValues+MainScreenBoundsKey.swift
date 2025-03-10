import SwiftUI

public struct MainScreenBoundsKey: @preconcurrency EnvironmentKey {
    @MainActor
    public static var defaultValue: CGRect = UIScreen.main.bounds
}

public extension EnvironmentValues {
    var bounds: CGRect {
        self[MainScreenBoundsKey.self]
    }
}
