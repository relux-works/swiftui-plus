import SwiftUI

public extension View {
    func presentIf(_ condition: Bool) -> some View {
        self.modifier(OptionalViewModifier(condition: .constant(condition)))
    }
    func presentIf(_ condition: Binding<Bool>) -> some View {
        self.modifier(OptionalViewModifier(condition: condition))
    }
}

struct OptionalViewModifier: ViewModifier {
    @Binding var condition: Bool
    func body(content: Content) -> some View {
        if condition {
            content
        }
    }
}
