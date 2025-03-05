import SwiftUI

public extension View {
    func modifySheetContent(with bgColor: Color? = .none, cornerRadius: CGFloat? = .none) -> some View {
        self
            .modifier(BottomSheetModifier(bgColor: bgColor, cornerRadius: cornerRadius))
    }
}

public struct BottomSheetModifier: ViewModifier {
    let bgColor: Color?
    let cornerRadius: CGFloat?

    public init(
        bgColor: Color? = .none,
        cornerRadius: CGFloat? = .none
    ) {
        self.bgColor = bgColor
        self.cornerRadius = cornerRadius
    }

    public func body(content : Content) -> some View {
        content
            .cornerRadius(cornerRadius, corners: [.topLeft, .topRight])
            .onVCResolve { vc in
                if let bgColor {
                    vc.view.backgroundColor = UIColor(bgColor)
                }
                if let cornerRadius {
                    vc.view.layer.cornerRadius = cornerRadius
                    vc.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                }
            }
    }
}
