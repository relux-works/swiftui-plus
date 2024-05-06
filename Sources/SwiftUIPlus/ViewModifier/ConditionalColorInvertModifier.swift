import SwiftUI

public extension View {
    @ViewBuilder
    func colorInvert(if condition: Bool) -> some View {
        Group {
            if condition {
                self.colorInvert()
            } else {
                self
            }
        }.animation(.linear, value: condition)
    }
}
