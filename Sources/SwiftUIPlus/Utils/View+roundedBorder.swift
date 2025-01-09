import SwiftUI

extension View {
    public func roundedBorder(cornerRadius: CGFloat, borderColor: Color, borderWidth: CGFloat) -> some View {
        self
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(borderColor, lineWidth: borderWidth)
                .padding(borderWidth / 2)
            )
    }
}
