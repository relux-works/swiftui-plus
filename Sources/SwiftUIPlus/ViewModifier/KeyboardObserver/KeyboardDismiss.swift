import SwiftUI

public struct DismissKeyboardAction: Sendable {
    @MainActor
    public func callAsFunction() {
        let _ = UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

public struct DismissKeyboardKey: EnvironmentKey {
    public static let defaultValue = DismissKeyboardAction()
}

public extension EnvironmentValues {
    ///TabView height; includes bottom safe area.
    @MainActor
    var dismissKeyboard: DismissKeyboardAction {
        get {
            self[DismissKeyboardKey.self]
        }
    }
}
