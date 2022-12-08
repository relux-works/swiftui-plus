import SwiftUI

public extension View {
    func reservedLayout<ReservedLayout>(_ reservedLayout: ReservedLayout) -> some View where ReservedLayout : View {
        reservedLayout
            .overlay(self)
    }
}
