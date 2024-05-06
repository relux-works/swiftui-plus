import SwiftUI

public extension View {
    func programmaticLinks(@ViewBuilder content: @escaping ()->some View) -> some View {
        self.background(content())
    }
}