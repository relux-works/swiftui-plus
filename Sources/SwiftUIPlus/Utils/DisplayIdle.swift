import SwiftUI

public struct PreventDisaplySleepKey: EnvironmentKey {
    public static let defaultValue: @Sendable (Bool)->() = { toggle in
        Task { @MainActor in
            UIApplication.shared.isIdleTimerDisabled = toggle
        }
    }
}

public extension EnvironmentValues {
    var preventDisaplySleep: (Bool)->() {
        get {
            self[PreventDisaplySleepKey.self]
        }
    }
}

public extension View {
    
    func preventingDisplaySleep() -> some View {
        self
            .onAppear {
                UIApplication.shared.isIdleTimerDisabled = true
            }
            .onDisappear {
                UIApplication.shared.isIdleTimerDisabled = false
            }
    }
    
}
