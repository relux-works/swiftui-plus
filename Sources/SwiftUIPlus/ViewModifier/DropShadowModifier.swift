import SwiftUI

public extension View {
    func dropShadow(
            type: DropShadowModifier.DSType,
            radius: CGFloat,
            offset: CGPoint = .zero,
            spread: CGSize = .zero
    ) -> some View {
        self.modifier(DropShadowModifier(
                type: type,
                radius: radius,
                offset: offset,
                spread: spread
        ))
    }
}

public extension DropShadowModifier {
    enum DSType {
        case sameView(opacity: CGFloat)
        case color(c: Color)
    }
}

public struct DropShadowModifier: ViewModifier {
    private var type: DSType
    private var radius: CGFloat
    private var offset: CGPoint
    private var spread: CGSize

    public init(
            type: DSType,
            radius: CGFloat,
            offset: CGPoint,
            spread: CGSize
    ) {
        self.type = type
        self.radius = radius
        self.offset = offset
        self.spread = spread
    }

    public func body(content: Content) -> some View {
        content
                .background(
                        Group {
                            switch type {
                            case let .color(c): c
                            case let .sameView(opacity):
                                content.opacity(opacity)
                            }
                        }
                                .padding(.horizontal, -spread.width / 2)
                                .padding(.vertical, -spread.height / 2)
                                .offset(x: offset.x, y: offset.y)
                                .blur(radius: radius)
                )
    }
}