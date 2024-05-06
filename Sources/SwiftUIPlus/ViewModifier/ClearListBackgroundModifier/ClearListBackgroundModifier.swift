import Foundation

extension View {
    public func clearListBackground() -> some View {
        modifier(ClearListBackgroundModifier())
    }
}

struct ClearListBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content.scrollContentBackground(.hidden)
        } else {
            content
        }
    }
}
