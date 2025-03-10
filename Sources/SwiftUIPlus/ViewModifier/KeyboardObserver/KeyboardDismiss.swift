import SwiftUI

public struct DismissKeyboardKey: EnvironmentKey {
    public static let defaultValue = { @MainActor in
        let _ = UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension DismissKeyboardKey: Sendable { }

public extension EnvironmentValues {
    ///TabView height; includes bottom safe area.
    @MainActor
    var dismissKeyboard: ()->() {
        get {
            self[DismissKeyboardKey.self]
        }
    }
}
