import SwiftUI

struct ConditionalDrawingGroupModifier: ViewModifier {
    let enableDrawingGroup: Bool
    let opaque: Bool
    let colorMode: ColorRenderingMode

    func body(content: Content) -> some View {
        if enableDrawingGroup {
            content
                    .drawingGroup(opaque: opaque, colorMode: colorMode)
        } else {
            content
        }
    }
}

public extension View {
    func drawingGroup(
            enabled: Bool,
            opaque: Bool = false,
            colorMode: ColorRenderingMode = .nonLinear
    ) -> some View {
        self.modifier(
                ConditionalDrawingGroupModifier(
                        enableDrawingGroup: enabled,
                        opaque: opaque,
                        colorMode: colorMode
                )
        )
    }
}
