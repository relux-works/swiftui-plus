import SwiftUI

public struct DismissKeyboardKey: EnvironmentKey {
    public static let defaultValue = {
        let _ = UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

public extension EnvironmentValues {
    ///TabView height; includes bottom safe area.
    var dismissKeyboard: ()->() {
        get {
            self[DismissKeyboardKey.self]
        }
    }
}