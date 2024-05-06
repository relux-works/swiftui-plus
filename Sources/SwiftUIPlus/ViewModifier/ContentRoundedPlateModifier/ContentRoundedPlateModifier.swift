import SwiftUI

public struct ContentRoundedPlateModifier: ViewModifier {
    private let tintColor: Color
    private let cornerRadius: CGFloat

    public init(
        tintColor: Color,
        cornerRadius: CGFloat
    ) {
        self.tintColor = tintColor
        self.cornerRadius = cornerRadius
    }

    public func body(content: Content) -> some View {
        content
            .background(tintColor)
            .cornerRadius(cornerRadius, antialiased: true)
    }
}