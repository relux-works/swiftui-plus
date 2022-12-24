import SwiftUI

public extension View {
    
    /// Adds an action to perform when this view appears
    /// with optional execution queue and delay specification.
    ///
    ///
    ///     var body: some View {
    ///         TextField(titleKey, text: $text)
    ///             .focused($focusedField, equals: .phoneNumber)
    ///             .onAppear {
    ///                 focusedField = .phoneNumber
    ///             } queue: { .main } delay: { 0.1 }
    ///     }
    ///
    ///
    /// - Parameter action: The action to perform. If `action` is `nil`, the
    ///   call has no effect.
    /// - Parameter queue: The queue to use for execution
    /// - Parameter delay: The time to await until execution happens
    ///
    /// - Returns: A view that triggers `action` when this view appears.
    func onAppear(
        action: @escaping () -> Void,
        queue: @escaping () -> DispatchQueue = { .main },
        delay: @escaping () -> Double = { 0 }
    ) -> some View {
        self
            .onAppear(
                perform: {
                    queue().asyncAfter(deadline: .now() + delay()) {
                        action()
                    }
                }
            )
    }
}
