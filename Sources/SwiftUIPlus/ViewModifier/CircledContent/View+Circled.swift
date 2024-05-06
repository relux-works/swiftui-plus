import SwiftUI

extension View {
    public func circled(borderWidth : CGFloat, color: Color) -> some View {
        self
            .clipShape(Circle())
            .padding(borderWidth / 2)
            .overlay(Circle().stroke(lineWidth: borderWidth).foregroundColor(color))
    }
}