import SwiftUI


@available(iOS 15, macOS 11, *)
public extension View {
    
    /// Applies both accentColor and tint to a view hierarchy.
    func tintColor(_ tintColor: Color) -> some View {
        self
            .accentColor(tintColor)
            .tint(tintColor)
    }
}
