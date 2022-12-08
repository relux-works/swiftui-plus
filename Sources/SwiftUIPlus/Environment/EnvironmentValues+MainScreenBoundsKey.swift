import SwiftUI

public struct MainScreenBoundsKey: EnvironmentKey {
    public static var defaultValue: CGRect = UIScreen.main.bounds
}

public extension EnvironmentValues {
    var bounds: CGRect {
        self[MainScreenBoundsKey.self]
    }
}
