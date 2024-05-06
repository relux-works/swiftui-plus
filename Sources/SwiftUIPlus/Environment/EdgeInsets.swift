import SwiftUI

public struct SafeAreaEdgeInsetsKey: EnvironmentKey {
    public static var defaultValue: EdgeInsets {
        UIApplication.shared.windows
            .first { $0.isKeyWindow }?
            .safeAreaEdgeInsets ?? .init()
    }
}

public extension EnvironmentValues {
    ///Should only be used once UIApplication is instantiated by the system
    var safeAreaEdgeInsets: EdgeInsets {
        self[SafeAreaEdgeInsetsKey.self]
    }
}

public extension UIEdgeInsets {
    var insets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}

public extension UIWindow {
    var safeAreaEdgeInsets: EdgeInsets {
        safeAreaInsets.insets
    }
}
