import SwiftUI

public extension View {
    var asAnyView: AnyView {
        AnyView(self)
    }
}