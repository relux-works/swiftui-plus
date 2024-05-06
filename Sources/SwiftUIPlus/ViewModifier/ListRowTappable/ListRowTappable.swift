import Foundation

extension View {
    public var listRowTappable: some View {
        modifier(ListRowTappable())
    }
}

struct ListRowTappable: ViewModifier {
    func body(content: Content) -> some View {
        Button(action: {}) {
            content
        }
    }
}
